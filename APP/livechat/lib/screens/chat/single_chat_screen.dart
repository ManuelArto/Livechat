import 'package:livechat/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:livechat/providers/friends_provider.dart';
import 'package:provider/provider.dart';

import '../../models/friend.dart';
import 'components/messages/messages.dart';
import 'components/messages/send_message.dart';
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
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false).currentChat = widget.chatName;
  }

  @override
  Widget build(BuildContext context) {
    FriendsProvider friendsProvider = Provider.of<FriendsProvider>(context);

    Friend? user = friendsProvider.isFriend(widget.chatName)
        ? Provider.of<FriendsProvider>(context).getFriend(widget.chatName)
        : null;
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
            child: user != null ? ProfileIcon(user: user) : null,
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
          if (user != null)
            SendMessage(widget.chatName),
        ],
      ),
    );
  }
}
