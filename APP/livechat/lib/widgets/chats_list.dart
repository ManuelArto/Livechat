import 'package:livechat/providers/socket_provider.dart';
import 'package:livechat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    final chats = socketProvider.chats;
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () {
            socketProvider.readChat(chats[index]["chatName"]);
            Navigator.of(context)
                .pushNamed(
                  ChatScreen.routeName,
                  arguments: chats[index]["chatName"],
                )
                .then((_) => socketProvider.currentChat = "");
          },
          child: ListTile(
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.chat_bubble),
                Positioned(
                  top: -10,
                  left: -10,
                  child: CircleAvatar(
                    maxRadius: 10.0,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      chats[index]["toRead"],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
            title: Text(
              chats[index]["chatName"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chats[index]["lastMessage"]),
            trailing: Text(chats[index]["time"]),
          ),
        ),
      ),
    );
  }
}
