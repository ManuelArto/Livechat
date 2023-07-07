import 'package:flutter/material.dart';
import 'package:livechat/providers/sections_provider.dart';
import 'package:livechat/screens/chat/components/section_item.dart';
import 'package:provider/provider.dart';

class ChatSections extends StatefulWidget {
  const ChatSections({
    super.key,
    required this.screenSize,
    required this.pageController,
  });

  final Size screenSize;
  final PageController pageController;

  @override
  State<ChatSections> createState() => _ChatSectionsState();
}

class _ChatSectionsState extends State<ChatSections> {
  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(
      () => context.read<SectionsProvider>().updateCurrentSection(widget.pageController.page!)
    );
  }

  @override
  Widget build(BuildContext context) {
    final SectionsProvider sectionsProvider =
        Provider.of<SectionsProvider>(context);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
      height: widget.screenSize.height * .1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sectionsProvider.sections.length,
              itemBuilder: (context, index) => SectionItem(
                pageController: widget.pageController,
                section: sectionsProvider.sections[index],
                page: index,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(5),
              shape: const CircleBorder(),
            ),
            onPressed: () async {
              final String? section = await _newSectionDialog();
              if (section != null && section.isNotEmpty) {
                if (!sectionsProvider.sections.contains(section)) {
                  sectionsProvider.addSection(section);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Section already created"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Icon(Icons.new_label),
          ),
        ],
      ),
    );
  }

  Future<String?> _newSectionDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: "Section name",
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                })
          ],
        );
      },
    );
  }
}
