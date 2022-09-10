import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pied_piper/modules/Post/addpost/Video_Player/video_player_widget.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerFileCustum extends StatefulWidget {
  VideoPlayerFileCustum({Key key, this.videopath, this.isnetworkvideo})
      : super(key: key);
  final String videopath;
  bool isnetworkvideo = false;

  @override
  _VideoPlayerFileState createState() => _VideoPlayerFileState();
}

class _VideoPlayerFileState extends State<VideoPlayerFileCustum> {
  VideoPlayerController _controller;
  Future<void> _video;

  @override
  void initState() {
    super.initState();
    _controller = widget.isnetworkvideo==false
        ? VideoPlayerController.file(File(widget.videopath))
        : VideoPlayerController.network(widget.videopath)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((value) => _controller.pause());
    _video = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 40,
        ),
        VideoPlayerWidget(
          controller: _controller,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (_controller.value.isPlaying) {
                setState(() {
                  _controller.pause();
                });
              } else {
                setState(() {
                  _controller.play();
                });
              }
            },
            child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
            ),
          ),
        ),

        SizedBox(
          width: 10,
        ),
        // Container(
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.green,
        //     child: Icon(
        //         _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
        //     onPressed: () {
        //       if (_controller.value.isPlaying) {
        //         setState(() {
        //           _controller.pause();
        //         });
        //       } else {
        //         setState(() {
        //           _controller.play();
        //         });
        //       }
        //     },
        //   ),
        // )
      ],
    );
  }
}
