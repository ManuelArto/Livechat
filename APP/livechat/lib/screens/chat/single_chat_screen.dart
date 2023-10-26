import 'package:livechat/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import 'components/single_chat/messages/messages.dart';
import 'components/single_chat/send_message.dart';
import 'components/profile_icon.dart';

class SingleChatScreen extends StatefulWidget {
  static const routeName = "/chatScreen";
  final String chatName;

  const SingleChatScreen(this.chatName, {Key? key}) : super(key: key);

  @override
  SingleChatScreenState createState() => SingleChatScreenState();
}

class SingleChatScreenState extends State<SingleChatScreen> {

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.currentChat = widget.chatName;
    bool canChat = chatProvider.canChat(widget.chatName);

    User user = Provider.of<UsersProvider>(context).getUser(widget.chatName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        title: Text(
          widget.chatName,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(right: 10.0),
            child: ProfileIcon(user: user),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Messages(widget.chatName),
            ),
          ),
          if (canChat)
            SendMessage(widget.chatName),
        ],
      ),
    );
  }
}
