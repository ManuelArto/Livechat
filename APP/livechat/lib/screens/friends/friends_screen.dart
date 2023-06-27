import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:livechat/screens/friends/components/tabs/find_users_tab.dart';
import 'package:livechat/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../../models/auth/auth_user.dart';
import '../../providers/auth_provider.dart';
import 'components/share_card.dart';
import 'components/tabs/friends_requests_tab.dart';
import 'components/tabs/friends_tab.dart';
import 'components/tabs/suggested_friends_tab.dart';

class FriendsScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const FriendsScreen({required this.navigatorKey, Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with AutomaticKeepAliveClientMixin {
  String _searchString = "";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () {
        setState(() => _searchString = _searchController.text);
        if (_searchString.isEmpty) FocusScope.of(context).unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AuthUser user = Provider.of<AuthProvider>(context, listen: false).authUser!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const TopBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SearchBar(
              hintText: "Find a new friend",
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              textStyle: MaterialStateProperty.all(
                const TextStyle(backgroundColor: Colors.transparent),
              ),
              controller: _searchController,
              leading: const Icon(Icons.search_rounded),
              trailing: _searchController.text.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: _searchController.clear
                      ),
                    ]
                  : null,
            ),
            if (_searchString.isEmpty) ...[
              ShareCard(user: user),
              Expanded(
                child: FloatingTabBar(
                  children: _buildTabs(),
                  useNautics: true,
                  showTabLabelsForFloating: true,
                ),
              )
            ] else
              Expanded(child: FindUsersTab(_searchString))
          ],
        ),
      ),
    );
  }

  List<TabItem> _buildTabs() {
    return [
      const TabItem(
        onTap: null,
        title: Text("Friends"),
        selectedLeadingIcon: Icon(Icons.person_pin_rounded),
        tab: FriendsTab(),
      ),
      TabItem(
        onTap: null,
        title: const Text("Suggested"),
        selectedLeadingIcon: const Icon(Icons.emoji_people),
        tab: SuggestedFriendsTab(),
      ),
      const TabItem(
        onTap: null,
        title: Text("Requests"),
        selectedLeadingIcon: Icon(Icons.notifications),
        tab: FriendsRequestsTab(),
        // showBadge: true,
        // badgeCount: 10, // TODO: show requests count
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
