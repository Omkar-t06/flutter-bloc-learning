import 'package:flutter/foundation.dart' show immutable;

typedef CancelLoadingScreen = bool Function();
typedef UpdatedLoadingScreenText = bool Function(String text);

@immutable
class LoadingScreenController {
  final CancelLoadingScreen close;
  final UpdatedLoadingScreenText update;

  const LoadingScreenController({required this.close, required this.update});
}
