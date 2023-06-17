import 'package:flutter/material.dart';

import '../../../../models/friend.dart';
import '../user_tiles.dart';

class FindUsersTab extends StatelessWidget {
  FindUsersTab(String searchingString, {super.key})
      : _searchingString = searchingString;

  final String _searchingString;
  final List<Friend> _friends = List.generate(
    50,
    (index) => Friend(
      username: "Username$index",
      imageUrl: "https://picsum.photos/$index",
      email: "ciao@test.com",
      phoneNumber: "1234567890",
    ),
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

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 12.0),
          sliver: UserTiles(
            users: friendsFiltered,
            buttonText: "ADD",
          ),
        ),
      ],
    );
  }
}
