import 'package:flutter/material.dart';

class NavbarNotifier extends ChangeNotifier {
  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  set tabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void changePage(Pages page) =>tabIndex = page.index;

}

enum Pages { homeScreen, chatsScreen, mapViewScreen, friendsScreen, profileScreen }