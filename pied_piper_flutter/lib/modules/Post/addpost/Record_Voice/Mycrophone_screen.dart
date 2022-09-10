import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:pied_piper/modules/Post/addpost/Record_Voice/my_microphone.dart';
import 'package:pied_piper/modules/Post/addpost/states.dart';
import 'package:pied_piper/shared/components/components.dart';
import '../../../../shared/components/constants.dart';
import 'SoundPlayer.dart';
import '../addpost_cubit.dart';

class micro_screen extends StatefulWidget {
  BuildContext Mycontext;
  var state;

  ///without record or delete only hear
  bool runonly = false;
  micro_screen({@required this.Mycontext, this.state, this.runonly});
  @override
  _micro_screenState createState() => _micro_screenState();
}

class _micro_screenState extends State<micro_screen> {
  final recorder = SoundRecorder();
  final player = MySoundPlayer();
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  void dispose() {
    player.dispose();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Row(
            children: [
              MyText(text: 'Pied Piper '),
              MyText(text: widget.runonly==true?'Player':'Recorder'),
            ],
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: buildstart(),
        ),
      );
  Widget buildstart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'Stop' : 'Start';
    final primary = isRecording ? Colors.red : Colors.green;
    final isPlaying = player.isPlaying;
    final iconplay = isPlaying ? Icons.stop : Icons.play_arrow;
    final textplay = isPlaying ? 'Stop Playing' : 'Start Playing';
    final primaryplay = isPlaying ? Colors.red : Colors.green;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.runonly == false
            ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(175, 50),
                  primary: primary,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  pressstart = true;
                  final isRecording = await recorder.toggleRecording();
                  setState(() {});
                },
                icon: Icon(icon),
                label: MyText(text: text, fsize: 20),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(175, 50),
            primary: primaryplay,
            onPrimary: Colors.white,
          ),
          onPressed: () async {
            if (SoundRecorder.path.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please Record Voice Then Try Again'),
                  duration: Duration(seconds: 1),
                ),
              );
            } else {
              await player.toggleplay(() => setState(() {}));
              setState(() {});
            }
          },
          icon: Icon(iconplay),
          label: MyText(text: textplay, fsize: 20),
        ),
        SizedBox(
          height: 20,
        ),
        widget.runonly == false
            ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(175, 50),
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  if (pressstart) {
                    if (widget.state is AddpostInitialState) {
                      AddpostCubit.get(widget.Mycontext)
                          .emit(AddpostloadVoice());
                      widget.state = AddpostloadVoice();
                    } else {
                      AddpostCubit.get(widget.Mycontext)
                          .emit(AddpostWritingwithVoice());
                      widget.state = AddpostWritingwithVoice();
                    }
                  } else {
                    if (widget.state is AddpostWritingwithVoice) {
                      AddpostCubit.get(widget.Mycontext).emit(AddpostWriting());
                      widget.state = AddpostWriting();
                    } else {
                      AddpostCubit.get(widget.Mycontext)
                          .emit(AddpostInitialState());
                      widget.state = AddpostInitialState();
                    }
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.done),
                label: MyText(text: 'Done', fsize: 20),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        widget.runonly == false
            ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(175, 50),
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  if (SoundRecorder.path.isEmpty || !pressstart) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Record Voice Then Try Again'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    SoundRecorder.path = "";
                    pressstart = false;
                    if (widget.state is AddpostWritingwithVoice) {
                      widget.state = AddpostWriting();
                      AddpostCubit.get(widget.Mycontext).emit(AddpostWriting());
                    } else {
                      widget.state = AddpostloadVoice();
                      AddpostCubit.get(widget.Mycontext)
                          .emit(AddpostloadVoice());
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Voice Deleted Successfully ! '),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.delete_forever),
                label: MyText(text: 'Delete', fsize: 20),
              )
            : Container(),
        widget.runonly == true
            ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(175, 50),
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  SoundRecorder.path = "";
                  Navigator.pop(context);
                },
                icon: Icon(Icons.done_all),
                label: MyText(text: 'Done', fsize: 20),
              )
            : Container(),
      ],
    );
  }
}
