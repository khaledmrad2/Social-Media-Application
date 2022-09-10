import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/models/post_model.dart';
import 'package:pied_piper/modules/Post/getpost/SpaceScreen.dart';
import 'package:pied_piper/modules/Post/getpost/states.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/Post/getpost/viewscreen.dart';
import 'package:pied_piper/shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../emptysceen.dart';

class GetpostCubit extends Cubit<GetpostStates> {
  GetpostCubit() : super(GetpostInitialState());
  static GetpostCubit get(context) => BlocProvider.of(context);
  int likes;
  int comments;
  Future<postmodel> Get(context) async {
    posts.clear();
    String url = MainURL + GetAllpostURL;
    emit(GetpostLoadingState());
    http.get(Uri.parse(url), headers: TokenHeaders).then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        for (var postdata in Mapvalue['posts']) {
          postmodel post = postmodel.fromJson(postdata);
          posts.add(post);
        }
        List<Widget> postwidget = [];
        postwidget.clear();
        for (var v in posts) {
          if (v.type == 'normal')
            postwidget.add(Normalpost(post: v));
          else if (v.type == 'profilePicture')
            postwidget.add(Picturepost(post: v));
          else if (v.type == 'job')
            postwidget.add(Jobpost(post: v));
          else
            postwidget.add(Coverpost(post: v));
        }
         navigateTo(context, viewscreen(posts: postwidget));
      },
    ).catchError(
      (error) {
        emit(GetpostErrorState(error.toString()));
        print("GetPost Error is : ${error.toString()}");
      },
    );
  }
}
