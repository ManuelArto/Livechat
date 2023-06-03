import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/sections_provider.dart';
import 'chat_sections.dart';
import 'chats_list.dart';

class ChatPages extends StatefulWidget {
  const ChatPages(this.screenSize, {Key? key}) : super(key: key);

  final Size screenSize;

  @override
  ChatPagesState createState() => ChatPagesState();
}

class ChatPagesState extends State<ChatPages> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SectionsProvider(),
      builder: (context, child) {
        SectionsProvider sectionsProvider = context.watch<SectionsProvider>();
        return Column(
          children: [
            ChatSections(
              screenSize: widget.screenSize,
              pageController: _pageController,
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
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: PageView.builder(
                  itemCount: sectionsProvider.sections.length,
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (context, index) => ChatsList(
                    section: sectionsProvider.sections[index],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
