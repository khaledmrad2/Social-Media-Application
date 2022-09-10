import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:pied_piper/models/post_model.dart';
import '../../../shared/components/constants.dart';
import 'jobs_status.dart';
import 'package:http/http.dart' as http;

class JobsCubit extends Cubit<JobsStates> {
  JobsCubit() : super(JobsInitialState());
  static JobsCubit get(context) => BlocProvider.of(context);
  List<postmodel> JobsPosts = [];
  void Get() {
    emit(JobsLoadingState());
    String url = MainURL + GetAllpostURL;
    http.get(Uri.parse(url), headers: TokenHeaders).then((value) {
      Map Mapvalue = json.decode(value.body);
      for (var postdata in Mapvalue['posts']) {
        postmodel post = postmodel.fromJson(postdata);
        JobsPosts.add(post);
      }
      emit(JobsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(JobsErrorState(onError));
    });
  }
}
