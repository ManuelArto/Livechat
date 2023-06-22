import 'package:flutter/material.dart';

import '../../../../models/friend.dart';
import '../dynamic_user_tiles.dart';
import '../user_tiles.dart';

class SuggestedFriendsTab extends StatelessWidget {
  SuggestedFriendsTab({Key? key}) : super(key: key);

  final List<Friend> _contacts = List.generate(
    5,
    (index) => Friend(
      username: "Username$index",
      imageUrl: "https://picsum.photos/$index",
      email: "email$index",
      phoneNumber: "phone$index",
    ),
  );  // TODO: integra contatti

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            alignment: Alignment.topLeft,
            child: Text(
              "Contacts using Livechat",
              style: TextStyle(
                fontSize: theme.textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        UserTiles(
          users: _contacts,
          action: UserAction.ADD,
          bottomPadding: false,
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            alignment: Alignment.topLeft,
            child: Text(
              "People you might know",
              style: TextStyle(
                fontSize: theme.textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const DynamicUserTiles(),
        const SliverToBoxAdapter(child: SizedBox(height: 250)),
      ],
    );
  }
}
