import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/all_home/home/home_screen.dart';
import 'package:pied_piper/shared/components/constants.dart';

import '../../../shared/components/components.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'comments_Screen.dart';
import 'comments_states.dart';

class CommentCubit extends Cubit<CommentStates> {
  CommentCubit() : super(CommentInitialState());
  static CommentCubit get(context) => BlocProvider.of(context);
  List<dynamic> Comments = [];
  int number = 0;
  bool isRow = false;
  void getComments({@required int post_id}) {
    emit(CommentLoadingState());
    DioHelper.getData(
            url: MainURL + GetComment + "${post_id}",
            query: {},
            headers2: TokenHeaders)
        .then((value) {
      Comments = value.data['allComments'];

      emit(CommentSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(CommentErrorState(onError));
    });
  }

  List<bool> buttomlist = [];
  List<String> Reactionlist = [];
  List<dynamic> comments = [];
  void ert(int length,List<dynamic>reactions) {
    for (int i = 0; i < length; i++) {
     buttomlist.add(false);
    }
  }



  void ert2(int length) {
    for (int i = 0; i < length; i++) {
      Reactionlist.add(comments[i]["myReactionType"]);
    }
  }

  void DeleteComment({
    @required int id,
    @required BuildContext context,
    @required int post_id,
  }) {
    emit(CommentLoadingState());
    String url = MainURL + DeleteCommentURL + "${id}";
    http
        .delete(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        print(Mapvalue);
        if (Mapvalue['success']) {
          emit(CommentSuccessState());

         // navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(CommentErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  bool isdelete = false;
  changedelete() {}

  void ReactionAdd({
    @required int id,
    @required BuildContext context,
    Map body,
  }) {
    emit(CommentLoadingState());
    String url = MainURL + ReactionCommentURL + "${id}";
    http.post(Uri.parse(url), headers: TokenHeaders, body: body).then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(CommentSuccessState());
        }
      },
    ).catchError(
      (error) {
        emit(CommentErrorState(error));
        ("Profile Add error: ${error.toString()}");
      },
    );
  }

  changeToRow(int index) {
    buttomlist[index] = true;
    emit(CommentReactionRow());
  }

  changeFromRow(int index) {
    buttomlist[index] = false;
    emit(CommentReactionRow());
  }

  chooseReation(
      {@required int index,
      @required int index2,
      int id,
      @required BuildContext context}) {
    index2 == 0
        ? {
            Reactionlist[index] = "",
            ReactionAdd(id: id, context: context, body: {})
          }
        : index2 == 1
            ? {
                Reactionlist[index] = "like",
                ReactionAdd(id: id, context: context, body: {"type": "like"})
              }
            : index2 == 2
                ? {
                    Reactionlist[index] = "love",
                    ReactionAdd(
                        id: id, context: context, body: {"type": "love"})
                  }
                : index2 == 3
                    ? {
                        Reactionlist[index] = "angry",
                        ReactionAdd(
                            id: id, context: context, body: {"type": "angry"})
                      }
                    : index2 == 4
                        ? {
                            Reactionlist[index] = "haha",
                            ReactionAdd(
                                id: id,
                                context: context,
                                body: {"type": "haha"})
                          }
                        : {
                            Reactionlist[index] = "sad",
                            ReactionAdd(
                                id: id, context: context, body: {"type": "sad"})
                          };
    emit(ChooseReaction());
  }
}
