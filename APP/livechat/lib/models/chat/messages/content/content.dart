import 'package:livechat/models/chat/messages/content/text_content.dart';

import 'audio_content.dart';
import 'file_content.dart';
import 'image_content.dart';

enum ContentType { text, audio, image, file }

abstract interface class Content<T> {
  abstract ContentType type;
  Map<String, dynamic> toJson();
  T get();

  static Content createContentInstance(String type, dynamic content) {
    switch (findContentType(type)) {
      case ContentType.text:
        return TextContent(content: content);
      case ContentType.audio:
        return AudioContent(content: content);
      case ContentType.file:
        return FileContent(content: content);
      case ContentType.image:
        return ImageContent(content: content);
    }
  }

  static T createContentInstanceFromJson<T>(Map<String, dynamic> json) {
    ContentType contentType = findContentType(json['type']);
    switch (contentType) {
      case ContentType.text:
        return TextContent.fromJson(json) as T;
      case ContentType.audio:
        return AudioContent.fromJson(json) as T;
      case ContentType.file:
        return FileContent.fromJson(json) as T;
      case ContentType.image:
        return ImageContent.fromJson(json) as T;
    }
  }

  static ContentType findContentType(String type) => ContentType.values.firstWhere((e) => e.toString().contains(type));
}
