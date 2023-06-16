import 'package:flutter/material.dart';

import '../../widgets/gradient_background.dart';
import 'components/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const GradienBackGround(double.infinity),
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.02),
                      child: Image.asset('assets/images/logo_nobg.png',
                          height: screenSize.height * 0.12),
                    ),
                    Text(
                      'Livechat',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.bodyLarge?.color,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: screenSize.width > screenSize.height
                                ? screenSize.width * 0.4
                                : double.infinity),
                        child: const AuthForm(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
