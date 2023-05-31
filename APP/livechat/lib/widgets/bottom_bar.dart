import 'package:flutter/material.dart';
import 'package:livechat/models/tab_item.dart';
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
    final bottomBarNotifier = Provider.of<NavbarNotifier>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: tabItemsList
          .map((TabItem item) =>
              BottomNavigationBarItem(label: item.label, icon: Icon(item.icon)))
          .toList(),
      onTap: (value) => {bottomBarNotifier.tabIndex = value},
      currentIndex: bottomBarNotifier.tabIndex,
    );
  }
}
