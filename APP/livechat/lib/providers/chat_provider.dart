import 'package:flutter/material.dart';
import 'package:livechat/models/chat/chat.dart';
import 'package:livechat/services/isar_service.dart';
import 'package:uuid/uuid.dart';

import '../models/auth/auth_user.dart';
import '../models/chat/message.dart';

class ChatProvider with ChangeNotifier {
  final IsarService isar;
  final AuthUser authUser;

  Map<String, Chat> _chats = {};
  String currentChat = "";

  ChatProvider(this.isar, this.authUser) {
    _loadChatsFromMemory();
  }

  // GETTERS

  List<Message> messages(String chatName) =>
      _chats.containsKey(chatName) ? _chats[chatName]!.messages : [];

  List<Chat> chatsBySection(String section) =>
      _chats.values.where((chat) => chat.sections.contains(section)).toList();

  // METHODS

  // TODO: da rimuovere una volta introdotti gli amici
  void newUserChat(Map<String, dynamic> users) {
    users.forEach((username, data) {
      if (!_chats.containsKey(username)) {
        _chats[username] = Chat(chatName: username, messages: [], toRead: 0)
          ..authUser.value = authUser;
      }
    });
    notifyListeners();
    isar.saveAll<Chat>(_chats.values.toList());
  }

  void addMessage(String message, String sender, String chatName) {
    Message newMessage = Message(
      content: message,
      sender: sender,
      time: DateTime.now(),
      id: const Uuid().v1(),
      chatName: chatName,
    );

    _chats[chatName]?.messages.add(newMessage);

    if (currentChat != chatName) _chats[chatName]?.toRead += 1;

    notifyListeners();
    isar.insertOrUpdate<Chat>(_chats[chatName]!);
  }

  void readChat(String chatName) {
    _chats[chatName]?.toRead = 0;
    notifyListeners();
    isar.insertOrUpdate<Chat>(_chats[chatName]!);
  }

  void updateSelectedSections(Chat chat, List<String> selectedSections) {
    chat.sections = ["All", ...selectedSections];
    notifyListeners();
    isar.insertOrUpdate<Chat>(chat);
  }

  void _loadChatsFromMemory() async {
    List<Chat> chatsList = await isar.getAll<Chat>();
    if (chatsList.isEmpty) {
      _chats = {
        "GLOBAL": Chat(
            chatName: "GLOBAL", messages: List.empty(growable: true), toRead: 0)
          ..authUser.value = authUser
      };
      isar.saveAll<Chat>(_chats.values.toList());

    } else {
      _chats = {for (var chat in chatsList) chat.chatName: chat};
    }

    notifyListeners();
  }
}
