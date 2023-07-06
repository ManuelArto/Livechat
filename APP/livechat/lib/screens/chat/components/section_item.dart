import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/sections_provider.dart';

class SectionItem extends StatelessWidget {
  const SectionItem({
    super.key,
    required this.pageController,
    required this.section,
    required this.page,
  });

  final PageController pageController;
  final String section;
  final int page;

  @override
  Widget build(BuildContext context) {
    final SectionsProvider sectionsProvider = Provider.of<SectionsProvider>(context, listen: false);
    return TextButton(
      onPressed: () => pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      ),
      onLongPress: section == "All"
          ? null
          : () async {
              if (await _deleteSectionDialog(context) == true) {
                if (section == sectionsProvider.currentSectionName) pageController.jumpToPage(page - 1);

                sectionsProvider.removeSection(section);
              }
            },
      child: Row(
        children: [
          if (sectionsProvider.currentSection == page)
            CircleAvatar(
              backgroundColor: Colors.blueGrey[900],
              radius: 6.0,
            ),
          const SizedBox(width: 10.0),
          Text(
            section,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<bool?> _deleteSectionDialog(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: Text('Are you sure to remove the section $section?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              )
            ],
          );
        });
  }
}
