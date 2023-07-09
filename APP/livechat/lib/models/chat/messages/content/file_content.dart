import 'dart:convert';
import 'dart:io';

import 'content.dart';

class FileContent implements Content<File> {
  File _content;
  String get fileString => base64Encode(_content.readAsBytesSync());

  FileContent({required File content}) : _content = content;

  @override
  ContentType type = ContentType.file;

  @override
  File get() => _content;

  @override
  Map<String, dynamic> toJson() => {"content": _content.uri, "type": type};

  factory FileContent.fromJson(Map<String, dynamic> json) => FileContent(
        content: File.fromUri(Uri.parse(json["content"])),
      );
}
