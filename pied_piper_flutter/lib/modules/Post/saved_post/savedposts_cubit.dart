import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/models/post_model.dart';
import 'package:pied_piper/modules/Post/saved_post/savedposts_states.dart';
import 'package:pied_piper/shared/components/constants.dart';

import '../../../shared/network/remote/dio_helper.dart';

class SavedPostsCubit extends Cubit<SvaedPostsStates> {
  SavedPostsCubit() : super(SvaedPostsInitialState());
  static SavedPostsCubit get(context) => BlocProvider.of(context);
  List<postmodel> SavedPosts = [];
  void getSvaedPosts() {
    emit(SvaedPostsLoadingState());
    DioHelper.getData(
            url: MainURL + GetSvaedPostsURL, query: {}, headers2: TokenHeaders)
        .then((value) {
      for (var postdata in value.data['saved_posts']) {
        postmodel post = postmodel.fromJson(postdata);
        SavedPosts.add(post);
      }
      emit(SvaedPostsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(SvaedPostsErrorState(onError));
    });
  }
}
