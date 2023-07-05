import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/auth/auth_user.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/messages/content/audio_content.dart';
import '../../../models/chat/messages/content/content.dart';
import '../../../models/chat/messages/content/file_content.dart';
import '../../../models/chat/messages/content/image_content.dart';
import '../../../models/chat/messages/content/text_content.dart';
import '../../../models/chat/messages/message.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/navbar_notifier.dart';

class ChatsPreview extends StatefulWidget {
  const ChatsPreview({
    Key? key,
    required this.authUser,
  }) : super(key: key);

  final AuthUser authUser;

  @override
  State<ChatsPreview> createState() => _ChatsPreviewState();
}

class _ChatsPreviewState extends State<ChatsPreview> {
  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    final List<Chat> chats = chatProvider.chatsBySection("All");
    NavbarNotifier navbarNotifier =
        Provider.of<NavbarNotifier>(context, listen: false);

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
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chats.length > 3 ? 3 : chats.length,
                itemBuilder: (context, index) {
                  Chat chat = chats[index];
                  Message? lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;
                  Content? content = lastMessage!.content;
                  String time = lastMessage.time != null
                      ? DateFormat("jm").format(lastMessage.time!)
                      : "";
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.authUser.imageUrl),
                        ),
                        title: Text(chat.chatName),
                        subtitle: content is TextContent ? Text(getLastMessageContent(lastMessage, content))  
                        : Row(
                            children: [
                              Icon(content is AudioContent ? Icons.music_note
                                : content is FileContent ? Icons.file_copy 
                                : content is ImageContent ? Icons.image : null),
                              Text(getLastMessageContent(lastMessage, content)),
                            ],
                          ),
                        trailing: Text(time),
                      ),
                      const Divider(thickness: 1),
                    ],
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

  String getLastMessageContent(Message? lastMessage, Content? content) {
    if (lastMessage == null || lastMessage.content == null) return "No message";

    if (content is TextContent) return content.get();
    if (content is AudioContent) return "Audio received";
    if (content is FileContent) return "File received";
    if (content is ImageContent) return "Media message";
    
    return "";
  }
}
