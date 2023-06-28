import 'dart:io';

import 'package:isar/isar.dart';

part 'message.g.dart';

@embedded
class Message {
  final String? id;
  final String? sender;
  final String? content;
  final DateTime? time;
  final int? duration;
  final File? image;

  Message(
      {this.id,
      this.content,
      this.sender,
      this.time,
      this.duration,
      this.image});

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "content": content,
        "time": time!.toIso8601String(),
        "duration": duration,
        "image": image,
      };

  factory Message.fromJson(Map<String, dynamic> data) => Message(
        id: data["id"],
        sender: data["sender"],
        content: data["content"],
        time: DateTime.parse(data["time"]),
        duration: data["duration"],
        image: data["image"],
      );
}
