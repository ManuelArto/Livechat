// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

const PORT = 8000;
const SERVER_URL = kDebugMode ? "http://192.168.0.105:$PORT": "https://live-chat-fp.herokuapp.com";

// AUTH
const URL_AUTH_SIGN_UP = "$SERVER_URL/api/auth/register";
const URL_AUTH_SIGN_IN = "$SERVER_URL/api/auth/login";
const URL_AUTH_REFRESH_TOKEN = "$SERVER_URL/api/auth/refreshToken";

// USERS
const URL_USERS_LIST = "$SERVER_URL/api/users/list?page={}&per_page={}";
