import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:livechat/models/friend.dart';

import '../constants.dart';
import '../database/isar_service.dart';
import '../models/auth/auth_user.dart';
import '../services/http_requester.dart';

class FriendsProvider with ChangeNotifier {
  AuthUser? authUser;

  List<Friend> get friends => authUser?.friends ?? [];
  List<Friend> get onlineUsers => friends.where((friend) => friend.isOnline).toList();

  // Called everytime AuthProvider changes
  void update(AuthUser? authUser) {
    if (authUser == null) {
      this.authUser = null;
    } else {
      this.authUser = authUser;
    }
  }

  // FRIENDS

  void newFriend(Map<String, dynamic> data) {
    authUser!.friends.add(Friend.fromJson(data));
    IsarService.instance.insertOrUpdate<AuthUser>(authUser!);

    notifyListeners();
  }

  void deleteFriend(String id) {
    authUser!.friends.removeWhere((friend) => friend.id == id);
    IsarService.instance.insertOrUpdate<AuthUser>(authUser!);

    notifyListeners();
  }

  void updateOnlineFriends(Map<String, dynamic> jsonData) {
    authUser!.friends
        .where((friend) => friend.id == jsonData["id"])
        .forEach((friend) => friend.isOnline = true);

    notifyListeners();
  }

  void userDisconnected(String username) {
    authUser!.friends
        .firstWhere((friend) => friend.username == username)
        .isOnline = false;

    notifyListeners();
  }

  Friend getFriend(String username) => friends.firstWhere((friend) => friend.username == username);

  isFriend(String chatName) {
    return authUser!.friends.any((friend) => friend.username == chatName);
  }

  // REQUESTS
  late List<Friend> requests;
  late List<Friend> mineRequests;

  Future<void> loadRequests() async {
    requests = (await HttpRequester.get(
      URL_REQUESTS_LIST.format("false"),
      authUser!.token,
    ) as List)
        .map((user) => Friend.fromJson(user["sender"]))
        .toList();

    mineRequests = (await HttpRequester.get(
      URL_REQUESTS_LIST.format("true"),
      authUser!.token,
    ) as List)
        .map((user) => Friend.fromJson(user["receiver"]))
        .toList();
  }

  deleteRequest(String id) {
    requests.removeWhere((friend) => friend.id == id);
    mineRequests.removeWhere((friend) => friend.id == id);

    notifyListeners();
  }
}
