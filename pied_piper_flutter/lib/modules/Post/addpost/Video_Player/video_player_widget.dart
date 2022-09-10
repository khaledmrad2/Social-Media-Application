import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({Key key, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.isInitialized
          ? Container(
              height: 400,
              alignment: Alignment.topCenter,
              child: buildVideo(),
            )
          : Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

  Widget buildVideo() => Stack(
        children: [
          buildVideoPlayer(),
        ],
      );
  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller));
}
