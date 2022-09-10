import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'as http;

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'myinvitations_states.dart';
class MyInvitationsCubit extends Cubit<MyInvitationsStates>{
  MyInvitationsCubit() : super(MyInvitationsInitialState());
  static MyInvitationsCubit get(context)=> BlocProvider.of(context);
  List<bool> IsAccept = [];
  void ert(int length) {
    for (int i = 0; i < length; i++)
    {
      IsAccept.add(false);
    }
  }
  void ChangeToAccept({@required int index}){
    IsAccept[index] = true;
    emit(ChangeAcceptState());
  }
  List<dynamic> MyInvitations = [];
  void getMyInvitations(){
    emit(MyInvitationsLoadingState());
    DioHelper.getData(url: MainURL + MyInvitationsURL, query :{
    },headers2: TokenHeaders
    ).then((value) {
      MyInvitations = value.data['groups'];
      emit(MyInvitationsSuccessState());
    }).catchError((onError)
    {
      print(onError.toString());
      emit(MyInvitationsErrorState(onError));
    });
  }
  // bool isFriend = false;
  void AcceptRequest({
    BuildContext context,
    int id,
  }){
    emit(MyInvitationsLoadingState());
    String url = MainURL + AcceptInvitationURL + "${id}";
    http.post(
      Uri.parse(url),
      headers: TokenHeaders,
    ).then((response) {
      Map Mapvalue = json.decode(response.body);
      
      if (Mapvalue["success"])
      {
        emit(MyInvitationsSuccessState());
        ScaffoldMessenger.of(context)
            .showSnackBar(MySnakbar(text: 'You Have a New Group!'));

      }
    },
    ).catchError(
          (error) {
        emit(MyInvitationsErrorState(error));
        ("Accept error: ${error.toString()}");
      },
    );
  }
}