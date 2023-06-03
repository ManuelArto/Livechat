import 'package:flutter/material.dart';
import 'package:livechat/providers/chat_provider.dart';
import 'package:livechat/providers/navbar_notifier.dart';
import 'package:livechat/providers/friends_provider.dart';
import 'package:livechat/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import '../providers/socket_provider.dart';
import '../widgets/bottom_bar.dart';
import 'chat/chats_screen.dart';
import 'friends/friends_screen.dart';
import 'home/home_screen.dart';
import 'map_view/map_view_screen.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  // TODO: add AutomaticKeepAliveClientMixin
  final _tabScreens = const <Widget>[
    HomeScreen(),
    ChatsScreen(),
    MapViewScreen(),
    FriendsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final SocketProvider socketProvider = Provider.of<SocketProvider>(context, listen: false)..init();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavbarNotifier>(
          create: (_) => NavbarNotifier(),
        ),
        ChangeNotifierProvider<FriendsProvider>(
          create: (_) {
              FriendsProvider friendsProvider = FriendsProvider();
              socketProvider.friendsProvider = friendsProvider;
              return friendsProvider;
            },
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) {
              ChatProvider chatProvider = ChatProvider();
              socketProvider.chatProvider = chatProvider;
              return chatProvider;
            },
        ),
      ],
      builder: (context, child) => Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: IndexedStack(
          index: context.watch<NavbarNotifier>().tabIndex,
          children: _tabScreens,
        ),
      ),
    );
  }
}
