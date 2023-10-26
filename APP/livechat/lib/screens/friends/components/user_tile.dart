import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/friend.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/http_requester.dart';

// ignore: constant_identifier_names
enum UserAction { ADD, ACCEPT, REJECT }

class UserTile extends StatefulWidget {
  const UserTile({
    super.key,
    required Friend friend,
    required UserAction? action,
  })  : _friend = friend,
        _action = action;

  final Friend _friend;
  final UserAction? _action;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  late UsersProvider usersProvider;

  Future<void> _sendFriendRequest() async {
    String token = Provider.of<AuthProvider>(context, listen: false).authUser!.token;
    try {
      await HttpRequester.post(
          {},
          widget._action == UserAction.ADD
              ? URL_ADD_REQUEST.format(widget._friend.id)
              : URL_ACCEPT_REQUEST.format(widget._friend.id),
          token: token);

      if (widget._action == UserAction.ACCEPT) {
        
        usersProvider.deleteRequest(widget._friend.id);
      }

      _showSnackBar(
          widget._action == UserAction.ADD
              ? "Friend request sent"
              : "Friend request accepted");
    } catch (error) {
      _showSnackBar(error.toString(), isError: true);
    }
  }

  Future<void> _delete() async {
    final String token = Provider.of<AuthProvider>(context, listen: false).authUser!.token;

    try {
      await HttpRequester.delete(
          widget._action == null
              ? URL_REMOVE_FRIEND.format(widget._friend.id)
              : URL_REMOVE_REQUEST.format(widget._friend.id),
          token);
      widget._action == null
          ? usersProvider.deleteFriend(widget._friend.username)
          : usersProvider.deleteRequest(widget._friend.id);

      if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
      _showSnackBar("Removed");
    } catch (error) {
      _showSnackBar(error.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    usersProvider = Provider.of<UsersProvider>(context, listen: false);

    return ListTile(
      title: Text(widget._friend.username),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget._friend.imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget._action != null && widget._action != UserAction.REJECT)
            TextButton(
              onPressed: _sendFriendRequest,
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).highlightColor)),
              child: Text(widget._action!.name),
            ),
          if (widget._action != UserAction.ADD) // Is a friend or a friend request
            IconButton(
              splashRadius: 15,
              onPressed: _delete,
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    );
  }

  void _showSnackBar(String text, {bool isError = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }
}
