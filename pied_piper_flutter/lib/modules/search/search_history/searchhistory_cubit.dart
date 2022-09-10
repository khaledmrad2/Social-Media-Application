import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/search/search_history/searchhistory_state.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryStates> {
  SearchHistoryCubit() : super(SearchHistoryInitialState());
  static SearchHistoryCubit get(context) => BlocProvider.of(context);
  List<dynamic> SearchHistoryResult = [];
  void getSearchHistory() {
    emit(SearchHistoryLoadingState());
    DioHelper.getData(
            url: MainURL + SearchHistoryUrl, query: {}, headers2: TokenHeaders)
        .then((value) {
      SearchHistoryResult = value.data['history'];
      emit(SearchHistorySuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(SearchHistoryErrorState(onError));
    });
  }

  void DelelteToHistory({
    @required BuildContext context,
    @required int id,
  }) {
    emit(SearchHistoryLoadingState());
    String url = MainURL+"/search/delete/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(SearchHistorySuccessState());
          //navigateTo(context, ProfileScreen(id: id,));
        }
      },
    ).catchError(
      (error) {
        emit(SearchHistoryErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }
}
