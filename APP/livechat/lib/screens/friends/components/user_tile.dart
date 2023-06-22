import 'package:flutter/material.dart';
import 'package:livechat/screens/friends/components/user_tiles.dart';

import '../../../models/friend.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required Friend user,
    required UserAction? action,
  })  : _user = user,
        _action = action;

  final Friend _user;
  final UserAction? _action;

  void _sendFriendRequest(BuildContext context) {



    // Show SNACKBAR
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Friend request sent"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_user.username),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_user.imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_action != null)
            TextButton(
              onPressed: () => _sendFriendRequest(context), // TODO: FriendsProvider send/accept request
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).highlightColor)),
              child: Text(_action!.name),
            ),
          if (_action != UserAction.ADD) // Is a friend or a friend request
            IconButton(
              splashRadius: 15,
              onPressed: () {}, // TODO: FriendsProvider remove request
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    );
  }
}
