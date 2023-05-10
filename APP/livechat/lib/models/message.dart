class Message {
  final String sender;
  final String content;
  final DateTime time;
  final String id;
  final String chatName;

  Message(
      {required this.content,
      required this.sender,
      required this.time,
      required this.id,
      required this.chatName});

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "content": content,
        "time": time.toIso8601String(),
        "chatName": chatName,
      };

  factory Message.fromJson(Map<String, dynamic> data) => Message(
      sender: data["sender"],
      content: data["content"],
      time: DateTime.parse(data["time"]),
      id: data["id"],
      chatName: data["chatName"]);
}
