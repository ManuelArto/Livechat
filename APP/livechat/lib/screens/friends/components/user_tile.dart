import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/friend.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/http_requester.dart';

// ignore: constant_identifier_names
enum UserAction { ADD, ACCEPT }

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required Friend friend,
    required UserAction? action,
  })  : _friend = friend,
        _action = action;

  final Friend _friend;
  final UserAction? _action;

  void _sendFriendRequest(BuildContext context) {
    String token =
        Provider.of<AuthProvider>(context, listen: false).authUser!.token;

    HttpRequester.post(
        {},
        _action == UserAction.ADD
            ? URL_ADD_REQUEST.format(_friend.id)
            : URL_ACCEPT_REQUEST.format(_friend.id),
        token: token);

    _showSnackBar(
        context,
        _action == UserAction.ADD
            ? "Friend request sent"
            : "Friend request accepted");
  }

  void _delete(BuildContext context) {
    String token =
        Provider.of<AuthProvider>(context, listen: false).authUser!.token;

    HttpRequester.delete(
        _action == null
            ? URL_REMOVE_FRIEND.format(_friend.id)
            : URL_REMOVE_REQUEST.format(_friend.id),
        token);

    _showSnackBar(context, "Removed");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_friend.username),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_friend.imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_action != null)
            TextButton(
              onPressed: () => _sendFriendRequest(context),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).highlightColor)),
              child: Text(_action!.name),
            ),
          if (_action != UserAction.ADD) // Is a friend or a friend request
            IconButton(
              splashRadius: 15,
              onPressed: () => _delete(context),
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}
