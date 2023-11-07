// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

const PORT = 8080;
const SERVER_URL = kDebugMode ? "http://192.168.0.105:$PORT": "https://livechat-api.onrender.com";
// const SERVER_URL = "https://livechat-api.onrender.com";

// AUTH
const URL_AUTH_SIGN_UP = "$SERVER_URL/api/auth/register";
const URL_AUTH_SIGN_IN = "$SERVER_URL/api/auth/login";
const URL_AUTH_REFRESH_TOKEN = "$SERVER_URL/api/auth/refreshToken";

// LOCATION
const URL_UPDATE_LOCATION = "$SERVER_URL/api/location/update?lat={}&long={}";

// STEPS
const URL_UPDATE_STEPS = "$SERVER_URL/api/steps/update?steps={}";
const URL_WEEKLY_STEPS = "$SERVER_URL/api/steps/weeklyCharts";

// RANKING
const URL_DAILY_RANKING = "$SERVER_URL/api/ranking/daily";
const URL_WEEKLY_RANKING = "$SERVER_URL/api/ranking/weekly";

// FRIENDS
const URL_FRIENDS_LIST = "$SERVER_URL/api/friends/list";
const URL_REMOVE_FRIEND = "$SERVER_URL/api/friends/{}";
const URL_FRIENDS_SUGGESTED = "$SERVER_URL/api/friends/suggested?page={}&per_page={}";
const URL_FRIENDS_SEARCH = "$SERVER_URL/api/friends/searchNewFriends?query={}";
const URL_FRIENDS_CONTACTS = "$SERVER_URL/api/friends/contacts?numbers={}";

// REQUESTS
const URL_REQUESTS_LIST = "$SERVER_URL/api/requests/list?sended={}";
const URL_ADD_REQUEST = "$SERVER_URL/api/requests/{}/send";
const URL_ACCEPT_REQUEST = "$SERVER_URL/api/requests/{}/accept";
const URL_REMOVE_REQUEST = "$SERVER_URL/api/requests/{}";

// GROUPS
const URL_CREATE_GROUP = "$SERVER_URL/api/groups/create";
const URL_GROUPS_LIST = "$SERVER_URL/api/groups/list";
const URL_GROUP_DELETE = "$SERVER_URL/api/groups/{}";
const URL_GROUP_ADD = "$SERVER_URL/api/groups/{}/add";
const URL_GROUP_REMOVE = "$SERVER_URL/api/groups/{}/remove";
const URL_LEAVE_GROUP = "$SERVER_URL/api/groups/{}/leave";

// FILE
const MAX_FILE_SIZE = 950000;

// SHARE LINK
const DOWNLOAD_LINK = "https://drive.google.com/file/d/1p6CDsgj8xyJc192Gn4C1V3d5hR6L9yZV/view?usp=drive_link";

// WEB3
const WALLET_CONNECT_ID = 'b656d8592362048cbf80efbd52d0e529';
const CHAIN_ID = kDebugMode ? 1377 : 1; // Test is Ganache Chain Id
const RPC_URL = kDebugMode ? 'http://192.168.0.105:7545' : '';
const WS_URL = kDebugMode ? 'ws://192.168.0.105:7545' : '';
const NEWS_SHARING_CONTRACT_ADDRESS = kDebugMode ? '0x33757B5FC136c81fC0EBf31Ae424b5E2aB0dD000' : '';
const NEWS_EVALUATION_CONTRACT_ADDRESS = kDebugMode ? '0x4b7a050711c9d99aB01fcf8d68777bfA9A3590D3' : '';
const PRIVATE_KEY = '0x17007591ef80f494cc650e7e99bc50d5666bf38f0b35262ba80849ec4282fd13';

// APP INFO
const APP_INFO_NAME = 'Livechat';
const APP_INFO_DESCRIPTION = 'Livechat is a chat app that allows you to send messages and shares your location and steps with your friends.';