import 'package:flutter/material.dart';

import '../../widgets/gradient_background.dart';
import '../../widgets/top_bar.dart';
import 'components/active_users.dart';
import 'components/chat_pages.dart';
import 'single_chat_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  Route<dynamic>? _buildRoute(settings) {
    switch (settings.name) {
      case SingleChatScreen.routeName:
        return MaterialPageRoute(
            builder: (context) =>
                SingleChatScreen(settings.arguments as String));
      default:
        return MaterialPageRoute(
          builder: (context) => _buildChatScreen(context),
        );
    }
  }

  Scaffold _buildChatScreen(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const TopBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // TODO: navigate to find chat and create group like whatsapp
        child: const Icon(Icons.chat),
      ),
      body: Stack(
        children: [
          GradienBackGround(MediaQuery.of(context).size.height * .3),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActiveUsers(screenSize),
                ChatPages(screenSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: key,
      initialRoute: '/',
      onGenerateRoute: _buildRoute,
    );
  }
}
