import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat/chat.dart';
import '../../../../models/chat/group_chat.dart';
import '../../../../models/chat/messages/content/audio_content.dart';
import '../../../../models/chat/messages/content/content.dart';
import '../../../../models/chat/messages/content/file_content.dart';
import '../../../../models/chat/messages/content/image_content.dart';
import '../../../../models/chat/messages/content/text_content.dart';
import '../../../../models/chat/messages/message.dart';
import '../../../../providers/chat_provider.dart';
import '../../../../providers/users_provider.dart';
import '../../../../providers/navbar_notifier.dart';

class PreviewChats extends StatefulWidget {
  const PreviewChats({super.key});

  @override
  State<PreviewChats> createState() => _PreviewChatsState();
}

class _PreviewChatsState extends State<PreviewChats> {
  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);

    final ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    final List<Chat> chats = chatProvider.chatsBySection("All")..sort();

    NavbarNotifier navbarNotifier = Provider.of<NavbarNotifier>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Recent Chats',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Divider(thickness: 1),
          if (chats.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No chats yet', style: TextStyle(fontSize: 20)),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chats.length > 3 ? 3 : chats.length,
                separatorBuilder: (context, index) =>
                    index == 2 ? Container() : const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  Chat chat = chats[index];
                  Message? lastMessage =
                      chat.messages.isNotEmpty ? chat.messages.last : null;
                  String time = lastMessage?.time != null
                      ? DateFormat("jm").format(lastMessage!.time!)
                      : "";
                  return ListTile(
                    leading: chat is GroupChat
                        ? null
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                              usersProvider.getUser(chat.chatName).imageUrl,
                            ),
                          ),
                    title: Text(chat.chatName),
                    subtitle: getLastMessageContent(lastMessage),
                    trailing: Text(time),
                  );
                },
              ),
            ),
          if (chats.isNotEmpty) ...[
            const Divider(thickness: 1),
            TextButton(
              onPressed: () => navbarNotifier.changePage(Pages.chatsScreen),
              child: const Text('View chats'),
            ),
          ],
        ],
      ),
    );
  }

  Widget getLastMessageContent(Message? lastMessage) {
    textWidget(message) => Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

    if (lastMessage == null || lastMessage.content == null) return textWidget("No message");

    Content content = lastMessage.content!;

    if (content is TextContent) return textWidget(content.get());

    IconData? icon;
    String message = "";

    if (content is AudioContent) {
      message = "Audio message";
      icon = Icons.music_note;
    }
    if (content is FileContent) {
      message = "File message";
      icon = Icons.file_copy;
    }
    if (content is ImageContent) {
      message = "Media message";
      icon = Icons.image;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: 16),
        textWidget(message),
      ],
    );
  }
}
