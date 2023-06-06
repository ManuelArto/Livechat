import 'package:isar/isar.dart';

part 'message.g.dart';

@embedded
class Message {
  final String? id;
  final String? sender;
  final String? content;
  final DateTime? time;

  Message(
      {this.id,
      this.content,
      this.sender,
      this.time});

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "content": content,
        "time": time!.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> data) => Message(
        id: data["id"],
        sender: data["sender"],
        content: data["content"],
        time: DateTime.parse(data["time"]),
      );
}
