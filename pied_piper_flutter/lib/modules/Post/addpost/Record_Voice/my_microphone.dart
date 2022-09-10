import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder _audioRecorder;

  bool _isRecorderInitialised = false;
  static String path = "";
  bool get isRecording => _audioRecorder.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final statusMic = await Permission.microphone.request();
    if (statusMic != PermissionStatus.granted) {
      throw RecordingPermissionException('microphone permission');
    }
    final statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }
    await _audioRecorder.openRecorder();
    directoryPath = await _directoryPath();
    completePath = await _completePath(directoryPath);
    _createDirectory();
    _createFile();
    _isRecorderInitialised = true;
  }

  void dispose() {
    if (!_isRecorderInitialised) return;

    _audioRecorder.closeRecorder();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder.startRecorder(
      toFile: completePath,
      numChannels: 1,
      sampleRate: 44100,
    );
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;
    var s = await _audioRecorder.stopRecorder();
    File f = File(completePath);
    path = completePath;

  }

  static getfilepath() {
    return path;
  }

  Future toggleRecording() async {
    if (_audioRecorder.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }

  String completePath = "";
  String directoryPath = "";

  Future<String> _completePath(String directory) async {
    var fileName = _fileName();
    return "$directory$fileName";
  }

  Future<String> _directoryPath() async {
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    return "$directoryPath/records/";
  }

  String _fileName() {
    return "record.wav";
  }

  Future _createFile() async {
    File(completePath).create(recursive: true).then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);

    });
  }

  void _createDirectory() async {
    bool isDirectoryCreated = await Directory(directoryPath).exists();
    if (!isDirectoryCreated) {
      Directory(directoryPath).create().then((Directory directory) {
        print("DIRECTORY CREATED AT : " + directory.path);
      });
    }
  }
}
