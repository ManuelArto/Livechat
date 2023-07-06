import 'package:flutter/material.dart';
import 'package:livechat/models/tab_item.dart';
import 'package:livechat/providers/chat_provider.dart';
import 'package:provider/provider.dart';

import '../providers/navbar_notifier.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  final tabItemsList = const <TabItem>[
    TabItem("Home", Icons.home_rounded),
    TabItem("Chats", Icons.chat_rounded),
    TabItem("Map", Icons.location_on_rounded),
    TabItem("Friends", Icons.people_alt_rounded),
    TabItem("Profile", Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    final navbarNotifier = Provider.of<NavbarNotifier>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: tabItemsList
          .map(
            (TabItem item) => BottomNavigationBarItem(
              label: item.label,
              icon: Stack(
                children: <Widget>[
                  Icon(item.icon),
                  if (item.label == "Chats" && chatProvider.totalToRead > 0)
                    _showToReadBadge(context, chatProvider),
                ],
              ),
            ),
          )
          .toList(),
      onTap: (value) {
        if (value == navbarNotifier.tabIndex) {
          navbarNotifier.popAllRoutes(value);
        } else {
          navbarNotifier.tabIndex = value;
        }
      },
      currentIndex: navbarNotifier.tabIndex,
    );
  }

  Positioned _showToReadBadge(BuildContext context, ChatProvider chatProvider) {
    return Positioned(
      right: -1,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
        child: Text(
          "${chatProvider.totalToRead}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
