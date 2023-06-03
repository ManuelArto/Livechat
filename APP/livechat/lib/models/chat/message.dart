class Message {
  final String id;
  final String sender;
  final String content;
  final DateTime time;
  final String chatName;

  Message(
      {required this.id,
      required this.content,
      required this.sender,
      required this.time,
      required this.chatName});

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "content": content,
        "time": time.toIso8601String(),
        "chatName": chatName,
      };

  factory Message.fromJson(Map<String, dynamic> data) => Message(
        id: data["id"],
        sender: data["sender"],
        content: data["content"],
        time: DateTime.parse(data["time"]),
        chatName: data["chatName"],
      );
}
