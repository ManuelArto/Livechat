import 'package:flutter/material.dart';
import 'package:livechat/models/chat/section.dart';

import '../models/auth/auth_user.dart';
import '../services/isar_service.dart';

class SectionsProvider with ChangeNotifier {
  AuthUser? authUser;

  List<Section> _sections = [];
  double _currentSection = 0;

  // Called everytime AuthProvider changes
  void update(AuthUser? authUser) {
    if (authUser == null) {
      _sections.clear();
      this.authUser = null;
    } else {
      this.authUser = authUser;
      _loadSectionsFromMemory();
    }
  }

  // SECTIONS

  List<String> get sections => _sections.map((section) => section.name).toList();

  void addSection(String section) {
    Section newSection = Section(section)..userId = authUser!.isarId;
    _sections.add(newSection);

    IsarService.instance.insertOrUpdate<Section>(newSection);
    notifyListeners();
  }

  void removeSection(String sectionName) {
    Section toRemove = _sections.firstWhere((section) => section.name == sectionName);

    _sections.remove(toRemove);
    IsarService.instance.delete<Section>(toRemove.id);
    notifyListeners();
  }

  // CURRENT SECTION

  double get currentSection => _currentSection;

  String get currentSectionName => _sections[_currentSection.toInt()].name;

  void updateCurrentSection(double section) {
    _currentSection = section;
    notifyListeners();
  }

  void _loadSectionsFromMemory() async {
    List<Section> sectionsList = await IsarService.instance.getAll<Section>(authUser!.isarId);
    
    if (sectionsList.isEmpty) {
      _sections = [Section("All"), Section("Friends"), Section("Family")]
        ..forEach((section) => section.userId = authUser!.isarId);

      IsarService.instance.saveAll<Section>(_sections);
    } else {
      _sections = sectionsList;
    }

    notifyListeners();
  }
}
