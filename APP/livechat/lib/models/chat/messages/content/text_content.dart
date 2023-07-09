import 'package:livechat/models/chat/messages/content/content.dart';

class TextContent implements Content<String> {
  String _content;

  TextContent({required String content}) : _content = content;

  @override
  ContentType type = ContentType.text;

  @override
  String get() => _content;

  @override
  Map<String, dynamic> toJson() => {"content": _content, "type": type};

  factory TextContent.fromJson(Map<String, dynamic> json) =>
      TextContent(content: json["content"]);
}
