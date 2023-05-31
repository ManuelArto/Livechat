import 'package:livechat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:livechat/screens/chat/single_chat_screen.dart';

import 'package:provider/provider.dart';

import '../../widgets/gradient_background.dart';
import '../../widgets/top_bar.dart';
import 'components/active_users.dart';
import 'components/chats_section.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SocketProvider>(context, listen: false).init();
    final screenSize = MediaQuery.of(context).size;
    return Navigator(
      key: key,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SingleChatScreen.routeName:
            return MaterialPageRoute(
                builder: (context) =>
                    SingleChatScreen(settings.arguments as String));
          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: const TopBar(),
                body: Stack(
                  children: [
                    GradienBackGround(MediaQuery.of(context).size.height * .7),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ActiveUsers(screenSize),
                          ChatsSection(screenSize),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
