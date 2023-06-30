import 'dart:async';

import 'package:livechat/models/chat/message.dart';
import 'package:livechat/screens/chat/single_chat_screen.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class MessageAudio extends StatefulWidget {
  final Message message;
  final String imageUrl;
  final bool isMe;
  final int duration;

  const MessageAudio({
    required this.message,
    required this.isMe,
    required this.imageUrl,
    required this.duration,
    Key? key,
  }) : super(key: key);

  @override
  State<MessageAudio> createState() => _MessageAudioState();
}

class _MessageAudioState extends State<MessageAudio> {
  bool isPlay = false;
  int progress = 0;
  late Timer? timer;

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final formattedMinutes = minutes.toString();
    final formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (isPlay && progress < widget.duration.toDouble()) {
        setState(() {
          progress += 1;
        });
      } else if (isPlay) {
        setState(() {
          progress = 0;
          isPlay = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: isPlay
                              ? IconButton(
                                  icon: const Icon(Icons.pause),
                                  onPressed: () {
                                    setState(() {
                                      isPlay = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {
                                    setState(() {
                                      isPlay = true;
                                    });
                                  },
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 18,
                        child: Slider(
                          activeColor: Colors.blueAccent,
                          inactiveColor: Theme.of(context).secondaryHeaderColor,
                          value: progress.toDouble(),
                          min: 0.0,
                          max: widget.duration.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              progress = value.toInt();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Text('${_formatDuration(progress)} / ${_formatDuration(widget.duration)}'),
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
