import 'package:flutter/foundation.dart' show immutable;
import 'package:bloc_tutorial/auth/auth_user.dart';

@immutable
abstract class AuthProvider {
  Future<void> initialize();
  Future<AuthUser?> getCurrentUser();

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logout();
}
