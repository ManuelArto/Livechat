import 'dart:convert';
import 'dart:io';

import 'content.dart';

class AudioContent implements Content<File> {
  File audio;
  String get audioString => base64Encode(audio.readAsBytesSync());

  AudioContent({required this.audio});

  @override
  ContentType type = ContentType.audio;
  
  @override
  File get() => audio;

  @override
  Map<String, dynamic> toJson() => {"content": audio.uri, "type": type};

  factory AudioContent.fromJson(Map<String, dynamic> json) => AudioContent(
        audio: File.fromUri(Uri.parse(json["content"])),
      );
}
