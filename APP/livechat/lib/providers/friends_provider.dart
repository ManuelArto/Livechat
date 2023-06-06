import 'package:flutter/material.dart';

import '../models/auth/auth_user.dart';
import '../models/friend.dart';

class FriendsProvider with ChangeNotifier {
  final Map<String, Friend> _users = {};

  List<Friend> get onlineUsers => _users.values.where((user) => user.isOnline).toList();

  // Called everytime AuthProvider changes
  void update(AuthUser? authUser) {
    if (authUser == null) {
      _users.clear();
    } else {
      _getUserFriends(authUser.token);
    }
  }

  // SINGLE USER

  Friend? getUser(String username) {
    return _users[username];
  }

  void usersDisconnected(String username) {
    _users[username]?.isOnline = false;

    notifyListeners();
  }

  // FRIENDS

  void _getUserFriends(String token) async {
    //TODO: HTTP get user friends call

    notifyListeners();
  }

  // TODO: da modificare una volta introdotti gli amici
  void newUsersOnline(Map<String, dynamic> users) {
    users.forEach(
      (username, data) => _users[username] = Friend(username: username, imageUrl: data["imageUrl"], isOnline: true)
    );

    notifyListeners();
  }

}
