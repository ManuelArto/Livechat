import 'package:flutter/material.dart';

import '../../widgets/gradient_background.dart';
import 'components/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          GradienBackGround(double.infinity),
          AuthForm(),
        ],
      ),
    );
  }
}
