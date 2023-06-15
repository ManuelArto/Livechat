import 'package:flutter/material.dart';

import '../../../models/friend.dart';
import 'friend_tiles.dart';

class SuggestedFriendsTab extends StatelessWidget {
  SuggestedFriendsTab({Key? key}) : super(key: key);

  final List<Friend> _suggested = List.generate(
    50,
    (index) => Friend(
        username: "Username$index", imageUrl: "https://picsum.photos/$index"),
  );

  final List<Friend> _contacts = List.generate(
    5,
    (index) => Friend(
        username: "Username$index", imageUrl: "https://picsum.photos/$index"),
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
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
          FriendTiles(
            users: _contacts,
            buttonText: "ADD",
            bottomPadding: false,
          ),
          Container(
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
          FriendTiles(
            users: _contacts,
            buttonText: "ADD",
          )
        ],
      ),
    );
  }
}
