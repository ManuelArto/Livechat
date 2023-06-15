import 'package:flutter/material.dart';
import 'package:livechat/models/friend.dart';
import 'package:livechat/screens/friends/components/friend_tiles.dart';

class FriendsTab extends StatelessWidget {
  FriendsTab({Key? key}) : super(key: key);

  final List<Friend> _friends = List.generate(
    50,
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
              "MY FRIENDS (${_friends.length})",
              style: TextStyle(
                fontSize: theme.textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FriendTiles(users: _friends)
        ],
      ),
    );
  }
}
