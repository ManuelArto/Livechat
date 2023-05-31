import 'package:flutter/material.dart';
import 'package:livechat/providers/bottom_bar_provider.dart';
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
    return ChangeNotifierProvider<BottomBarNotifier>(
      create: (context) => BottomBarNotifier(),
      builder: (context, child) => Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: IndexedStack(
          index: Provider.of<BottomBarNotifier>(context).tabIndex,
          children: _tabScreens,
        ),
      ),
    );
  }
}
