import 'message.dart';

class Chat {
  String chatName;
  int toRead;
  List<Message> messages = [];
  List<String> sections = ["All"];

  Chat({
    required this.chatName,
    required this.messages,
    this.toRead = 0,
  });
}
