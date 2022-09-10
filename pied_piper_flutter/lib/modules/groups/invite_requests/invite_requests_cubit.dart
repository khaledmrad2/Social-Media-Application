import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'as http;

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'invite_requests_states.dart';
class InviteRequestsCubit extends Cubit<InviteRequestsStates> {
  InviteRequestsCubit() : super(InviteRequestsInitialState());
  static InviteRequestsCubit get(context) => BlocProvider.of(context);
  List<dynamic> AllGroupInviteRequests = [];
  void getAllGroupRequests({@required int group_id}){
    emit(InviteRequestsLoadingState());
    DioHelper.getData(url: MainURL + InvitationRequestURL+ "${group_id}", query: {
    }, headers2: TokenHeaders
    ).then((value) {
      AllGroupInviteRequests = value.data['requests'];
      emit(InviteRequestsSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(InviteRequestsErrorState(onError));
    });
  }
  bool isInvite=false;
  Map<String,bool> buttomInvite = {};
  void changeinvite(){
    isInvite = true;
    emit(changetoAccept());
  }
  List<bool> buttomlist = [];

  void ert(int length) {
    for (int i = 0; i < length; i++)
    {
      buttomlist.add(false);
    }
  }
  void changeplease({
    @required int index,
    @required int user_id,
    @required int group_id,
    @required BuildContext context
  }){
    buttomlist[index] =true;
    AcceptInviteRequest(user_id: user_id, group_id: group_id, context: context);
    emit(changetoAccept());
  }
  void AcceptInviteRequest({
    @required int user_id,
    @required int group_id,
    @required BuildContext context
  }){
    emit(InviteRequestsLoadingState());
    String url = MainURL + AcceptJoinRequestsURL + "${user_id}"+"/"+"${group_id}";
    http.post(
      Uri.parse(url),
      headers: TokenHeaders,
    ).then((response) {
      Map Mapvalue = json.decode(response.body);
      if (Mapvalue["success"])
      {
        emit(InviteRequestsSuccessState());
        ScaffoldMessenger.of(context)
            .showSnackBar(MySnakbar(text: 'You Accept the Request'));

      }
    },
    ).catchError(
          (error) {
        emit(InviteRequestsErrorState(error));
        ("Request error: ${error.toString()}");
      },
    );
  }
}