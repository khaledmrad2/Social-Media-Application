import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../models/post_model.dart';
import '../../../shared/components/constants.dart';
import 'group_states.dart';

class GroupHomeCubit extends Cubit<GroupHomeStates>{
  GroupHomeCubit() : super(GroupHomeInitialState());
  static GroupHomeCubit get(context)=> BlocProvider.of(context);
  List<postmodel> GroupsPosts = [];
  void Get() {
    emit(GroupHomeLoadingState());
    String url = MainURL + GetAllpostURL;
    http.get(Uri.parse(url), headers: TokenHeaders).then((value) {
      Map Mapvalue = json.decode(value.body);
      for (var postdata in Mapvalue['posts']) {
        postmodel post = postmodel.fromJson(postdata);
        GroupsPosts.add(post);
      }
      emit(GroupHomeSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(GroupHomeErrorState(onError));
    });
  }

}