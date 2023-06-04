import 'package:flutter/material.dart';

import '../../widgets/gradient_background.dart';
import '../../widgets/top_bar.dart';
import 'components/active_users.dart';
import 'components/chat_pages.dart';
import 'single_chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ChatsScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with AutomaticKeepAliveClientMixin{
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
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      body: Stack(
        children: [
          GradienBackGround(MediaQuery.of(context).size.height * .3),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActiveUsers(screenSize),
              Expanded(child: ChatPages(screenSize)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: _buildRoute,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
