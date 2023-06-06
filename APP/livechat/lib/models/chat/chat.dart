import 'package:isar/isar.dart';

import 'message.dart';

part 'chat.g.dart';

@collection
class Chat {
  Id id = Isar.autoIncrement;

  String chatName;
  int toRead;
  List<Message> messages = [];
  List<String> sections = ["All"];

  int? userId;

  Chat({
    required this.chatName,
    required this.messages,
    this.toRead = 0,
  });
}
