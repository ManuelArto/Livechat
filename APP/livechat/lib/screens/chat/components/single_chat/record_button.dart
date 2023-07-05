import 'package:flutter/material.dart';
import 'package:record/record.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.recordingStartedCallback,
    required this.recordingFinishedCallback,
  }) : super(key: key);

  final void Function() recordingStartedCallback;
  final void Function(String) recordingFinishedCallback;

  @override
  RecordButtonState createState() => RecordButtonState();
}

class RecordButtonState extends State<RecordButton> {
  bool _isRecording = false;
  final _audioRecorder = Record();

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        widget.recordingStartedCallback();
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();

    widget.recordingFinishedCallback(path!);

    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isRecording ? Icons.stop : Icons.mic,
        color: _isRecording
            ? Colors.red.withOpacity(0.3)
            : Colors.black,
      ),
      onPressed: _isRecording ? _stop : _start,
    );
  }
}