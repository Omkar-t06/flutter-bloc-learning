import 'dart:async';

import 'package:bloc_tutorial/dialog/loading_screen_controller.dart';
import 'package:flutter/material.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen shared = LoadingScreen._sharedInstance();

  factory LoadingScreen.instance() => shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textStream = StreamController<String>();
    textStream.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<String>(
                          stream: textStream.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!,
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return const SizedBox();
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textStream.close();
        overlay.remove();
        return true;
      },
      update: (String text) {
        textStream.add(text);
        return true;
      },
    );
  }
}
