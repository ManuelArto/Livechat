import 'package:flutter/material.dart';
import 'package:livechat/services/isar_service.dart';

import '../models/user.dart';

class FriendsProvider with ChangeNotifier {
  final IsarService isar;

  Map<String, User> _users = {};

  FriendsProvider(this.isar) {
    _loadFriendsFromMemory();
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
    isar.saveAll<User>(_users.values.toList());
  }

  void usersDisconnected(String username) {
    _users[username]?.isOnline = false;

    notifyListeners();
  }
  
  void _loadFriendsFromMemory() async {
    List<User> usersList = await isar.getAll<User>();
    if (usersList.isNotEmpty) {
      _users = { for (var user in usersList) user.username : user };
    }
  }

}
