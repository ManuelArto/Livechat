import 'dart:convert';

import 'package:isar/isar.dart';

import 'content/audio_content.dart';
import 'content/content.dart';
import 'content/file_content.dart';
import 'content/text_content.dart';

part 'message.g.dart';

@embedded
class Message<T extends Content> {
  final String? id;
  final String? sender;
  final DateTime? time;

  @ignore
  T? content;
  String? contentString;

  Message({this.id, this.sender, this.time, this.content, this.contentString}) {
    if (content != null) {
      contentString = json.encode(content?.toJson(), toEncodable: (c) => c.toString());
    } else if (contentString != null) {
      Map<String, dynamic> contentMap = json.decode(contentString!);
      content = _createContentInstance(contentMap);
    }
  }

  ContentType findContentType(String type) => ContentType.values.firstWhere((e) => e.toString() == type);

  T _createContentInstance(Map<String, dynamic> json) {
    ContentType contentType = findContentType(json['type']);
    switch (contentType) {
      case ContentType.text:
        return TextContent.fromJson(json) as T;
      case ContentType.audio:
        return AudioContent.fromJson(json) as T;
      case ContentType.file:
        return FileContent.fromJson(json) as T;
    }
  }
}
