import 'package:livechat/models/sections.dart';
import 'package:livechat/widgets/chats_list.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatefulWidget {
  const MessagesList(this.screenSize, {super.key});

  final Size screenSize;

  @override
  MessagesListState createState() => MessagesListState();
}

class MessagesListState extends State<MessagesList> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentSection = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
          height: widget.screenSize.height * .1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSection("Messages", 0, context),
              buildSection("Groups", 1, context),
              DropdownButton<String>(
                elevation: 0,
                hint: const Text(
                  "Sections",
                  style: TextStyle(color: Colors.white),
                ),
                items: Sections.sections
                    .map(
                      (section) => DropdownMenuItem<String>(
                        value: section,
                        child: Row(
                          children: [
                            Text(section),
                            if (_currentSection == Sections.getIndex(section))
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                radius: 6.0,
                              ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (section) => _pageController.animateToPage(
                  Sections.getIndex(section!),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              ),
              Flexible(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.4),
                  ),
                  onPressed: () async {
                    final String? section = await _showDialog();
                    if (section != null && section.isNotEmpty) {
                      setState(() => Sections.addSection(section));
                    }
                  },
                  child: const FittedBox(
                    child: Text(
                      "Create\nSection",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            color: Colors.white,
          ),
          height: widget.screenSize.height * .6,
          child: PageView(
            physics: const ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentSection = page;
              });
            },
            children: [
              ChatsList(),
              const Center(
                child: Text("Groups"),
              ),
              ...Sections.sections
                  .map(
                    (section) => Center(
                      child: Text(section),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  Future<String?> _showDialog() async {
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
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'New Section',
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: const Text('SAVE'),
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                })
          ],
        );
      },
    );
  }

  TextButton buildSection(String section, int page, BuildContext context) {
    return TextButton(
      onPressed: () => _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      ),
      child: Row(
        children: [
          if (_currentSection == page)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 6.0,
            ),
          const SizedBox(width: 5.0),
          Text(
            section,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
