import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:livechat/services/http_requester.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/auth/auth_request.dart';
import '../models/auth/auth_user.dart';

class AuthProvider with ChangeNotifier {
  AuthUser? authUser;
  late Function _closeSocket;

  // GETTERS AND SETTERS

  get isAuth => authUser != null;

  set closeSocket(Function closeSocket) => _closeSocket = closeSocket;

  Future<bool> tryAutoLogin() async {
    authUser = await AuthUser.load();
    if (authUser == null) return false;

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    authUser = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    _closeSocket();
    notifyListeners();
  }

  Future<void> authenticate(AuthRequest authRequest) async {
    Map<String, dynamic> data = await HttpRequester.post(
      authRequest.toMap(),
      authRequest.isLogin ? URL_AUTH_SIGN_IN : URL_AUTH_SIGN_UP,
    );

    _saveData(data);
  }

  // PRIVATE METHODS

  void _saveData(Map<String, dynamic> responseData) {
    authUser = AuthUser.fromMap(responseData);
    authUser?.save();

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
