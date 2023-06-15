import 'package:flutter/material.dart';

import '../../../models/friend.dart';

class FriendTiles extends StatelessWidget {
  const FriendTiles({
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _users.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
            bottom: index == _users.length - 1 && _bottomPadding ? 250 : 0),
        child: ListTile(
          title: Text(_users[index].username),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_users[index].imageUrl),
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
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
