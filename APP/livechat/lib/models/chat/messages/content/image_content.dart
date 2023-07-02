import 'dart:convert';
import 'dart:io';

import 'content.dart';

class ImageContent implements Content<File> {
  File _content;
  String get fileString => base64Encode(_content.readAsBytesSync());

  ImageContent({required File content}) : _content = content;

  @override
  ContentType type = ContentType.image;

  @override
  File get() => _content;

  @override
  Map<String, dynamic> toJson() => {"content": _content.uri, "type": type};

  factory ImageContent.fromJson(Map<String, dynamic> json) => ImageContent(
        content: File.fromUri(Uri.parse(json["content"])),
      );
}
