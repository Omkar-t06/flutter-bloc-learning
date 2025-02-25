import 'package:appwrite/appwrite.dart';
import 'package:bloc_tutorial/auth/auth_error.dart';
import 'package:bloc_tutorial/auth/auth_provider.dart';
import 'package:bloc_tutorial/auth/auth_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as devtools show log;

class AppwriteAuthProvider implements AuthProvider {
  final Client client = Client();
  late final Account account;

  @override
  Future<void> initialize() async {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(dotenv.get('APPWRITE_PROJECT_ID'));
    account = Account(client);
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return AuthUser.fromAppwrite(user);
    } on AppwriteException catch (e) {
      devtools.log('Appwrite Error: ${e.message}');
      throw AuthError.from(e);
    } catch (e) {
      throw GenericAuthError();
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final user = await account.get();
      return AuthUser.fromAppwrite(user);
    } on AppwriteException catch (e) {
      if (e.type == 'general_unauthorized_scope') {
        return null;
      }
      throw AuthError.from(e);
    } catch (e) {
      throw GenericAuthError();
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = await getCurrentUser();
      return user!;
    } on AppwriteException catch (e) {
      throw AuthError.from(e);
    } catch (e) {
      throw GenericAuthError();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      throw GenericAuthError();
    }
  }
}
