import 'package:flutter/material.dart';

class BottomBarNotifier extends ChangeNotifier {
  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  set tabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}