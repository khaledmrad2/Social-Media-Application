import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/all_home/requests/request_states.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';

class RequestCubit extends Cubit<RequestStates> {
  RequestCubit() : super(RequestInitialState());
  static RequestCubit get(context) => BlocProvider.of(context);
  List<dynamic> Requests = [];
  void getRequests() {
    emit(RequestLoadingState());
    DioHelper.getData(
            url: MainURL + ReceivedRequests, query: {}, headers2: TokenHeaders)
        .then((value) {
      Requests = value.data['requests'];

      emit(RequestSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(RequestErrorState(onError));
    });
  }


  void AcceptRequest({
    BuildContext context,
    int id,

  }) {

    emit(RequestLoadingState());
    String url = MainURL + AcceptFriend + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(RequestSuccessState());
          ScaffoldMessenger.of(context)
              .showSnackBar(MySnakbar(text: 'You Have a New Friend!'));
        }
      },
    ).catchError(
      (error) {
        emit(RequestErrorState(error));
        ("Request error: ${error.toString()}");
      },
    );
  }

  void RefuseRequest({
    BuildContext context,
    int id,

  }) {

    emit(RequestLoadingState());
    String url = MainURL + RefuseFriend + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          ScaffoldMessenger.of(context)
              .showSnackBar(MySnakbar(text: 'You Refuse The Friend Request!'));
          emit(RequestSuccessState());
        }
      },
    ).catchError(
      (error) {
        emit(RequestErrorState(error));
        ("Request error: ${error.toString()}");
      },
    );
  }

  List<bool> buttomlist = [];
  void ert(int length) {
    for (int i = 0; i < length; i++) {
      buttomlist.add(false);
    }
  }
  void changetoAcceptplease(
      {@required int index, @required int id, @required BuildContext context}) {
    buttomlist[index] = true;
    AcceptRequest(id: id, context: context);
    emit(ChangeToConditionState());
  }

  void changetoRefuseplease(
      {@required int index, @required int id, @required BuildContext context}) {
    buttomlist[index] = true;
    RefuseRequest(id: id, context: context);
    emit(ChangeToConditionState());
  }
}
