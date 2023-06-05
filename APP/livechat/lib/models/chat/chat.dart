import 'package:isar/isar.dart';

import '../auth/auth_user.dart';
import 'message.dart';

part 'chat.g.dart';

@collection
class Chat {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String chatName;
  int toRead;
  List<Message> messages = List.empty(growable: true);
  List<String> sections = ["All"];

  final authUser = IsarLink<AuthUser>();

  Chat({
    required this.chatName,
    required this.messages,
    this.toRead = 0,
  });
}
