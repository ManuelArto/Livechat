import 'dart:async';

import 'package:flutter/material.dart';

enum Pages { homeScreen, chatsScreen, mapViewScreen, friendsScreen, profileScreen }

class NavbarNotifier extends ChangeNotifier {
  int _tabIndex = 0;
  final List<GlobalKey<NavigatorState>> keys;

  NavbarNotifier(this.keys);

  int get tabIndex => _tabIndex;

  set tabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void changePage(Pages page) => tabIndex = page.index;

  // only if the backButton is pressed on the initial route the app will be terminated
  FutureOr<bool> onBackButtonPressed() async {
    if (keys[_tabIndex].currentState != null && keys[_tabIndex].currentState!.canPop()) {
      keys[_tabIndex].currentState!.pop();
      return false;
    }

    return true;
  }

  // pops all routes except first, if there are more than 1 route in each navigator stack
  void popAllRoutes(int index) {
    if (keys[index].currentState != null && keys[index].currentState!.canPop()) {
      keys[index].currentState!.popUntil((route) => route.isFirst);
    }
  }

}
