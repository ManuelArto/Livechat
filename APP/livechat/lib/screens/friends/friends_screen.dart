import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:livechat/screens/friends/components/suggested_friends_tab.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';
import 'components/share_card.dart';

class FriendsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const FriendsScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with AutomaticKeepAliveClientMixin {
  late Size screenSize;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenSize = MediaQuery.of(context).size;
    AuthUser user = Provider.of<AuthProvider>(context).authUser!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SearchBar(
              hintText: "Add or find a friend",
              textStyle: MaterialStateProperty.all(
                  const TextStyle(backgroundColor: Colors.transparent)),
              leading: const Icon(Icons.search_rounded),
            ),
            ShareCard(user: user),
            Expanded(
              child: FloatingTabBar(
                children: _buildTabs(),
                useNautics: true,
                showTabLabelsForFloating: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TabItem> _buildTabs() {
    return [
      const TabItem(
        onTap: null,
        title: Text("Suggested"),
        selectedLeadingIcon: Icon(Icons.emoji_people),
        tab: SuggestedFriendsTab(),
      ),
      const TabItem(
        onTap: null,
        title: Text("Friends"),
        selectedLeadingIcon: Icon(Icons.person_pin_rounded),
        tab: SuggestedFriendsTab(),
      ),
      const TabItem(
        onTap: null,
        title: Text("Requests"),
        selectedLeadingIcon: Icon(Icons.notifications),
        tab: SuggestedFriendsTab(),
        showBadge: true,
        badgeCount: 10,
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}