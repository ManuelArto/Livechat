import 'package:flutter/material.dart';
import 'package:livechat/models/chat/chat.dart';
import 'package:uuid/uuid.dart';

import '../models/chat/message.dart';

class ChatProvider with ChangeNotifier {
  final Map<String, Chat> chats = {
    "GLOBAL": Chat(chatName: "GLOBAL", messages: [], toRead: 0),
  };
  String currentChat = "";

  ChatProvider() {
    _getFromMemory();
  }

  // GETTERS

  List<Message> messages(String chatName) =>
      chats.containsKey(chatName) ? chats[chatName]!.messages : [];

  List<Chat> chatsBySection(String section) => chats.values
      .where((chat) => chat.sections.contains(section))
      .toList();

  void readChat(String chatName) {
    chats[chatName]?.toRead = 0;
    notifyListeners();
  }

  // METHODS

  void addMessage(String message, String sender, String chatName) {
    Message newMessage = Message(
      content: message,
      sender: sender,
      time: DateTime.now(),
      id: const Uuid().v1(),
      chatName: chatName,
    );

    chats[chatName]?.messages.add(newMessage);

    if (currentChat != chatName) chats[chatName]?.toRead += 1;

    notifyListeners();
    // _storeInMemory("MESSAGES", newMessage.toJson());
  }

  void addChatToSection(String section, String chatName) {
    chats[chatName]?.sections.add(section);
    notifyListeners();  
  }

  void updateSelectedSections(Chat chat, List<String> selectedSections) {
    chat.sections = ["All", ...selectedSections];
    notifyListeners();
  }

  // TODO: da rimuovere una volta introdotti gli amici
  void newUserChat(Map<String, dynamic> users) {
    users.forEach((username, data) {
      if (!chats.containsKey(username)) {
        chats[username] = Chat(chatName: username, messages: [], toRead: 0);
      }
    });
  }

  // PERSISTENT DATA

  Future<void> _getFromMemory() async {
    debugPrint("FETCHING FROM MEMORY");
    //   final usersList = await DBHelper.getData(authUser.id!, "USERS");
    //   for (var data in usersList) {
    //     _users[data["username"]] = User.fromJson(data);
    //   }

    //   final messagesList = await DBHelper.getData(authUser.id!, "MESSAGES");
    //   for (var data in messagesList) {
    //     if (!_messages.containsKey(data["chatName"])) {
    //       _messages[data["chatName"]] = {"toRead": 0, "list": []};
    //     }
    //     _messages[data["chatName"]]!["list"].add(Message.fromJson(data));
    //   }
  }

  Future<void> _storeInMemory(String table, Map<String, dynamic> data) async {
    debugPrint("STORING $data in $table");
    // DBHelper.insert(authUser.id!, table, data);
  }

}
