import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'groupinvite_states.dart';

class GroupInviteCubit extends Cubit<GroupInviteStates> {
  GroupInviteCubit() : super(GroupInviteInitialState());
  static GroupInviteCubit get(context) => BlocProvider.of(context);
  List<dynamic> AllGroupInviteResult = [];
  void getAllGroupInvite({@required int group_id}) {
    emit(GroupInviteLoadingState());
    DioHelper.getData(
            url: MainURL + GroupInviteURL + "${group_id}",
            query: {},
            headers2: TokenHeaders)
        .then((value) {
      AllGroupInviteResult = value.data['friends'];
      emit(GroupInviteSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(GroupInviteErrorState(onError));
    });
  }

  bool isInvite = false;
  Map<String, bool> buttomInvite = {};
  void changeinvite() {
    isInvite = true;
    emit(changetoinvite());
  }

  List<bool> buttomlist = [];

  void ert(int length) {
    for (int i = 0; i < length; i++) {
      buttomlist.add(false);
    }
  }

  void changeplease(
      {@required int index,
      @required int user_id,
      @required int group_id,
      @required BuildContext context}) {
    buttomlist[index] = true;
    SendInvite(user_id: user_id, group_id: group_id, context: context);
    emit(changetoinvite());
  }

  void SendInvite(
      {@required int user_id,
      @required int group_id,
      @required BuildContext context}) {
    emit(GroupInviteLoadingState());
    String url = MainURL + SendInviteURL + "${user_id}" + "/" + "${group_id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(GroupInviteSuccessState());
          ScaffoldMessenger.of(context)
              .showSnackBar(MySnakbar(text: 'You Have a New Friend!'));
        }
      },
    ).catchError(
      (error) {
        emit(GroupInviteErrorState(error));
        ("Request error: ${error.toString()}");
      },
    );
  }
}
