import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/chat/chat.dart';
import '../../../models/chat/message.dart';
import '../../../providers/chat_provider.dart';
import '../single_chat_screen.dart';

class ChatsList extends StatelessWidget {
  final String section;

  const ChatsList({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    final List<Chat> chats = chatProvider.chatMessages(section);

    return chats.isEmpty
        ? Center(child: Text("No chats yet${section == 'All' ? '' : ' for $section'}"))
        : ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            Chat chat = chats[index];
            Message? lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;
            String time = lastMessage?.time != null ? DateFormat("jm").format(lastMessage!.time) : "";

            return GestureDetector(
              onTap: () {
                chatProvider.readChat(chat.chatName);
                Navigator.of(context, rootNavigator: false)
                    .pushNamed(
                      SingleChatScreen.routeName,
                      arguments: chat.chatName,
                    )
                    .then((_) => chatProvider.currentChat = "");
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
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Text(
                          "${chat.toRead}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
                title: Text(
                  chat.chatName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(lastMessage?.content ?? "No message"),
                trailing: Text(time),
              ),
            );
          },
        );
  }
}
