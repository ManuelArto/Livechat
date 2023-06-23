import 'package:flutter/material.dart';

import '../../../models/friend.dart';
import 'user_tile.dart';

class UserTiles extends StatelessWidget {
  const UserTiles({
    super.key,
    required List<Friend> users,
    UserAction? action,
    bool bottomPadding = true,
  })  : _users = users,
        _action = action;

  final List<Friend> _users;
  final UserAction? _action;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _users.length,
      itemBuilder: (context, index) => UserTile(
        friend: _users[index],
        action: _action,
      ),
    );
  }
}
