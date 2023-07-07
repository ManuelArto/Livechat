import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:livechat/models/chat/messages/content/audio_content.dart';

class AudioMessagePlayer extends StatefulWidget {
  final AudioContent audio;

  const AudioMessagePlayer({
    required this.audio,
    Key? key,
  }) : super(key: key);

  @override
  AudioMessagePlayerState createState() => AudioMessagePlayerState();
}

class AudioMessagePlayerState extends State<AudioMessagePlayer> {
  late final AudioSource source;
  final _audioPlayer = AudioPlayer();
  late StreamSubscription<PlayerState> _playerStateChangedSubscription;

  late Future<Duration?> futureDuration;

  @override
  void initState() {
    super.initState();
    
    source = AudioSource.uri(Uri.parse(widget.audio.get().path));
    _playerStateChangedSubscription = _audioPlayer.playerStateStream.listen(playerStateListener);
  }

  void playerStateListener(PlayerState state) async {
    if (state.processingState == ProcessingState.completed) {
      await reset();
    }
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    futureDuration = _audioPlayer.setAudioSource(source);
    
    return FutureBuilder<Duration?>(
      future: futureDuration,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _controlButtons(),
              Expanded(child: _slider(snapshot.data)),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _controlButtons() {
    return StreamBuilder<bool>(
      stream: _audioPlayer.playingStream,
      builder: (context, _) {
        final color =
            _audioPlayer.playerState.playing ? Colors.red : Colors.blue;
        final icon =
            _audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              if (_audioPlayer.playerState.playing) {
                pause();
              } else {
                play();
              }
            },
            child: SizedBox(
              width: 25,
              height: 25,
              child: Icon(icon, color: color, size: 30),
            ),
          ),
        );
      },
    );
  }

  Widget _slider(Duration? duration) {
    return StreamBuilder<Duration>(
      stream: _audioPlayer.positionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && duration != null) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CupertinoSlider(
                  value: snapshot.data!.inMicroseconds / duration.inMicroseconds,
                  onChanged: (val) {
                    _audioPlayer.seek(duration * val);
                  },
                ),
              ),
              Text(
                "${_formatDuration(snapshot.data!.inSeconds)}/${_formatDuration(duration.inSeconds)}",
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> play() {
    return _audioPlayer.play();
  }

  Future<void> pause() {
    return _audioPlayer.pause();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    return _audioPlayer.seek(const Duration(milliseconds: 0));
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final formattedMinutes = minutes.toString();
    final formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }
}
