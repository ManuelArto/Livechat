import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:livechat/providers/auth_provider.dart';
import 'package:livechat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:livechat/screens/chat/components/single_chat/image_picker_button.dart';
import 'package:livechat/screens/chat/components/single_chat/record_button.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';

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

  void _sendMessage() async {
    socketProvider.sendMessage(_controller.text, "text", widget.chatName);
    setState(() => _controller.text = "");
  }

  void _sendImage(File image) async {
    String filename = image.path.split('/').last;
    socketProvider.sendMessage(image, "image", widget.chatName, filename: filename);
  }

  Future<void> _selectAndSendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ["pdf", "doc", "docx", "txt"],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > MAX_FILE_SIZE) {
        _showSnackBar("File too large", isError: true);
        return;
      }

      String filename = file.name;
      socketProvider.sendMessage(file, "file", widget.chatName, filename: filename);
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

  void _sendAudio() async {
    String filename = audio!.path.split('/').last;
    socketProvider.sendMessage(audio!, "audio", widget.chatName, filename: filename);
    _cleanAudio();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          ImagePickerButton(_sendImage),
          GestureDetector(
            onTap: _selectAndSendFile,
            child: const Icon(
              Icons.attach_file,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: TextField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              controller: _controller,
              style: const TextStyle(color: Colors.black),
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
                color: Colors.black,
              ),
              onPressed: _cleanAudio,
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: theme.colorScheme.secondary,
              ),
              child: _controller.text.isNotEmpty || _hasRecorded
                  ? IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.black,
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

  void _showSnackBar(String text, {bool isError = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }

}
