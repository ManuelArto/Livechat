import 'package:livechat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:livechat/screens/chat/single_chat_screen.dart';

import 'package:provider/provider.dart';

import '../../widgets/gradient_background.dart';
import '../../widgets/top_bar.dart';
import 'components/active_users.dart';
import 'components/chats_section.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  Scaffold _buildChatScreen(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const TopBar(),
      body: Stack(
        children: [
          GradienBackGround(MediaQuery.of(context).size.height * .3),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActiveUsers(screenSize),
              ChatsSection(screenSize),
            ],
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    Provider.of<SocketProvider>(context, listen: false).init();
    return Navigator(
      key: key,
      initialRoute: '/',
      onGenerateRoute: _buildRoute,
    );
  }
}
