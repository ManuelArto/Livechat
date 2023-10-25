import 'chat.dart';

class GroupChat extends Chat {
  String groupId;
  List<String> partecipants;
  String admin;
  DateTime createdAt;

  GroupChat(this.groupId, this.partecipants, this.createdAt, this.admin, String chatName, int userId)
      : super(chatName: chatName, userId: userId);

  factory GroupChat.fromJson(Map<String, dynamic> data, int userId) =>
      GroupChat(
        data["id"],
        [for (var user in data["partecipants"]) user["username"]],
        data["created_at"],
        data["admin"],
        data["name"],
        userId,
      );
}
