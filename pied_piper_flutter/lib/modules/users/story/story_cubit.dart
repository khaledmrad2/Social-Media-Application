import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/all_home/home/home_screen.dart';
import 'package:pied_piper/modules/users/story/state.dart';
import 'package:pied_piper/shared/components/constants.dart';

import '../../../shared/components/components.dart';

class StoryCubit extends Cubit<StoryStates> {
  StoryCubit() : super(StoryInitialState());

  static StoryCubit get(context) => BlocProvider.of(context);
  int i = 0;
  void ToNext() {
    i = i + 1;
    emit(ChangeToNext());
  }

  void ToPrevious() {
    i = i - 1;
    emit(ChangeToNext());
  }

  void delete(int id, context) {
    String url = MainURL + DeleteStoryURL + "${id}";
    showLoaderDialog(context);

    http.delete(
      Uri.parse(url),
      headers: TokenHeaders,
      body: {},
    ).then((response) async {
      Map Mapvalue = json.decode(response.body);
      print(Mapvalue);
      if (Mapvalue['success']) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        navigateTo(context, HomeScreen());
      } else {
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
              context: context, ok: false, sendedmessage: ErrorMessage),
        );
      }
    }).catchError(
      (error) {
        emit(StoryErrorState(error.toString()));
        print("PostErrorState: ${error.toString()}");
      },
    );
  }
}
