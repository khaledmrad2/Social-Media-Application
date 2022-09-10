import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/search/search/search_states.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../all_home/home/home_screen.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);
  List<dynamic> SearchHistoryResult = [];
  void getSearchHistory() {
    emit(SearchLoadingState());
    String url = MainURL + SearchHistoryUrl;
    http.get(Uri.parse(url), headers: TokenHeaders).then((value) {
      Map Mapvalue = json.decode(value.body);
      SearchHistoryResult = Mapvalue['history'];
      emit(SearchSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(SearchErrorState(onError));
    });
  }

  void Addfriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(SearchLoadingState());
    String url = MainURL+"/friend/add/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(SearchSuccessState());
        }
      },
    ).catchError(
      (error) {
        emit(SearchErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void Removefriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(SearchLoadingState());
    String url = MainURL+"/friend/remove/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(SearchSuccessState());
          navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(SearchErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void Cancelfriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(SearchLoadingState());
    String url = 'http://10.0.2.2:8000/api/friend/cancel/' + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(SearchSuccessState());
          navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(SearchErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void Acceptfriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(SearchLoadingState());
    String url = MainURL+"/friend/accept/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(SearchSuccessState());
          navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(SearchErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void Refusefriend({
    @required BuildContext context,
    @required int id,
  }) {
    emit(SearchLoadingState());
    String url = MainURL+"/friend/refuse/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(SearchSuccessState());
          navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(SearchErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void AddToHistory({
    @required BuildContext context,
    @required int id,
  }) {
    emit(SearchLoadingState());
    String url = MainURL+"search/add/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(SearchSuccessState());
          //navigateTo(context, ProfileScreen(id: id,));
        }
      },
    ).catchError(
      (error) {
        emit(SearchErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  List<dynamic> SearchResult = [];
  void getSearch(String value, BuildContext context) {
    emit(SearchLoadingState());
    DioHelper.getData(
            url: MainURL + SearchUrl,
            query: {
              "search": "${value}",
            },
            headers2: TokenHeaders)
        .then((value) {
      SearchResult = value.data['results'];
      emit(SearchSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(SearchErrorState(onError));
    });
  }

  bool isFriend = false;
  bool isSentToMe = false;
  bool isSendToHim = false;
  String Text2 = "";
  String BottomText = "";
  String ChangeText() {
    isFriend
        ? Text2 = "Remove Friend"
        : isSentToMe
            ? Text2 = "Accept Request"
            : isSendToHim
                ? Text2 = "Cancel Request"
                : Text2 = "Add Friend";
    return Text2;
    // emit(ChangeButtomState());
  }

  void changeRemoveFriend() {
    BottomText = "Add Friend";
    isFriend = false;
    emit(ChangeButtomState());
  }

  void ChangeAcceptFriend() {
    BottomText = "Friend";
    isFriend = true;
    isSentToMe = false;
    emit(ChangeButtomState());
  }

  void changeRefuseFriend() {
    BottomText = "Add Friend";
    isSentToMe = false;
    emit(ChangeButtomState());
  }

  void changeCancelRequestFriend() {
    BottomText = "Add Friend";
    isSendToHim = false;
    emit(ChangeButtomState());
  }

  void changeAddFriend() {
    BottomText = "Cancel Request";
    isSendToHim = true;
    emit(ChangeButtomState());
  }
}
