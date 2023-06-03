import 'package:flutter/material.dart';

import '../models/user.dart';

class FriendsProvider with ChangeNotifier {
final Map<String, User> _users = {};

  FriendsProvider() {
    // _getFromMemory();
  }

  List<User> get onlineUsers =>
      _users.values.where((user) => user.isOnline).toList();

  User? getUser(String username) {
    return _users[username];
  }

  String getImageUrl(String username) {
    return _users[username]!.imageUrl;
  }

  bool userIsOnline(String username) {
    return _users[username]!.isOnline;
  }

  // TODO: da modificare una volta introdotti gli amici
  void newUsersOnline(Map<String, dynamic> users) {
    users.forEach(
      (username, data) => _users[username] = User(username: username, imageUrl: data["imageUrl"], isOnline: true)
    );

    notifyListeners();
  }

  void usersDisconnected(String username) {
    _users[username]?.isOnline = false;

    notifyListeners();
  }

}
