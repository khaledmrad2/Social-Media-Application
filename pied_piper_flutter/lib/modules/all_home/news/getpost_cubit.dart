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
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import '../../../models/story_model.dart';
import '../../../shared/components/constants.dart';
import 'news_screen.dart';

class GetpostCubit extends Cubit<GetpostStates> {
  GetpostCubit() : super(GetpostInitialState());
  static GetpostCubit get(context) => BlocProvider.of(context);
  int likes;
  int comments;
  void Get() async{
    posts.clear();
    stories.clear();
    emit(GetpostLoadingState());
    String url = MainURL + GetAllpostURL;
   await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${CacheHelper.GetData(key: 'token')}",
    }).then((value) async {
      Map Mapvalue = json.decode(value.body);
      for (var postdata in Mapvalue['posts']) {
        postmodel post = postmodel.fromJson(postdata);
        posts.add(post);
      }
      url = MainURL + GetAllStoriesURL;
      await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer ${CacheHelper.GetData(key: 'token')}",
      }).then((value) {
        Map Mapvalue = json.decode(value.body);
        print(Mapvalue);
        for (var story in Mapvalue['stories']) {
          storymodel s = storymodel.fromJson(story);
          stories.add(s);
        }

        emit(GetpostSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(GetpostErrorState(onError));
      });
    });
  }
}
