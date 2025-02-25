import 'package:bloc_tutorial/auth/auth_error.dart';
import 'package:bloc_tutorial/auth/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? error;

  const AppState({required this.isLoading, this.error});
}

@immutable
class AppStateLoggedIn extends AppState {
  final AuthUser user;
  final List<String> images; // List of image URLs

  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required super.isLoading,
    super.error,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppStateLoggedIn &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          user.uid == other.user.uid &&
          images.length == other.images.length;

  @override
  int get hashCode => Object.hash(user.uid, images);

  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({required super.isLoading, super.error});

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, error = $error';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({required super.isLoading, super.error});

  @override
  String toString() =>
      'AppStateIsInRegistrationView, isLoading = $isLoading, error = $error';
}

extension GetUser on AppState {
  AuthUser? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  List<String>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
