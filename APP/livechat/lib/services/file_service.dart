import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/chat/messages/content/content.dart';

class FileService {
  static Future<Content> saveAndCreateFileMessage(jsonData) async {
    String type = jsonData["type"];
    String filename = "${jsonData["sender"]}_${jsonData["filename"]}";

    final directory = await getApplicationDocumentsDirectory();
    final file = await File(
      '${directory.path}/media/$type/$filename',
    ).create(recursive: true);
    await file.writeAsBytes(base64Decode(jsonData["message"]), flush: true);

    return Content.createContentInstance(type, file);
  }
}
