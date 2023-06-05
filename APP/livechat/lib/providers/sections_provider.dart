import 'package:flutter/material.dart';
import 'package:livechat/models/chat/section.dart';
import 'package:livechat/services/isar_service.dart';

import '../models/auth/auth_user.dart';

class SectionsProvider with ChangeNotifier {
  final IsarService isar;
  final AuthUser authUser;

  List<Section> _sections = [];
  double _currentSection = 0;

  SectionsProvider(this.isar, this.authUser) {
    _loadSectionsFromMemory();
  }

  List<String> get sections =>
      _sections.map((section) => section.name).toList();

  void addSection(String section) {
    Section newSection = Section(section)..authUser.value = authUser;
    _sections.add(newSection);

    isar.insertOrUpdate<Section>(newSection);
    notifyListeners();
  }

  void removeSection(String sectionName) {
    Section toRemove =
        _sections.firstWhere((section) => section.name == sectionName);

    _sections.remove(toRemove);
    isar.delete<Section>(toRemove.id);
    notifyListeners();
  }

  double get currentSection => _currentSection;

  String get currentSectioName => _sections[_currentSection.toInt()].name;

  void updateCurrentSection(double section) {
    _currentSection = section;
    notifyListeners();
  }

  void _loadSectionsFromMemory() async {
    List<Section> sectionsList = await isar.getAll<Section>();
    if (sectionsList.isEmpty) {
      _sections = [Section("All"), Section("Friends"), Section("Family")]
        ..forEach((section) => section.authUser.value = authUser);
      isar.saveAll<Section>(_sections);
      
    } else {
      _sections = sectionsList;
    }

    notifyListeners();
  }
}
