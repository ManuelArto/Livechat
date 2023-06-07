import 'package:flutter/material.dart';

import '../../widgets/gradient_background.dart';
import 'components/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const GradienBackGround(double.infinity),
          CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverFillRemaining(
                child: SafeArea(
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
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyLarge
                              ?.color,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // add a container with maximum width
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
