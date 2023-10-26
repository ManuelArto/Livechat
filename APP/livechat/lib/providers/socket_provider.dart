import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:livechat/models/chat/messages/content/text_content.dart';
import 'package:livechat/providers/users_provider.dart';
import 'package:livechat/services/file_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../models/chat/messages/content/content.dart';
import 'auth_provider.dart';
import 'chat_provider.dart';
import '../constants.dart';
import '../models/auth/auth_user.dart';

class SocketProvider with ChangeNotifier {
  Socket? _socketIO;
  late AuthUser authUser;
  late ChatProvider chatProvider;
  late UsersProvider usersProvider;

  // Called everytime AuthProvider changes
  void update(AuthProvider auth) {
    if (auth.isAuth) {
      authUser = auth.authUser!;

      if (_socketIO == null) init();
    } else {
      _socketIO?.dispose();
      _socketIO = null;
    }
  }

  void init() {
    _socketIO = io(
        SERVER_URL,
        OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .setAuth({"x-access-token": authUser.token})
            .enableForceNew()
            // .enableReconnection()
            .build());

    _initListeners();
  }

  void sendMessage(dynamic raw, String type, String receiver, {String? filename}) {
    debugPrint("Sending $type to $receiver");
    String message = type == "text"
        ? raw
        : type == "file"
            ? base64Encode((raw as PlatformFile).bytes!)
            : base64Encode((raw as File).readAsBytesSync());

    final data = {
      "sender": authUser.username,
      "message": message,
      "receiver": receiver,
      "type": type,
      if (filename != null) "filename": filename
    };
    _socketIO?.emit("send_message", json.encode(data));

    _storeNewMessage(data);
  }

  // PRIVATE METHODS

  void _initListeners() {
    _socketIO?.onConnectError((err) => debugPrint(err.toString()));
    _socketIO?.onError((err) => debugPrint(err.toString()));
    _socketIO?.on("connect", (_) => debugPrint('CONNECTED'));
    _socketIO?.on("disconnect", (_) => debugPrint('DISCONNECTED'));
    // FRIENDS
    _socketIO?.on("user_connected", _userConnected);
    _socketIO?.on("user_disconnected", _userDisconnected);
    _socketIO?.on("new_friend", _newFriend);
    _socketIO?.on("friend_deleted", _deleteFriend);
    _socketIO?.on("friend_location_update", _updatefriendLocation);
    _socketIO?.on("friend_steps_update", _updatefriendSteps);
    // CHAT
    _socketIO?.on('receive_message', _receiveMessage);
  }

  void _userConnected(jsonData) {
    (jsonData as List<dynamic>)
        .removeWhere((friend) => friend == authUser.username);

    debugPrint("UPDATE ONLINE USERS");
    usersProvider.updateOnlineFriends(jsonData);
  }

  void _userDisconnected(jsonData) {
    debugPrint("${jsonData['username']} DISCONNECTED");
    if (jsonData["username"] == authUser.username) return;

    usersProvider.userDisconnected(jsonData["username"]);
  }

  void _newFriend(jsonData) {
    usersProvider.newFriend(jsonData);
    chatProvider.newFriendChat(jsonData);
  }

  void _updatefriendLocation(jsonData) {
    usersProvider.updateFriendLocation(jsonData);
  }

  void _updatefriendSteps(jsonData) {
    usersProvider.updateFriendSteps(jsonData);
  }

  void _deleteFriend(jsonData) {
    usersProvider.deleteFriend(jsonData["username"]);
  }

  void _receiveMessage(jsonData) async {
    if (jsonData["sender"] == authUser.username) return; // In teoria non serve, ma in caso di gruppi sì

    _storeNewMessage(jsonData);
  }

  void _storeNewMessage(jsonData) async {
    Content content = jsonData["type"] == "text"
        ? TextContent(content: jsonData["message"])
        : await FileService.saveAndCreateFileMessage(jsonData);

    chatProvider.addMessage(
      content,
      jsonData["sender"],
      authUser.username == jsonData["receiver"]
          ? jsonData["sender"]
          : jsonData["receiver"],
    );
  }
}
