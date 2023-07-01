enum ContentType { text, audio, file }

abstract interface class Content<T> {
  abstract ContentType type;
  Map<String, dynamic> toJson();
  T get();
}
