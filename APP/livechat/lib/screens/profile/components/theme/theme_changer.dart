import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/settings.dart';
import '../../../../providers/settings_provider.dart';

class ThemeChanger extends StatefulWidget {
  const ThemeChanger({Key? key}) : super(key: key);

  @override
  State<ThemeChanger> createState() => _ThemeChangerState();
}

class _ThemeChangerState extends State<ThemeChanger> {
  late SettingsProvider _settingsProvider;
  late Settings _settings;
  late FlexScheme _selectedScheme;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _settingsProvider = Provider.of<SettingsProvider>(context);
    _settings = _settingsProvider.settings;
    _selectedScheme = _settings.themeScheme;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showThemeChangerDialog(screenSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Change color",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  ..._buildColorSample(_settings.schemeColor),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Dark Mode",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: _settings.darkMode,
                onChanged: (bool val) => _settingsProvider.setDarkMode(val),
              ),
            )
          ],
        ),
      ],
    );
  }

  List<Widget> _buildColorSample(FlexSchemeColor schemeColor) {
    return [schemeColor.primary, schemeColor.secondary]
        .map(
          (color) => Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        )
        .toList();
  }

  Future<void> _showThemeChangerDialog(Size screenSize) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change theme color'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: screenSize.width * 0.9,
                child: ListView.builder(
                  itemCount: FlexScheme.values.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(FlexScheme.values[index].name),
                      leading: Radio(
                        value: FlexScheme.values[index],
                        groupValue: _selectedScheme,
                        onChanged: (FlexScheme? value) {
                          setState(() => _selectedScheme = value!);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildColorSample(
                          _settings.darkMode
                              ? FlexColor
                                  .schemes[FlexScheme.values[index]]!.dark
                              : FlexColor
                                  .schemes[FlexScheme.values[index]]!.light,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _settingsProvider.setNewTheme(_selectedScheme);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
