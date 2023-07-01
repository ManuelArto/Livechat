import 'dart:convert';
import 'dart:io';

import 'content.dart';

class FileContent implements Content<File> {
  File content;
  String get fileString => base64Encode(content.readAsBytesSync());

  FileContent({required this.content});

  @override
  ContentType type = ContentType.file;

  @override
  File get() => content;

  @override
  Map<String, dynamic> toJson() => {"content": content.uri, "type": type};

  factory FileContent.fromJson(Map<String, dynamic> json) => FileContent(
        content: File.fromUri(Uri.parse(json["content"])),
      );
}
