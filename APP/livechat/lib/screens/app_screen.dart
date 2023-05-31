import 'package:flutter/material.dart';
import 'package:livechat/providers/navbar_notifier.dart';
import 'package:livechat/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/bottom_bar.dart';
import 'chat/chats_screen.dart';
import 'friends/friends_screen.dart';
import 'home/home_screen.dart';
import 'map_view/map_view_screen.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  final _tabScreens = const <Widget>[
    HomeScreen(),
    ChatsScreen(),
    MapViewScreen(),
    FriendsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavbarNotifier>(
      create: (context) => NavbarNotifier(),
      builder: (context, child) => Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: IndexedStack(
          index: Provider.of<NavbarNotifier>(context).tabIndex,
          children: _tabScreens,
        ),
      ),
    );
  }
}
