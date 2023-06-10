import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livechat/services/http_requester.dart';

import '../constants.dart';
import '../models/auth/auth_request.dart';
import '../models/auth/auth_user.dart';
import '../database/isar_service.dart';

class AuthProvider with ChangeNotifier {
  AuthUser? authUser;

  bool get isAuth => authUser != null;

  Future<bool> tryAutoLogin() async {
    authUser = await IsarService.instance.getLoggedUser();
    if (authUser == null) return false;


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

  // TODO: valutare jwt refresh token

  // void _autoRefresh() {
  //   final timeToRefresh = _expToken!.difference(DateTime.now()).inSeconds;
  //   _timer = Timer(Duration(seconds: timeToRefresh), _getNewToken);
  // }

  // Future<void> _getNewToken() async {
  //   debugPrint("GETTING NEW TOKEN");
  //   while (true) {
  //     try {
  //       final response = await http.get(Uri.parse(URL_AUTH_REFRESH_TOKEN),
  //           headers: {"x-access-token": _refreshToken!});
  //       final responseData = json.decode(response.body) as Map<String, dynamic>;
  //       if (responseData.containsKey("error")) {
  //         logout();
  //         break;
  //       }
  //       _saveData(responseData);
  //       break;
  //     } catch (error) {
  //       debugPrint("Error: $error");
  //     }
  //   }
  // }

  // void _autoLogout() {
  //   final timeToLogout = _expRefreshToken.inSeconds;
  //   Timer(Duration(seconds: timeToLogout), logout);
  // }
}
