import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class Settings {
  Id id = Isar.autoIncrement;

  bool darkMode = false;
  String themeString = "FlexScheme.brandBlue";
  int goalSteps = 10000;
  
  @ignore
  FlexScheme get themeScheme => FlexScheme.values.firstWhere(
        (scheme) => scheme.toString() == themeString,
      );

  @ignore
  FlexSchemeColor get schemeColor => darkMode
      ? FlexColor.schemes[themeScheme]!.dark
      : FlexColor.schemes[themeScheme]!.light;

  @ignore
  ThemeData get theme => darkMode
      ? FlexThemeData.dark(scheme: themeScheme)
      : FlexThemeData.light(scheme: themeScheme);
}
