import 'dart:async';
import 'dart:io';

import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:livechat/screens/chat/components/single_chat/record_button.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class SendMessage extends StatefulWidget {
  final String chatName;

  const SendMessage(this.chatName, {Key? key}) : super(key: key);

  @override
  SendMessageState createState() => SendMessageState();
}

class SendMessageState extends State<SendMessage> {
  final _controller = TextEditingController();
  late SocketProvider socketProvider;
  String? username;

  final picker = ImagePicker();
  File? attachment;

  @override
  void initState() {
    super.initState();
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    username =
        Provider.of<AuthProvider>(context, listen: false).authUser?.username;
  }

  void _sendMessage() {
    socketProvider.sendMessage(_controller.text, widget.chatName);
    setState(() => _controller.text = "");
  }

  // FILE ? IMAGER\

  void _selectFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        attachment = File(pickedFile.path);
      });
    }
  }

  // AUDIO
  bool _hasRecorded = false;
  int _seconds = 0;
  Timer? _timer;
  File? audio;

  void _recordingStartedCallback() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
  }

  void _recordingFinishedCallback(String path) {
    setState(() => _hasRecorded = true);
    _timer?.cancel();

    final uri = Uri.parse(path);
    audio = File(uri.path);
  }

  void _cleanAudio() {
    setState(() {
      _hasRecorded = false;
      _seconds = 0;
    });
  }

  void _sendAudio() {
    socketProvider.sendAudio(audio!, widget.chatName);
    _cleanAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _selectFromGallery,
          ),
          Expanded(
            child: TextField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              controller: _controller,
              decoration: InputDecoration(
                labelText: _hasRecorded || (_timer?.isActive ?? false)
                    ? _formatDuration(_seconds)
                    : "Type a message...",
                labelStyle: const TextStyle(color: Colors.black),
                fillColor: Colors.grey[200],
                border: InputBorder.none,
              ),
              maxLines: null,
              onChanged: (value) => setState(() {}),
              enabled: !(_hasRecorded || (_timer?.isActive ?? false)),
            ),
          ),
          if (_hasRecorded)
            IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              onPressed: _cleanAudio,
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: _controller.text.isNotEmpty || _hasRecorded
                  ? IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: _hasRecorded
                          ? _sendAudio
                          : _controller.text.trim().isNotEmpty
                              ? _sendMessage
                              : null,
                    )
                  : RecordButton(
                      recordingStartedCallback: _recordingStartedCallback,
                      recordingFinishedCallback: _recordingFinishedCallback,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final formattedMinutes = minutes.toString();
    final formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }
}
