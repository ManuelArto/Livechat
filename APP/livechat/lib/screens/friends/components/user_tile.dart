

import 'package:flutter/material.dart';

import '../../../models/friend.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required Friend user,
    required double bottomPadding,
    required String buttonText,
  })  : _user = user,
        _bottomPadding = bottomPadding,
        _buttonText = buttonText;

  final Friend _user;
  final double _bottomPadding;
  final String _buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: _bottomPadding),
      child: ListTile(
        title: Text(_user.username),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_user.imageUrl),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_buttonText.isNotEmpty)
              TextButton(
                onPressed: () {}, // TODO: FriendsProvider accept requests
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).highlightColor)),
                child: Text(_buttonText),
              ),
            if (_buttonText != "ADD")
              IconButton(
                splashRadius: 15,
                onPressed: () {}, // TODO: FriendsProvider remove requests
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
      ),
    );
  }
}
