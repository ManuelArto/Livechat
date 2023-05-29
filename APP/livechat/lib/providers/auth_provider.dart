import 'dart:async';
import 'dart:convert';

import 'package:livechat/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  DateTime? _expToken;
  DateTime? _expRefreshToken;
  String? _userId;
  String? _username;
  String? _imageUrl;
  late Function _disconncect;
  Timer? _timer;

  // GETTERS AND SETTERS

  String get username => _username!;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expToken != null && _expRefreshToken!.isAfter(DateTime.now())) {
      if (_expToken!.isBefore(DateTime.now())) _getNewToken();
    }
    return _token;
  }

  String? get userId => _userId;

  String? get imageUrl => _imageUrl;

  set token(String? newToken) => _token = newToken;

  set disconnect(Function callBack) => _disconncect = callBack;

  // METHODS

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) return false;

    final Map userData = json.decode(prefs.getString("userData")!);
    _expToken = DateTime.parse(userData["expInToken"]);
    _expRefreshToken = DateTime.parse(userData["expInRefreshToken"]);
    _userId = userData["userId"];
    _token = userData["token"];
    _refreshToken = userData["refreshToken"];
    _username = userData["username"];
    _imageUrl = userData["imageUrl"];

    if (!isAuth) return false;

    _autoRefresh();

    notifyListeners();
    return true;
  }

  Future<void> signup(
      String email, String username, String password, String image) async {
    return _authenticate(
      {
        "username": username,
        "email": email,
        "password": password,
        "imageFile": image
      },
      URL_AUTH_SIGN_UP,
    );
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(
      {"email": email, "password": password},
      URL_AUTH_SIGN_IN,
    );
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _refreshToken = null;
    _username = null;
    _expRefreshToken = null;
    _expToken = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    _timer?.cancel();
    _disconncect();
    notifyListeners();
  }

  // PRIVATE METHODS

  void _saveData(Map<String, dynamic> responseData) {
    _token = responseData["token"];
    _refreshToken = responseData["refreshToken"];
    _username = responseData["username"];
    _userId = responseData["id"];
    _imageUrl = responseData["imageUrl"];
    _expToken =
        DateTime.now().add(Duration(seconds: responseData["expInToken"]));
    _expRefreshToken = DateTime.now()
        .add(Duration(seconds: responseData["expInRefreshToken"]));

    _autoRefresh();
    _storeValues();

    notifyListeners();
  }

  Future<void> _storeValues() async {    
    final userData = json.encode({
      "token": _token,
      "refreshToken": _refreshToken,
      "userId": _userId,
      "username": _username,
      "expInRefreshToken": _expRefreshToken?.toIso8601String(),
      "expInToken": _expToken?.toIso8601String(),
      "imageUrl": _imageUrl,
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userData", userData);
  }

  Future<void> _authenticate(Map<String, dynamic> body, String url) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {"Content-Type": "application/json"}
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData.containsKey("error")) {
      throw HttpException(responseData["error"], response.statusCode);
    }

    _saveData(responseData);
  }

  void _autoRefresh() {
    final timeToRefresh = _expToken!.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: timeToRefresh), _getNewToken);
  }

  Future<void> _getNewToken() async {
    debugPrint("GETTING NEW TOKEN");
    while (true) {
      try {
        final response = await http.get(Uri.parse(URL_AUTH_REFRESH_TOKEN),
            headers: {"x-access-token": _refreshToken!});
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData.containsKey("error")) {
          logout();
          break;
        }
        _saveData(responseData);
        break;
      } catch (error) {
        debugPrint("Error: $error");
      }
    }
  }

  // void _autoLogout() {
  //   final timeToLogout = _expRefreshToken.inSeconds;
  //   Timer(Duration(seconds: timeToLogout), logout);
  // }
}
