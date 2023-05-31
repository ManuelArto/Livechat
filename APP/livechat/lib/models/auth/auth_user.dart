import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  final String _token;
  final String _id;
  final String _username;
  final String _imageUrl;

  AuthUser(this._token, this._id, this._username, this._imageUrl);

  AuthUser.fromMap(Map<String, dynamic> map)
      : _token = map["token"],
        _id = map["id"],
        _username = map["username"],
        _imageUrl = map["imageUrl"];

  static Future<AuthUser?> load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) return null;

    final Map<String, dynamic> userData =
        json.decode(prefs.getString("userData")!);

    return AuthUser.fromMap(userData);
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userData", json.encode(toJson()));
  }

  Map<String, dynamic> toJson() => {
        "token": _token,
        "id": _id,
        "username": _username,
        "imageUrl": _imageUrl,
      };

  // GETTERS
  get token => _token;
  get id => _id;
  get username => _username;
  get imageUrl => _imageUrl;
}
