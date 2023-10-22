import 'package:flutter/material.dart';
import 'package:livechat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/sections_provider.dart';
import 'chat_sections.dart';
import 'chats_list.dart';

class ChatSectionPage extends StatefulWidget {
  const ChatSectionPage(this.screenSize, {Key? key}) : super(key: key);

  final Size screenSize;

  @override
  ChatSectionPageState createState() => ChatSectionPageState();
}

class ChatSectionPageState extends State<ChatSectionPage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProxyProvider<AuthProvider, SectionsProvider>(
      create: (_) => SectionsProvider(),
      update: (context, auth, sectionsProvider) => sectionsProvider!..update(auth.authUser),
      builder: (context, child) {
        SectionsProvider sectionsProvider = context.watch<SectionsProvider>();
        return Column(
          children: [
            ChatSections(
              screenSize: widget.screenSize,
              pageController: _pageController,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Theme.of(context).dialogBackgroundColor
                ),
                height: widget.screenSize.height * .6,
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
