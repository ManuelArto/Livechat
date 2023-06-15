import 'package:flutter/material.dart';

import '../../../models/friend.dart';
import 'friend_tiles.dart';

class FindFriendsTab extends StatelessWidget {
  FindFriendsTab(String searchingString, {super.key})
      : _searchingString = searchingString;

  final String _searchingString;
  final List<Friend> _friends = List.generate(
    50,
    (index) => Friend(
        username: "Username$index", imageUrl: "https://picsum.photos/$index"),
  );

  @override
  Widget build(BuildContext context) {
    List<Friend> friendsFiltered = _friends
        .where(
          (friends) => friends.username
              .toLowerCase()
              .contains(_searchingString.toLowerCase()),
        )
        .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: FriendTiles(
          users: friendsFiltered,
          buttonText: "ADD",
        ),
      ),
    );
  }
}
