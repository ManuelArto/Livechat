import 'package:flutter/material.dart';

class SectionsProvider with ChangeNotifier {
  final List<String> _sections = [
    "All",
    "Friends",
    "Family",
  ];
  double _currentSection = 0;

  List<String> get sections => _sections;

  void addSection(String section) {
    _sections.add(section);
    notifyListeners();  
  }

  void removeSection(String section) {
    _sections.remove(section);
    notifyListeners();  
  }

  double get currentSection => _currentSection;

  String get currentSectioName => sections[_currentSection.toInt()];

  void updateCurrentSection(double section) {
    _currentSection = section;
    notifyListeners();
  }
}