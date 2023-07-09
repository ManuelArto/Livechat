import 'dart:convert';

import 'package:isar/isar.dart';

import 'content/content.dart';

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
      // Adding a new message
      contentString = json.encode(content?.toJson(), toEncodable: (c) => c.toString());
    } else if (contentString != null) {
      // Loading a message from memory
      Map<String, dynamic> contentMap = json.decode(contentString!);
      content = Content.createContentInstanceFromJson<T>(contentMap);
    }
  }
}
