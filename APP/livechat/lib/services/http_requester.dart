import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class HttpRequester {
  static Future<Map<String, dynamic>> post(Map<String, dynamic> body, String url, {String? token}) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: token != null
          ? {"x-access-token": token, "Content-Type": "application/json"}
          : {"Content-Type": "application/json"},
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseData.containsKey("error")) {
      throw HttpException(responseData["error"], response.statusCode);
    }

    return responseData;
  }

  static Future<dynamic> get(String url, String? token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: token != null ? {"x-access-token": token} : null,
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData.containsKey("error")) {
      throw HttpException(responseData["error"], response.statusCode);
    }

    return responseData["data"];
  }

  static Future<dynamic> delete(String url, String? token) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: token != null ? {"x-access-token": token} : null,
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData.containsKey("error")) {
      throw HttpException(responseData["error"], response.statusCode);
    }
  }
}
