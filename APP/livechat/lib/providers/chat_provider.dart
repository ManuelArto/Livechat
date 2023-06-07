import 'package:flutter/material.dart';
import 'package:livechat/models/chat/chat.dart';
import 'package:livechat/services/isar_service.dart';
import 'package:uuid/uuid.dart';

import '../models/auth/auth_user.dart';
import '../models/chat/message.dart';

class ChatProvider with ChangeNotifier {
  AuthUser? authUser;

  Map<String, Chat> _chats = {};
  String currentChat = "";

  // Called everytime AuthProvider changes
  void update(AuthUser? authUser) {
    if (authUser == null) {
      _chats.clear();
      this.authUser = null;
    } else {
      this.authUser = authUser;
      _loadChatsFromMemory();
    }
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
          ..userId = authUser!.isarId;
      }
    });
    notifyListeners();
    IsarService.instance.saveAll<Chat>(_chats.values.toList());
  }

  void addMessage(String message, String sender, String chatName) {
    Message newMessage = Message(
      content: message,
      sender: sender,
      time: DateTime.now(),
      id: const Uuid().v1(),
    );

    _chats[chatName]?.messages.add(newMessage);

    if (currentChat != chatName) _chats[chatName]?.toRead += 1;

    notifyListeners();
    IsarService.instance.insertOrUpdate<Chat>(_chats[chatName]!);
  }

  void readChat(String chatName) {
    _chats[chatName]?.toRead = 0;
    notifyListeners();
    IsarService.instance.insertOrUpdate<Chat>(_chats[chatName]!);
  }

  void updateSelectedSections(Chat chat, List<String> selectedSections) {
    chat.sections = ["All", ...selectedSections];
    notifyListeners();
    IsarService.instance.insertOrUpdate<Chat>(chat);
  }

  void _loadChatsFromMemory() async {
    List<Chat> chatsList = await IsarService.instance.getAll<Chat>(authUser!.isarId);
    if (chatsList.isEmpty) {
      _chats = {
        "GLOBAL": Chat(
            chatName: "GLOBAL", messages: [], toRead: 0)
          ..userId = authUser!.isarId
      };
      
      IsarService.instance.saveAll<Chat>(_chats.values.toList());
    } else {
      _chats = {for (var chat in chatsList) chat.chatName: chat..messages = List.from(chat.messages)};
      // * Bisogna ricreare la list dei messaggi a causa di un errore di ISAR https://github.com/isar/isar/discussions/781
    }

    notifyListeners();
  }
}
