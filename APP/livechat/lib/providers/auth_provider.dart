import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livechat/services/http_requester.dart';

import '../constants.dart';
import '../models/auth/auth_request.dart';
import '../models/auth/auth_user.dart';
import '../models/chat/group_chat.dart';
import '../services/isar_service.dart';
import '../models/friend.dart';

class AuthProvider with ChangeNotifier {
  AuthUser? authUser;

  bool get isAuth => authUser != null;

  Future<bool> tryAutoLogin() async {
    authUser = await IsarService.instance.getLoggedUser();
    if (authUser == null) return false;

    authUser!.friends = (await HttpRequester.get(
      URL_FRIENDS_LIST,
      authUser!.token,
    ) as List)
        .map((user) => Friend.fromJson(user))
        .toList();
    
    authUser!.groupChats = (await HttpRequester.get(
      URL_GROUPS_LIST,
      authUser!.token,
    ) as List)
        .map((group) => GroupChat.fromJson(group, authUser!.isarId))
        .toList();

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await IsarService.instance.delete<AuthUser>(authUser!.isarId);
    authUser = null;

    notifyListeners();
  }

  Future<void> authenticate(AuthRequest authRequest) async {
    Map<String, dynamic> data = await HttpRequester.post(
      authRequest.toMap(),
      authRequest.isLogin ? URL_AUTH_SIGN_IN : URL_AUTH_SIGN_UP,
    );

    authUser = AuthUser.fromMap(data);
    IsarService.instance.insertOrUpdate<AuthUser>(authUser!);

    notifyListeners();
  }

}
