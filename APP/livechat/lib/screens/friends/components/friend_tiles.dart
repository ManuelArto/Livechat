import 'package:flutter/material.dart';

import '../../../models/friend.dart';

// enum
enum UserTileType {A, B}

class FriendTiles extends StatelessWidget {
  const FriendTiles({
    super.key,
    required List<Friend> users,
    bool isRequest = false,
  })  : _users = users,
        _isRequest = isRequest;

  final List<Friend> _users;
  final bool _isRequest;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _users.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: index == _users.length - 1 ? 250 : 0),
        child: ListTile(
          title: Text(_users[index].username),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_users[index].imageUrl),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isRequest)
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Theme.of(context).highlightColor)
                  ),
                  child: const Text("Accept"),
                ),
              IconButton(
                splashRadius: 15,
                onPressed: () {},
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
