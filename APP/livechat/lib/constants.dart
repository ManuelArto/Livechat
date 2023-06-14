// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

const PORT = 8000;
const SERVER_URL = kDebugMode ? "http://192.168.1.82:$PORT": "https://live-chat-fp.herokuapp.com";

const URL_AUTH_SIGN_UP = "$SERVER_URL/api/auth/register";
const URL_AUTH_SIGN_IN = "$SERVER_URL/api/auth/login";
const URL_AUTH_REFRESH_TOKEN = "$SERVER_URL/api/auth/refreshToken";
