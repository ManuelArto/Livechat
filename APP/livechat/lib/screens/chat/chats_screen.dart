import 'package:flutter/material.dart';
import 'package:livechat/models/chat/group_chat.dart';
import 'package:livechat/models/chat/messages/message.dart';
import 'package:livechat/screens/chat/forward_msg_screen.dart';
import 'package:livechat/screens/chat/group_info_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../providers/navbar_notifier.dart';
import '../../services/notification_service.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/top_bar.dart';
import 'add_group_screen.dart';
import 'components/active_users.dart';
import 'components/chat_section_page.dart';
import 'single_chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const ChatsScreen({required this.navigatorKey, super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> with AutomaticKeepAliveClientMixin {

  void _listenForNotifications(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

    NotificationService.instance.didReceiveLocalNotificationStream.stream
        .listen((event) {
          NotificationService.instance.clearAllNotification();

          Provider.of<NavbarNotifier>(context, listen: false).changePage(Pages.chatsScreen);
          chatProvider.readChat(event.payload!);

          Navigator.of(context, rootNavigator: false)
              .pushNamed(
                SingleChatScreen.routeName,
                arguments: event.payload!,
              )
              .then((_) => chatProvider.currentChat = "");
        },
    );
  }

  Route<dynamic>? _buildRoute(settings) {
    switch (settings.name) {
      case SingleChatScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => SingleChatScreen(settings.arguments as String));
      case AddGroupScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => const AddGroupScreen());
      case GroupInfoScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => GroupInfoScreen(settings.arguments as GroupChat));
      case ForwardMsgScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ForwardMsgScreen(settings.arguments as Message));
      default:
        return MaterialPageRoute(
          builder: (context) => _buildChatScreen(context),
        );
    }
  }

  Scaffold _buildChatScreen(BuildContext context) {
    _listenForNotifications(context);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const TopBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AddGroupScreen.routeName),
        child: const Icon(Icons.group_add_rounded, color: Colors.white),
      ),
      body: Stack(
        children: [
          GradienBackGround(MediaQuery.of(context).size.height * .3),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActiveUsers(screenSize),
              Expanded(child: ChatSectionPage(screenSize)),
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
