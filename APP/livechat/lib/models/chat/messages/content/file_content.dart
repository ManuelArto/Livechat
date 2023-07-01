import 'dart:convert';
import 'dart:io';

import 'content.dart';

class FileContent implements Content<File> {
  File file;
  String get fileString => base64Encode(file.readAsBytesSync());

  FileContent({required this.file});

  @override
  ContentType type = ContentType.file;

  @override
  File get() => file;

  @override
  Map<String, dynamic> toJson() => {"content": file.uri, "type": type};

  factory FileContent.fromJson(Map<String, dynamic> json) => FileContent(
        file: File.fromUri(json["content"]),
      );
}
