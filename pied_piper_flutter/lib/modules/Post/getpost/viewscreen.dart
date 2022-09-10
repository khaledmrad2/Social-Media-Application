import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/Post/addpost/Record_Voice/my_microphone.dart';
import 'package:pied_piper/modules/Post/getpost/getpost_cubit.dart';
import 'package:pied_piper/modules/Post/getpost/states.dart';
import 'package:path/path.dart';
import 'package:pied_piper/modules/Post/view_post/states.dart';
import '../../../layout/piedpiper_app/background.dart';
import '../../../models/post_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../login/cubit/cubit.dart';
import '../addpost/Record_Voice/Mycrophone_screen.dart';
import '../addpost/Record_Voice/SoundPlayer.dart';
import '../addpost/Video_Player/videoplayfile.dart';
import '../addpost/addpost_cubit.dart';
import '../view_post/post_cubit.dart';

class viewscreen extends StatelessWidget {
  List<Widget> posts;
  viewscreen({@required this.posts});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BackgroundImage(),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            // height: 1000,
            child: ListView.builder(
                shrinkWrap: true,
                //itemExtent: 1000,
                itemCount: posts.length,
                primary: false,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  return posts[index];
                }),
          ),
        ),
      )
    ]);
  }
}
