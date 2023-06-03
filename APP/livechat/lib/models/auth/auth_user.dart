import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../user.dart';

class AuthUser extends User {
  final String _token;
  final String _id;

  AuthUser(this._token, this._id, String username, String imageUrl)
      : super(username: username, imageUrl: imageUrl);

  AuthUser.fromMap(Map<String, dynamic> map)
      : _token = map["token"],
        _id = map["id"],
        super(username: map["username"], imageUrl: map["imageUrl"]);

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

  @override
  Map<String, dynamic> toJson() => {
        "token": _token,
        "id": _id,
        "username": username,
        "imageUrl": imageUrl,
      };

  // GETTERS
  get token => _token;
  get id => _id;
}
