import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/users/profile/profile_states.dart';

import '../../../models/profile_model.dart';
import '../../../shared/components/constants.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());
  static ProfileCubit get(context) => BlocProvider.of(context);

  void Addfriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(ProfileLoadingState());
    String url = MainURL + "friend/add/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(ProfileSuccessState());
        }
      },
    ).catchError(
      (error) {
        emit(ProfileErrorState(error));
        ("Profile Add error: ${error.toString()}");
      },
    );
  }

  void Removefriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(ProfileLoadingState());
    String url = MainURL + RemoveFriend + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(ProfileSuccessState());
          // navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(ProfileErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void Cancelfriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(ProfileLoadingState());
    String url = MainURL + CancelFriend + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(ProfileSuccessState());
          //  navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(ProfileErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void Acceptfriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(ProfileLoadingState());
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
          emit(ProfileSuccessState());
          // navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(ProfileErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void Refusefriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(ProfileLoadingState());
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
          emit(ProfileSuccessState());
          // navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(ProfileErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  int id;
  bool isFriend = false;
  bool isSentToMe = false;
  bool isSendToHim = false;
  String Text2 = "";
  String BottomText = "";
  String ChangeText() {
    isFriend
        ? Text2 = "Remove Friend"
        : isSentToMe
            ? Text2 = "Refuse Request"
            : isSendToHim
                ? Text2 = "Cancel Request"
                : Text2 = "Add Friend";
    return Text2;
    // emit(ChangeButtomState());
  }

  void changeRemoveFriend({
    @required BuildContext context,
    @required int id,
  }) {
    BottomText = "Add Friend";
    isFriend = false;
    Removefriend(context: context, id: id);
    emit(ChangeButtomState());
  }

  void ChangeAcceptFriend({
    @required BuildContext context,
    @required int id,
  }) {
    BottomText = "Friend";
    isFriend = true;
    isSentToMe = false;
    Acceptfriend(context: context, id: id);
    emit(ChangeButtomState());
  }

  void changeRefuseFriend({
    @required BuildContext context,
    @required int id,
  }) {
    BottomText = "Add Friend";
    isSentToMe = false;
    Refusefriend(context: context, id: id);
    emit(ChangeButtomState());
  }

  void changeCancelRequestFriend({
    @required BuildContext context,
    @required int id,
  }) {
    BottomText = "Add Friend";
    isSendToHim = !isSendToHim;
    Cancelfriend(context: context, id: id);
    emit(ChangeButtomState());
  }

  void changeAddFriend({
    @required BuildContext context,
    @required int id,
  }) {
    BottomText = "Cancel Request";
    isSendToHim = true;
    Addfriend(context: context, id: id);
    emit(ChangeButtomState());
  }
}
