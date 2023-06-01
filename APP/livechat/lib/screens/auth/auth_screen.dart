import 'package:flutter/material.dart';

import '../../widgets/gradient_background.dart';
import 'components/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const GradienBackGround(double.infinity),
          // Add my logo image
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.05, bottom: screenSize.height * 0.02),
                  child: Image.asset('assets/images/logo_nobg.png', height: screenSize.height * 0.15),
                ),
                Text(
                  'Livechat',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.bodyLarge?.color,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    ),
                ),
                const AuthForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
