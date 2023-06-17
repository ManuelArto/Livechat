import 'package:flutter/material.dart';
import 'package:livechat/models/friend.dart';
import 'package:livechat/screens/friends/components/user_tiles.dart';

class FriendsTab extends StatelessWidget {
  FriendsTab({Key? key}) : super(key: key);

  final List<Friend> _friends = List.generate(
    50,
    (index) => Friend(
      username: "Username$index",
      imageUrl: "https://picsum.photos/$index",
      email: "email$index",
      phoneNumber: "phoneNumber$index",
    ),
  );

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
              "MY FRIENDS (${_friends.length})",
              style: TextStyle(
                fontSize: theme.textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        UserTiles(users: _friends),
        const SliverToBoxAdapter(child: SizedBox(height: 250)),
      ],
    );
  }
}
