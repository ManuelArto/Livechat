import 'dart:async';
import 'dart:io';

import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
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
  bool emptyText = false;
  final picker = ImagePicker();
  File? attachment;
  bool isRecording = false;
  Timer? timer;
  int second = 0;

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
  void _sendAudio(){
    setState(() => second = 0);
    stopRecording();
  }

  void _selectFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        attachment = File(pickedFile.path);
      });
      _sendImage();
    }
  }

  void _sendImage(){
    setState(() {
        attachment = null;
    });
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startRecording() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        second++;
      });
    });

    setState(() {
      isRecording = true;
    });
  }

  void stopRecording() {
    timer?.cancel();
    setState(() {
      isRecording = false;
      second = 0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final formattedMinutes = minutes.toString();
    final formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
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
                labelText: isRecording ? _formatDuration(second) : "Type a message...",
                labelStyle: const TextStyle(color: Colors.black),
                fillColor: Colors.grey[200],
                border: InputBorder.none,
              ),
              maxLines: null,
              onChanged: (value) => setState(() {}),
              enabled: !isRecording,
            ),
          ),
          isRecording
              ? IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: () => stopRecording(),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed:
                          _controller.text.trim().isEmpty ? null : _sendMessage,
                    )
                  : IconButton(
                      icon: Icon(
                        isRecording ? Icons.send : Icons.mic,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        isRecording ? _sendAudio() : startRecording();  // TODO: qui andrà la funzione sendAudio()
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
