import 'package:flutter/material.dart';
import 'package:livechat/models/friend.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:livechat/screens/friends/components/user_tiles.dart';
import 'package:provider/provider.dart';

class FriendsTab extends StatelessWidget {
  const FriendsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Friend> friends = Provider.of<UsersProvider>(context).friends;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            alignment: Alignment.topLeft,
            child: Text(
              "MY FRIENDS (${friends.length})",
              style: TextStyle(
                fontSize: theme.textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        friends.isEmpty
            ? const SliverFillRemaining(
                child: Center(
                  child: Text("No friends yet"),
                ),
              )
            : UserTiles(users: friends),
        const SliverToBoxAdapter(child: SizedBox(height: 250)),
      ],
    );
  }
}
