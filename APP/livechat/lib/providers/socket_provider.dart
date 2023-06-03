import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:livechat/providers/friends_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'auth_provider.dart';
import 'chat_provider.dart';
import '../constants.dart';
import '../models/auth/auth_user.dart';

class SocketProvider with ChangeNotifier {
  late Socket _socketIO;
  late AuthUser authUser;
  late ChatProvider chatProvider;
  late FriendsProvider friendsProvider;

  // Called everytime AuthProvider changes
  void update(AuthProvider auth) {
    if (auth.isAuth) authUser = auth.authUser!;
    auth.closeSocket = _destroy;
  }

  void init() {
    _socketIO = io(SERVER_URL,
      OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth({"x-access-token": authUser.token})
          .build()
    );

    _initListeners();
  }

  
  void sendMessage(String message, String receiver) {
    debugPrint("Sending $message to $receiver");
    final data = json.encode({
      "message": message,
      "receiver": receiver,
    });

    _socketIO.emit("send_message", data);
    chatProvider.addMessage(message, authUser.username, receiver);
  }

  // PRIVATE METHODS

  void _initListeners() {
    _socketIO.on("connect", (_) => debugPrint('CONNECTED'));
    _socketIO.on("disconnect", (_) => debugPrint('DISCONNECTED'));
    _socketIO.on('receive_message', _receiveMessage);
    _socketIO.on("user_connected", _userConnected);
    _socketIO.on("user_disconnected", _userDisconnected);
  }

  void _receiveMessage(jsonData) {
    debugPrint("RECEIVED MESSAGE $jsonData");
    
    if (jsonData["sender"] == authUser.username) return;

    chatProvider.addMessage(
      jsonData["message"],
      jsonData["sender"],
      authUser.username == jsonData["receiver"]
          ? jsonData["sender"]
          : jsonData["receiver"],
    );
  }

  void _userConnected(jsonData) {
    (jsonData as Map<String, dynamic>).removeWhere((key, value) => key == authUser.username);

    debugPrint("UPDATE ONLINE USERS");
    friendsProvider.newUsersOnline(jsonData);
    chatProvider.newUserChat(jsonData);
  }

  void _userDisconnected(jsonData) {
    debugPrint("${jsonData['username']} DISCONNECTED");
    friendsProvider.usersDisconnected(jsonData["username"]);
  }

  void _destroy() {
    debugPrint("Destroying");
    _socketIO.destroy();
  }

}
