import 'package:flutter/foundation.dart' show immutable;
import 'package:appwrite/appwrite.dart';
import 'dart:developer' as devtools show log;

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  /// Factory method to handle known and unknown authentication errors
  factory AuthError.from(Exception exception) {
    devtools.log('Appwrite Error: $exception');
    if (exception is AppwriteException) {
      return authErrorMapping[exception.type] ??
          AuthErrorUnknown(exception: exception);
    } else {
      return const GenericAuthError();
    }
  }
}

/// Mapping Appwrite error codes to specific AuthError classes
const Map<String, AuthError> authErrorMapping = {
  'user_invalid_credentials': AuthErrorInvalidCredentials(),
  'general_argument_invalid': AuthErrorInvalidArgument(),
  'user_not_found': AuthErrorUserNotFound(),
  'user_already_exists': AuthErrorUserAlreadyExists(),
  'user_password_reset_required': AuthErrorPasswordResetRequired(),
};

/// Generic Authentication Error (For non-Appwrite exceptions)
@immutable
class GenericAuthError extends AuthError {
  const GenericAuthError()
      : super(
          dialogTitle: 'Unexpected Error',
          dialogText: 'An unexpected error occurred. Please try again later.',
        );
}

/// Unknown Authentication Error (Catches Appwrite exceptions not in `authErrorMapping`)
@immutable
class AuthErrorUnknown extends AuthError {
  final AppwriteException exception;

  AuthErrorUnknown({required this.exception})
      : super(
          dialogTitle: 'Authentication Error',
          dialogText: exception.message ?? 'An unknown error occurred.',
        );
}

/// Specific Authentication Errors
@immutable
class AuthErrorInvalidCredentials extends AuthError {
  const AuthErrorInvalidCredentials()
      : super(
          dialogTitle: 'Invalid Credentials',
          dialogText: 'Incorrect email or password. Please try again.',
        );
}

@immutable
class AuthErrorInvalidArgument extends AuthError {
  const AuthErrorInvalidArgument()
      : super(
          dialogTitle: 'Invalid Input',
          dialogText:
              'Invalid email or password format. Please check your credentials.',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User Not Found',
          dialogText: 'No user found with the provided credentials.',
        );
}

@immutable
class AuthErrorUserAlreadyExists extends AuthError {
  const AuthErrorUserAlreadyExists()
      : super(
          dialogTitle: 'User Already Exists',
          dialogText: 'An account with this email already exists.',
        );
}

@immutable
class AuthErrorPasswordResetRequired extends AuthError {
  const AuthErrorPasswordResetRequired()
      : super(
          dialogTitle: 'Password Reset Required',
          dialogText:
              'Your password needs to be reset. Please reset your password to continue.',
        );
}
