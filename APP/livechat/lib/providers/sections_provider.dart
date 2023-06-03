import 'package:flutter/material.dart';

class SectionsProvider with ChangeNotifier {
  final Map<String, List> _sections = {
    "All": [],
    "Friends": [],
    "Family": [],
  };
  double _currentPage = 0;

  List<String> get sections => _sections.keys.toList();

  void addSection(String section) {
    _sections[section] = [];
    notifyListeners();  
  }

  void addChatToSection(String section, String chatName) {
    _sections[section]!.add(chatName);
    notifyListeners();  
  }

  void removeSection(String section) {
    _sections.remove(section);
    notifyListeners();  
  }

  double get currentPage => _currentPage;

  String get currentSectioName => sections[_currentPage.toInt()];

  void updateCurrentPage(double section) {
    _currentPage = section;
    notifyListeners();
  }
}