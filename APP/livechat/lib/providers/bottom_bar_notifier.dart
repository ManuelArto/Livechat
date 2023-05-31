import 'package:flutter/material.dart';

import '../screens/chat/chats_screen.dart';
import '../screens/friends/friends_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/map_view/map_view_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomBarNotifier extends ChangeNotifier {
  int _tabIndex = 0;
  final _tabScreens = const <Widget>[
    HomeScreen(),
    ChatsScreen(),
    MapViewScreen(),
    FriendsScreen(),
    ProfileScreen(),
  ];

  List<Widget> get tabScreens => _tabScreens;

  int get tabIndex => _tabIndex;

  set tabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void changePage(Pages page) =>tabIndex = page.index;

}

enum Pages { homeScreen, chatsScreen, mapViewScreen, friendsScreen, profileScreen }