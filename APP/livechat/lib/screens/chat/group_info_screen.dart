import 'package:flutter/material.dart';
import 'package:livechat/models/chat/group_chat.dart';
import 'package:livechat/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class GroupInfoScreen extends StatefulWidget {
  static const routeName = "/groupInfo";
  final GroupChat group;

  const GroupInfoScreen(this.group, {super.key});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<AuthProvider>(context, listen: false).authUser!.id;
  }

  @override
  Widget build(BuildContext context) {
    List<User> partecipants = widget.group.partecipants;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        title: Text(
          widget.group.chatName,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: partecipants.length,
              itemBuilder: (context, index) {
                final partecipant = partecipants[index];
                return _partecipantTile(partecipant);
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  ListTile _partecipantTile(User partecipant) {
    return ListTile(
      title: Text(partecipant.username),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(partecipant.imageUrl),
      ),
      trailing: _partecipantTrailing(partecipant),
    );
  }

  Widget? _partecipantTrailing(User partecipant) {
    if (partecipant.id == widget.group.admin) {
      return const Text("Admin");
    }

    if (partecipant.id != userId && userId == widget.group.admin) {
      return const IconButton(
        icon: Icon(
          Icons.remove_circle_rounded,
          color: Colors.red,
        ),
        onPressed: null,
      );
    }

    return null;
  }
}
