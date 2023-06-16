import 'package:flutter/material.dart';

import '../../../models/friend.dart';
import 'user_tile.dart';

class UserTiles extends StatelessWidget {
  const UserTiles({
    super.key,
    required List<Friend> users,
    String buttonText = "",
    bool bottomPadding = true,
  })  : _users = users,
        _buttonText = buttonText,
        _bottomPadding = bottomPadding;

  final List<Friend> _users;
  final String _buttonText;
  final bool _bottomPadding;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _users.length,
      itemBuilder: (context, index) => UserTile(
        user: _users[index],
        bottomPadding: index == _users.length - 1 && _bottomPadding ? 250 : 0,
        buttonText: _buttonText,
      ),
    );
  }
}
