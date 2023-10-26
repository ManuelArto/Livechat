import 'package:flutter/material.dart';
import 'package:livechat/constants.dart';
import 'package:livechat/models/chat/chat.dart';
import 'package:livechat/services/http_requester.dart';
import 'package:livechat/services/isar_service.dart';
import 'package:livechat/services/notification_service.dart';
import 'package:uuid/uuid.dart';

import '../models/auth/auth_user.dart';
import '../models/chat/group_chat.dart';
import '../models/chat/messages/content/content.dart';
import '../models/chat/messages/content/image_content.dart';
import '../models/chat/messages/message.dart';
import '../models/friend.dart';

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

  List<Message> messages(String chatName) => _chats[chatName]?.messages ?? [];

  List<Chat> chatsBySection(String section) =>
      _chats.values.where((chat) => chat.sections.contains(section)).toList();

  bool canChat(String chatName) => _chats[chatName]?.canChat ?? false;

  int get totalToRead => _chats.values.fold(0, (prev, chat) => prev + chat.toRead);

  // METHODS

  void newFriendChat(Map<String, dynamic> data) {
    _addFriendChatIfNotExists(data["username"]);

    notifyListeners();
    IsarService.instance.saveAll<Chat>(_chats.values.toList());
  }

  void addMessage(Content content, String sender, String chatName) {
    Message newMessage = Message(
      sender: sender,
      time: DateTime.now(),
      id: const Uuid().v1(),
      content: content,
    );
    Chat chats = _chats[chatName]!
      ..messages.add(newMessage);

    if (currentChat != chatName) chats.toRead += 1;

    if (sender != authUser!.username && currentChat != chatName) {
      NotificationService.instance.showNotification(
        id: newMessage.id!.hashCode,
        title: chatName,
        body: "${chats is GroupChat ? '$sender ' : ''}${getContentMessage(content)}",
        groupKey: chatName,
        imagePath: content.type == ContentType.image
            ? (content as ImageContent).get().path
            : null,
      );
    }

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
    List<Chat> chatsList =
        await IsarService.instance.getAll<Chat>(authUser!.isarId);

    // * Bisogna ricreare la list dei messaggi a causa di un errore di ISAR https://github.com/isar/isar/discussions/781
    _chats = {
      for (var chat in chatsList)
        chat.chatName: chat
          ..messages = List.from(chat.messages)
          ..canChat = false
    };

    _updateFriendsChat();
    await _loadGroupsChat();

    IsarService.instance.saveAll<Chat>(_chats.values.toList());
    notifyListeners();
  }

  void _updateFriendsChat() {
    for (var friend in authUser!.friends) {
      if (_chats.containsKey(friend.username)) {
        _chats[friend.username]!.canChat = true;
      } else {
        _addFriendChatIfNotExists(friend.username);
      }
    }
  }

  void _addFriendChatIfNotExists(String username) {
    if (!_chats.containsKey(username)) {
      _chats[username] = Chat(
        chatName: username,
        userId: authUser!.isarId
      );
    }
  }

  Future<void> _loadGroupsChat() async {
    for (var groupChat in authUser!.groupChats) {
      if (_chats.containsKey(groupChat.chatName)) {
        _chats[groupChat.chatName]!.canChat = true;
      } else {
        _chats[groupChat.chatName] = groupChat;
      }
    }
  }

  String getContentMessage(Content content) {
    switch (content.type) {
      case ContentType.text:
        return content.get();
      case ContentType.audio:
        return "New audio received";
      case ContentType.file:
        return "New file received";
      case ContentType.image:
        return "New media received";
    }
  }
}
