import 'package:flutter/material.dart';
import 'package:livechat/services/isar_service.dart';

import '../models/auth/auth_user.dart';
import '../models/friend.dart';

class FriendsProvider with ChangeNotifier {
  final IsarService isar;
  final AuthUser authUser;

  Map<String, Friend> _users = {};

  FriendsProvider(this.isar, this.authUser) {
    _loadFriendsFromMemory();
  }

  List<Friend> get onlineUsers =>
      _users.values.where((user) => user.isOnline).toList();

  Friend? getUser(String username) {
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
      (username, data) => _users[username] =
          Friend(username: username, imageUrl: data["imageUrl"], isOnline: true)
            ..authUser.value = authUser,
    );

    notifyListeners();
    isar.saveAll<Friend>(_users.values.toList());
  }

  void usersDisconnected(String username) {
    _users[username]?.isOnline = false;

    notifyListeners();
  }

  void _loadFriendsFromMemory() async {
    List<Friend> usersList = await isar.getAll<Friend>();
    if (usersList.isNotEmpty) {
      _users = {for (var user in usersList) user.username: user};
    }
  }
}
