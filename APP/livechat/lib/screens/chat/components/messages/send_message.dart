import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  final String chatName;

  const SendMessage(this.chatName, {Key? key}) : super(key: key);

  @override
  SendMessageState createState() => SendMessageState();
}

class SendMessageState extends State<SendMessage> {
  final _controller = TextEditingController();
  late SocketProvider chatProvider;
  String? username;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<SocketProvider>(context, listen: false);
    username =
        Provider.of<AuthProvider>(context, listen: false).authUser?.username;
  }

  void _sendMessage() {
    chatProvider.sendMessage(_controller.text, widget.chatName);
    setState(() => _controller.text = "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: ListTile(
        // leading: IconButton(
        //   icon: Icon(Icons.image),
        //   onPressed: () {},
        // ),
        title: TextField(
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          enableSuggestions: true,
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Type a message...",
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.grey[200],
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() {}),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: _controller.text.trim().isEmpty ? null : _sendMessage,
          ),
        ),
      ),
    );
  }
}
