import 'package:bloc_tutorial/views/email_text_field.dart';
import 'package:bloc_tutorial/views/login_button.dart';
import 'package:bloc_tutorial/views/password_text_field.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final OnLoginTapped onLoginTapped;
  const LoginView({
    super.key,
    required this.onLoginTapped,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          const SizedBox(height: 8),
          PasswordTextField(passwordController: passwordController),
          const SizedBox(height: 8),
          LoginButton(
            emailController: emailController,
            passwordController: passwordController,
            onLoginTapped: widget.onLoginTapped,
          ),
        ],
      ),
    );
  }
}
