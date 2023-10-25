import 'package:isar/isar.dart';

import 'messages/message.dart';

part 'chat.g.dart';

@collection
class Chat implements Comparable<Chat> {
  Id id = Isar.autoIncrement;

  String chatName;
  int toRead;
  List<Message> messages = [];
  List<String> sections = ["All"];
  bool canChat = true;

  int? userId;

  Chat({
    required this.chatName,
    required this.userId,
    this.messages = const [],
    this.toRead = 0,
  });
  
  @override
  int compareTo(Chat other) {
    if (messages.isEmpty && other.messages.isEmpty) return 0;
    if (messages.isEmpty) return 1;
    if (other.messages.isEmpty) return -1;

    return other.messages.last.time!.compareTo(messages.last.time!);
  }
}
