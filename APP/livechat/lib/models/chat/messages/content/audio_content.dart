import 'dart:convert';
import 'dart:io';

import 'content.dart';

class AudioContent implements Content<File> {
  File content;
  String get audioString => base64Encode(content.readAsBytesSync());

  AudioContent({required this.content});

  @override
  ContentType type = ContentType.audio;
  
  @override
  File get() => content;

  @override
  Map<String, dynamic> toJson() => {"content": content.uri, "type": type};

  factory AudioContent.fromJson(Map<String, dynamic> json) => AudioContent(
        content: File.fromUri(Uri.parse(json["content"])),
      );
}
