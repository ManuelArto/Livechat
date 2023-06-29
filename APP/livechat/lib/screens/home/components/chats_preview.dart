import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/auth/auth_user.dart';
import '../../../models/chat/chat.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/friends_provider.dart';
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
          const SizedBox(height: 10),
          if (chats.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No chats yet', style: TextStyle(fontSize: 20)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chats.length > 3 ? 3 : chats.length,
              itemBuilder: (context, index) {
                Chat chat = chats[index];
                String time = chat.messages.last.time != null
                  ? DateFormat("jm").format(chat.messages.last.time!)
                  : "";
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.authUser.imageUrl),
                      ),
                      title: Text(chat.chatName),
                      subtitle: Text(chat.messages.last.content!),
                      trailing: Text(time),
                    ),
                    const Divider(thickness: 1),
                  ],
                );
              },
            ),
          if (chats.isNotEmpty)
            TextButton(
              onPressed: () => navbarNotifier.changePage(Pages.chatsScreen),
              child: const Text('View chats'),
            ),
        ],
      ),
    );
  }
}
