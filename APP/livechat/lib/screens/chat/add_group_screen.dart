import 'package:flutter/material.dart';
import 'package:livechat/models/friend.dart';
import 'package:livechat/providers/chat_provider.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/socket_provider.dart';
import '../../services/http_requester.dart';

class AddGroupScreen extends StatefulWidget {
  static const routeName = "/addGroup";

  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  String groupName = "";
  Set<String> partecipantIds = {};

  Future<void> _createGroup () async {
    try {
      ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

      final String token = Provider.of<AuthProvider>(context, listen: false).authUser!.token;
      Map<String, dynamic> data = await HttpRequester.post(
        {"name": groupName, "partecipants": partecipantIds.toList()},
        URL_CREATE_GROUP,
        token: token,
      );
      chatProvider.newGroupChat(data);

      Navigator.of(context).pop();
    } catch (error) {
      _showSnackBar(error.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> friends = Provider.of<UsersProvider>(context).friends;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        title: const Text(
          "Create a new group",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: canCreateGroup
            ? null
            : _createGroup,
        backgroundColor: canCreateGroup
            ? Colors.red
            : Theme.of(context).colorScheme.secondary,
        child: Icon(canCreateGroup ? Icons.close : Icons.done),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => setState(() => groupName = value),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter the group name',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return _friendTile(friend);
              },
            ),
          ),
        ],
      ),
    );
  }

  bool get canCreateGroup => groupName == "" || partecipantIds.isEmpty;

  ListTile _friendTile(Friend friend) {
    return ListTile(
      title: Text(friend.username),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(friend.imageUrl),
      ),
      trailing: IconButton(
        icon: Icon(
          partecipantIds.contains(friend.id)
              ? Icons.remove_circle_rounded
              : Icons.add_circle_rounded,
          color: partecipantIds.contains(friend.id)
              ? Colors.red
              : Colors.green,
        ),
        onPressed: partecipantIds.contains(friend.id)
            ? () => setState(() => partecipantIds.remove(friend.id))
            : () => setState(() => partecipantIds.add(friend.id)),
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
