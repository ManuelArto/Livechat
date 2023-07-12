import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../../../../../models/chat/messages/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final String imageUrl;
  final bool isMe;
  final Widget messageWidget;

  const MessageBubble({
    required this.message,
    required this.isMe,
    required this.imageUrl,
    required this.messageWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              constraints: BoxConstraints(maxWidth: size.width * 0.8),
              decoration: BoxDecoration(
                color: isMe
                    ? theme.primaryColor.withOpacity(0.7)
                    : theme.secondaryHeaderColor.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, left: isMe ? 16 : 0, right: isMe ? 0 : 16),
                    child: Text(
                      message.sender!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  messageWidget,
                ],
              ),
            ),
            Positioned(
              top: -5,
              right: isMe ? null : -10,
              left: isMe ? -10 : null,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(DateFormat("jm").format(message.time!)),
        ),
      ],
    );
  }
}
