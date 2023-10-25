import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livechat/models/chat/messages/content/audio_content.dart';
import 'package:livechat/models/chat/messages/content/file_content.dart';
import 'package:livechat/models/chat/messages/content/image_content.dart';
import 'package:livechat/models/chat/messages/content/text_content.dart';
import 'package:livechat/providers/sections_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/chat/chat.dart';
import '../../../models/chat/messages/content/content.dart';
import '../../../models/chat/messages/message.dart';
import '../../../providers/chat_provider.dart';
import '../single_chat_screen.dart';

class ChatsList extends StatelessWidget {
  final String section;

  const ChatsList({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    final List<Chat> chats = chatProvider.chatsBySection(section)..sort();

    return chats.isEmpty
        ? Center(child: Text("No chats yet${section == 'All' ? '' : ' for $section'}"))
        : ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              Chat chat = chats[index];
              Message? lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;
              String time = lastMessage?.time != null
                  ? DateFormat("jm").format(lastMessage!.time!)
                  : "";

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.0),
                  focusColor: Theme.of(context).listTileTheme.selectedTileColor,
                  onTap: () {
                    chatProvider.readChat(chat.chatName);
                    Navigator.of(context, rootNavigator: false)
                        .pushNamed(
                          SingleChatScreen.routeName,
                          arguments: chat.chatName,
                        )
                        .then((_) => chatProvider.currentChat = "");
                  },
                  onLongPress: () async {
                    final List<String>? selectedSections = await _selectSectionsDialog(context, chat);
                    if (selectedSections != null) chatProvider.updateSelectedSections(chat, selectedSections);
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
                    subtitle: getLastMessageContent(lastMessage),
                    trailing: Text(time),
                  ),
                ),
              );
            },
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

  Future<List<String>?> _selectSectionsDialog(BuildContext context, Chat chat) async {
    Size screenSize = MediaQuery.of(context).size;
    List<String> sections = Provider.of<SectionsProvider>(context, listen: false)
            .sections
            .where((section) => section != "All")
            .toList();
    List<String> selectedSections = List.of(chat.sections)
        .where((section) => section != "All")
        .toList();

    return await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text("Select sections for ${chat.chatName}"),
            content: sections.isEmpty
                ? const Center(
                    child: Text("No sections yet"),
                  )
                : SizedBox(
                    width: screenSize.width * 0.9,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: sections.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        String section = sections[index];
                        return CheckboxListTile(
                          value: selectedSections.contains(section),
                          onChanged: (bool? value) {
                            if (value == null) return;
                            setState(() =>
                                value && !selectedSections.contains(section)
                                    ? selectedSections.add(section)
                                    : selectedSections.remove(section));
                          },
                          title: Text(section),
                        );
                      },
                    ),
                  ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                  child: const Text('Save'),
                  onPressed: () => Navigator.of(context).pop(selectedSections))
            ],
          ),
        );
      },
    );
  }
}
