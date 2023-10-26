import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:livechat/models/chat/group_chat.dart';
import 'package:livechat/models/friend.dart';
import 'package:livechat/models/user.dart';

import '../constants.dart';
import '../models/auth/auth_user.dart';
import '../services/http_requester.dart';

class UsersProvider with ChangeNotifier {
  AuthUser? authUser;
  final Map<String, User> _users = {};
  List<String> _onlineUsers = [];

  List<Friend> get friends => _users.values.whereType<Friend>().toList();
  List<User> get onlineUsers => friends.where((friend) => friend.isOnline).toList();
  T getUser<T extends User>(String username) => _users[username]! as T;

  // Called everytime AuthProvider changes
  void update(AuthUser? authUser) {
    if (authUser == null) {
      this.authUser = null;
      _users.clear();
    } else {
      this.authUser = authUser;
      _loadUsers();
    }
  }

  void newFriend(Map<String, dynamic> data) {
    Friend friend = Friend.fromJson(data);
    _users[friend.username] = friend
      ..isOnline = _onlineUsers.contains(friend.username);

    notifyListeners();
  }

  void deleteFriend(String username) {
    _users.remove(username);
    notifyListeners();
  }

  void updateOnlineFriends(List<dynamic> usernameList) {
    for (Friend friend in friends) {
      friend.isOnline = usernameList.contains(friend.username);
    }

    _onlineUsers = List.from(usernameList);
    notifyListeners();
  }

  void updateFriendLocation(Map<String, dynamic> friendLocation) {
    friends.firstWhere((friend) => friend.username == friendLocation["username"])
      ..lat = friendLocation["lat"]
      ..long = friendLocation["long"];

    notifyListeners();
  }

  void updateFriendSteps(Map<String, dynamic> friendLocation) {
    friends
        .firstWhere((friend) => friend.username == friendLocation["username"])
        .steps = friendLocation["steps"];

    notifyListeners();
  }

  void userDisconnected(String username) {
    if (friends.any((friend) => friend.username == username)) {
      friends.firstWhere((friend) => friend.username == username)
        .isOnline = false;
    }

    _onlineUsers.remove(username);
    notifyListeners();
  }

  void _loadUsers() {
    for (GroupChat group in authUser!.groupChats) {
      for (User user in group.partecipants) {
        
      }
    }

    for (Friend friend in authUser!.friends) {
      _users[friend.username] = friend;
    }
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
