import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:livechat/helpers/db_helper.dart';
import 'package:livechat/models/user.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/models/message.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';

class SocketProvider with ChangeNotifier {
  final Map<String, User> _users = {};
  final Map<String, Map<String, dynamic>> _messages = {
    "GLOBAL": {"toRead": 0, "list": []}
  };
  String currentChat = "";
  late Socket _socketIO;
  late Auth auth;

  void init() async {
    if (!kIsWeb) await getFromMemory(); 

    _socketIO = io(SERVER_URL, <String, dynamic>{
      'transports': ['websocket', "polling"],
      'query': "token=${auth.token}"
    });

    _initListener();
  }

  void update(Auth auth) {
    this.auth = auth;
    auth.disconnect = _destroy;
  }

  // PRIVATE METHODS

  void _initListener() {
    _socketIO.on("connect", (_) => debugPrint('Connected'));
    _socketIO.on("disconnect", (_) => debugPrint('Disconnected'));
    _socketIO.on('receive_message', _receiveMessage);
    _socketIO.on("user_connected", _userConnected);
    _socketIO.on("user_disconnected", _userDisconnected);
  }

  void _receiveMessage(jsonData) {
    debugPrint("RECEIVED MESSAGE $jsonData");
    addMessage(
      jsonData["message"],
      jsonData["sender"],
      auth.username == jsonData["receiver"]
          ? jsonData["sender"]
          : jsonData["receiver"],
    );
  }

  void _userConnected(jsonData) {
    debugPrint("UPDATE USERS CONNECTED");

    jsonData.forEach((username, data) {
      if (username != auth.username) {
        if (!_users.containsKey(username)) {
          _users[username] = User(
            username: username,
            imageUrl: data["imageUrl"],
            isOnline: true,
          );
        } else {
          _users[username]!.isOnline = true;
        }

        if (!_messages.containsKey(username)) {
          if (!kIsWeb) {
            storeInMemory("USERS", _users[username]!.toJson());
          }
          _messages[username] = {"toRead": 0, "list": []};
        }
      }
    });

    notifyListeners();
  }

  void _userDisconnected(jsonData) {
    debugPrint("${jsonData['username']} DISCONNECTED");
    _users[jsonData["username"]]?.isOnline = false;

    notifyListeners();
  }

  void sendMessage(String message, String receiver) {
    debugPrint("Sending $message to $receiver");
    final data = json.encode({
      "token": auth.token,
      "message": message,
      "receiver": receiver,
    });

    _socketIO.emit("send_message", data);
    
    addMessage(message, auth.username, receiver);
  }

  void _destroy() {
    debugPrint("Destroying");
    _socketIO.destroy();
    SocketProvider();
  }

  // persistentData

  Future<void> getFromMemory() async {
    debugPrint("FETCHING FROM MEMORY");
    final usersList = await DBHelper.getData(auth.userId!, "USERS");
    for (var data in usersList) {
      _users[data["username"]] = User.fromJson(data);
    }

    final messagesList = await DBHelper.getData(auth.userId!, "MESSAGES");
    for (var data in messagesList) {
      if (!_messages.containsKey(data["chatName"])) {
        _messages[data["chatName"]] = {"toRead": 0, "list": []};
      }
      _messages[data["chatName"]]!["list"].add(Message.fromJson(data));
    }
  }

  Future<void> storeInMemory(String table, Map<String, dynamic> data) async {
    debugPrint("STORING $data in $table");
    DBHelper.insert(auth.userId!, table, data);
  }

  // Messages

  List<dynamic> messages(String chatName) => _messages[chatName]?["list"];

  void readChat(String chatName) {
    _messages[chatName]?["toRead"] = 0;
    notifyListeners();
  }

  List<Map<String, dynamic>> get chats {
    final List<Map<String, dynamic>> chats = [];
    _messages.forEach((chatName, data) {
      if (data["list"].length == 0) {
        chats.add({
          "chatName": chatName,
          "lastMessage": "No message",
          "time": "",
          "toRead": data["toRead"].toString(),
        });
      } else {
        chats.add({
          "chatName": chatName,
          "lastMessage": getUser(chatName) == null
              ? "${data['list'].last.sender}: ${data["list"].last.content}"
              : data["list"].last.content,
          "time": DateFormat("jm").format(data["list"].last.time),
          "toRead": data["toRead"].toString(),
        });
      }
    });
    return chats;
  }

  void addMessage(String message, String sender, String chatName) {
    Message newMessage = Message(
      content: message,
      sender: sender,
      time: DateTime.now(),
      id: const Uuid().v1(),
      chatName: chatName,
    );
    _messages[chatName]?["list"].add(newMessage);
    if (currentChat != chatName) _messages[chatName]?["toRead"] += 1;
    notifyListeners();
    if (!kIsWeb) storeInMemory("MESSAGES", newMessage.toJson());
  }

  // Users

  List<User> get onlineUsers =>
      _users.values.where((user) => user.isOnline).toList();

  User? getUser(String username) {
    return _users[username];
  }

  String getImageUrl(String username) {
    return auth.username == username ?
      auth.imageUrl! : _users[username]!.imageUrl;
  }

  bool userIsOnline(String username) {
    return _users[username]!.isOnline;
  }
}
