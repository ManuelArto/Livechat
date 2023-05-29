import 'package:flutter/material.dart';

import '../../widgets/gradient_background.dart';
import 'components/auth_form.dart';

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
