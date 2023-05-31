import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class HttpRequester {
  static Future<Map<String, dynamic>> post(Map<String, dynamic> body, String url) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {"Content-Type": "application/json"},
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseData.containsKey("error")) {
      throw HttpException(responseData["error"], response.statusCode);
    }

    return responseData;
  }
}