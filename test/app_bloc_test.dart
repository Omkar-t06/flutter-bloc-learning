import 'dart:typed_data' show Uint8List;
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/bloc/bloc_event.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1data = 'Omkar'.toUint8List();
final text2data = 'Tavva'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be empty',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      AppState.initial(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'Test the ability to load data',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1data),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text1data,
        error: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Throw an error in url loader and catch it.',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Test the ability to load data from more than one URL',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2data),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2data,
        error: null,
      ),
    ],
  );
}
