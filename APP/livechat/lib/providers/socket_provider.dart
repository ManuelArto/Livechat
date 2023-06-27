import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:livechat/providers/friends_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'auth_provider.dart';
import 'chat_provider.dart';
import '../constants.dart';
import '../models/auth/auth_user.dart';

class SocketProvider with ChangeNotifier {
  Socket? _socketIO;
  late AuthUser authUser;
  late ChatProvider chatProvider;
  late FriendsProvider friendsProvider;

  // Called everytime AuthProvider changes
  void update(AuthProvider auth) {
    if (auth.isAuth) {
      authUser = auth.authUser!;

      if (_socketIO == null) init();
    } else {
      _socketIO?.dispose();
    }
  }

  void init() {
    _socketIO = io(SERVER_URL,
      OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth({"x-access-token": authUser.token})
          .enableForceNew()
          // .enableReconnection()
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

    _socketIO?.emit("send_message", data);
    chatProvider.addMessage(message, authUser.username, receiver);
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
    // CHAT
    _socketIO?.on('receive_message', _receiveMessage);
  }

  void _userConnected(jsonData) {
    (jsonData as List<dynamic>).removeWhere((friend) => friend == authUser.username);

    debugPrint("UPDATE ONLINE USERS");
    friendsProvider.updateOnlineFriends(jsonData);
  }

  void _userDisconnected(jsonData) {
    debugPrint("${jsonData['username']} DISCONNECTED");
    if (jsonData["username"] == authUser.username) return;
    
    friendsProvider.userDisconnected(jsonData["username"]);
  }

  void _newFriend(jsonData) {
    friendsProvider.newFriend(jsonData);
    chatProvider.newUserChat(jsonData);
  }

  void _deleteFriend(jsonData) {
    friendsProvider.deleteFriend(jsonData["id"]);
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

}
