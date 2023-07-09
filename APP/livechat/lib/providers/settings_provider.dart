import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../services/isar_service.dart';
import '../models/settings.dart';

class SettingsProvider extends ChangeNotifier {
  late Settings settings;

  void setDarkMode(bool enabled) {
    settings.darkMode = enabled;

    IsarService.instance.insertOrUpdate<Settings>(settings);
    notifyListeners();
  }

  void setNewTheme(FlexScheme selectedScheme) {
    settings.themeString = selectedScheme.toString();

    IsarService.instance.insertOrUpdate<Settings>(settings);
    notifyListeners();
  }

  void setNewGoalSteps(int goalSteps) {
    settings.goalSteps = goalSteps;

    IsarService.instance.insertOrUpdate<Settings>(settings);
    notifyListeners();
  }

  Future<void> loadSettings() async {
    Settings? settings = await IsarService.instance.getSettings();
    if (settings == null) {
      this.settings = Settings();

      await IsarService.instance.insertOrUpdate<Settings>(this.settings);
    } else {
      this.settings = settings;
    }

    return;
  }
}
