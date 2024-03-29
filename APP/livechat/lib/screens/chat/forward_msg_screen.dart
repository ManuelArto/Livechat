import 'package:flutter/material.dart';
import 'package:livechat/models/chat/group_chat.dart';
import 'package:livechat/models/chat/messages/message.dart';
import 'package:livechat/providers/chat_provider.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:provider/provider.dart';

import '../../models/chat/chat.dart';
import '../../providers/socket_provider.dart';

class ForwardMsgScreen extends StatefulWidget {
  static const routeName = "/forward";
  final Message message;

  const ForwardMsgScreen(this.message, {super.key});

  @override
  State<ForwardMsgScreen> createState() => _ForwardMsgScreenState();
}

class _ForwardMsgScreenState extends State<ForwardMsgScreen> {
  Set<String> chatNames = {};
  bool get canForward => chatNames.isNotEmpty;

  late UsersProvider usersProvider;

  void _sendMessages() {
    SocketProvider socketProvider =
        Provider.of<SocketProvider>(context, listen: false);
    for (String chatName in chatNames) {
      socketProvider.sendMessage(
        widget.message.content!.get(),
        widget.message.content!.type,
        chatName,
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    usersProvider = Provider.of<UsersProvider>(context);

    List<Chat> chats = Provider.of<ChatProvider>(context).chatsBySection("All");

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        title: const Text(
          "Forward a message",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: !canForward ? null : _sendMessages,
        backgroundColor:
            !canForward ? Colors.red : Theme.of(context).colorScheme.secondary,
        child: Icon(!canForward ? Icons.close : Icons.done),
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) =>
            const Divider(thickness: 0, height: 10),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return _chatTile(chat);
        },
      ),
    );
  }

  GestureDetector _chatTile(Chat chat) {
    return GestureDetector(
      onTap: () => setState(
        () => chatNames.contains(chat.chatName)
            ? chatNames.remove(chat.chatName)
            : chatNames.add(chat.chatName),
      ),
      child: ListTile(
        selected: chatNames.contains(chat.chatName),
        selectedTileColor: Colors.grey.withOpacity(0.2),
        title: Text(chat.chatName),
        leading: CircleAvatar(
          backgroundImage: chat is GroupChat
              ? const AssetImage('assets/images/group_icon.png') as ImageProvider
              : NetworkImage(usersProvider.getUser(chat.chatName)!.imageUrl),
        ),
        trailing: chatNames.contains(chat.chatName)
            ? const Icon(
                Icons.forward_rounded,
                color: Colors.blue,
              )
            : null,
      ),
    );
  }
}
