import 'dart:convert';
import 'dart:io';

import 'content.dart';

class AudioContent implements Content<File> {
  File _content;
  String get audioString => base64Encode(_content.readAsBytesSync());

  AudioContent({required File content}) : _content = content;

  @override
  ContentType type = ContentType.audio;
  
  @override
  File get() => _content;

  @override
  Map<String, dynamic> toJson() => {"content": _content.uri, "type": type};

  factory AudioContent.fromJson(Map<String, dynamic> json) => AudioContent(
        content: File.fromUri(Uri.parse(json["content"])),
      );
}
