import 'package:appwrite/models.dart' as models show User;

class AuthUser {
  final String uid;
  final String email;

  const AuthUser({
    required this.uid,
    required this.email,
  });

  factory AuthUser.fromAppwrite(models.User user) {
    return AuthUser(
      uid: user.$id,
      email: user.email,
    );
  }
}
