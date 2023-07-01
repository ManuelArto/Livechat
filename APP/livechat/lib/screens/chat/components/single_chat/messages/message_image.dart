import 'dart:io';

import 'package:livechat/screens/chat/single_chat_screen.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../../../../../models/chat/messages/message.dart';

class MessageImage extends StatefulWidget {
  final Message message;
  final String imageUrl;
  final bool isMe;
  final File image;

  const MessageImage({
    required this.message,
    required this.isMe,
    required this.imageUrl,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<MessageImage> createState() => _MessageImageState();
}

class _MessageImageState extends State<MessageImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              decoration: BoxDecoration(
                color: widget.isMe ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: !widget.isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                  bottomRight: widget.isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment:
                        widget.isMe ? Alignment.topRight : Alignment.topLeft,
                    child: Text(
                      widget.message.sender!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isMe ? Colors.black : Colors.grey[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.file(
                        widget.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -5,
              right: widget.isMe ? null : -10,
              left: widget.isMe ? -10 : null,
              child: GestureDetector(
                onTap: widget.isMe
                    ? () {}
                    : () => Navigator.of(context, rootNavigator: false)
                        .pushReplacementNamed(SingleChatScreen.routeName,
                            arguments: widget.message.sender),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(DateFormat("jm").format(widget.message.time!)),
        ),
      ],
    );
  }
}
