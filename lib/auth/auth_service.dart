import 'package:bloc_tutorial/auth/appwrite_auth_provider.dart';
import 'package:bloc_tutorial/auth/auth_provider.dart';
import 'package:bloc_tutorial/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  /// Factory constructor to initialize AuthService with AppwriteAuthProvider
  factory AuthService.appwrite() => AuthService(AppwriteAuthProvider());

  /// Initialize authentication service
  @override
  Future<void> initialize() => provider.initialize();

  /// Get the currently authenticated user
  @override
  Future<AuthUser?> getCurrentUser() => provider.getCurrentUser();

  /// Create a new user with email & password
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  /// Login user with email & password
  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  /// Logout the currently signed-in user
  @override
  Future<void> logout() => provider.logout();
}
