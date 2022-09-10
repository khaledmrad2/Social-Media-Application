import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:pied_piper/modules/Post/addpost/Record_Voice/my_microphone.dart';

class MySoundPlayer {
   FlutterSoundPlayer audioplayer;
  bool get isPlaying => audioplayer.isPlaying;
  Future init() async {
    audioplayer = FlutterSoundPlayer();
    await audioplayer.openPlayer();
  }

  void dispose() {
    audioplayer.closePlayer();
    audioplayer = null;
  }

  Future play(VoidCallback whenFinished) async {
    await audioplayer.startPlayer(
      fromURI: SoundRecorder.path,
      whenFinished: whenFinished,
    );
  }

  Future stop() async {
    await audioplayer.stopPlayer();
  }

  Future toggleplay(@required VoidCallback whenFinished) async {
    if (audioplayer.isStopped)
      await play(whenFinished);
    else
      await stop();
  }
}
