import 'package:livechat/widgets/auth/auth_form.dart';
import 'package:livechat/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          GradienBackGround(double.infinity),
          AuthForm(),
        ],
      ),
    );
  }
}
