import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/models/post_model.dart';
import 'package:pied_piper/models/reaction_model.dart';
import 'package:pied_piper/modules/Post/Reaction/Reaction_Screen.dart';
import 'package:pied_piper/modules/Post/getpost/getpost_cubit.dart';
import 'package:pied_piper/modules/Post/getpost/states.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/Post/getpost/viewscreen.dart';
import 'package:pied_piper/modules/Post/view_post/states.dart';
import 'package:pied_piper/modules/all_home/home/home_screen.dart';
import 'package:pied_piper/modules/groups/groupmain/group_screen.dart';
import 'package:pied_piper/modules/users/profile/profile_screen.dart';
import 'package:pied_piper/shared/components/components.dart';
import '../../../models/group_model.dart';
import '../../../models/profile_model.dart';
import '../../../shared/components/constants.dart';
import 'package:http/http.dart' as http;

import '../../../shared/network/local/cache_helper.dart';
import '../../all_home/news/getpost_cubit.dart';

class PostCubit extends Cubit<PostStates> {
  PostCubit(
    this.post,
    this.context,
    this.islike,
    this.isangry,
    this.islove,
    this.issad,
    this.ishaha,
    this.issave,
  ) : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);
  postmodel post;
  BuildContext context;
  bool islike;
  bool isangry;
  bool islove;
  bool issad;
  bool ishaha;
  bool issave;
  List<reactionmodel> ReactionsPost = [];
  List<Widget> Reactions = [];

  void makeReaction(context, int id, int reaction_id) {
    String url = MainURL + ReactionURL + "${id}";
    String type = (reaction_id == 1
        ? 'like'
        : reaction_id == 2
            ? "love"
            : reaction_id == 3
                ? "angry"
                : reaction_id == 4
                    ? "haha"
                    : "sad");
    http.post(
      Uri.parse(url),
      headers: TokenHeaders,
      body: {
        "type": type,
      },
    ).then((response) {
      Map Mapvalue = json.decode(response.body);
      if (Mapvalue['success']) {
        post.AllReactionsCount++;
        islike = (reaction_id == 1);
        islove = (reaction_id == 2);
        isangry = (reaction_id == 3);
        ishaha = (reaction_id == 4);
        issad = (reaction_id == 5);
        PostCubit.get(context).emit(PostChangeState());
      } else {
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
              context: context,
              ok: false,
              sendedmessage: "please Check Your Connection Then Try again !"),
        );
      }
    }).catchError(
      (error) {
        emit(PostErrorState(error.toString()));
        print("PostErrorState: ${error.toString()}");
      },
    );
  }

  void GetReactions({
    @required int post_id,
  }) {
    String url = MainURL + GetReactionsURL + "${post_id}";
    ReactionsPost.clear();
    Reactions.clear();
    http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${CacheHelper.GetData(key: 'token')}",
    }).then((value) {
      Map Mapvalue = json.decode(value.body);

      if (Mapvalue['success']) {
        for (var postdata in Mapvalue['allReactions']) {
          reactionmodel reaction = reactionmodel.fromJson(postdata);
          ReactionsPost.add(reaction);
        }
        for (var r in ReactionsPost)
          Reactions.add(ReactionComponent(reaction: r));

        navigateTo(context, reactionscreen(reactions: Reactions));
      } else {}
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void removeReaction(context, int id) {
    String url = MainURL + ReactionURL + "${id}";

    http.post(
      Uri.parse(url),
      headers: TokenHeaders,
      body: {},
    ).then((response) {
      Map Mapvalue = json.decode(response.body);
      if (Mapvalue['success']) {
        post.AllReactionsCount--;
        islike = false;
        islove = false;
        isangry = false;
        ishaha = false;
        issad = false;
        PostCubit.get(context).emit(PostChangeState());
      } else {
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
              context: context, ok: false, sendedmessage: ErrorMessage),
        );
      }
    }).catchError(
      (error) {
        emit(PostErrorState(error.toString()));
        print("PostErrorState: ${error.toString()}");
      },
    );
  }

  void report(context, int id) {
    String url = MainURL + ReportPostURL + "${id}";
    print(url);
    http.post(Uri.parse(url), headers: TokenHeaders, body: {
      'text': 'The Content is inappropriate ',
    }).then((response) {
      Map Mapvalue = json.decode(response.body);
      print(Mapvalue);
      if (Mapvalue['success']) {
        Scaffold.of(context).showSnackBar(MySnakbar(text: 'Report Done!'));
      }
    });
  }

  void save(context, int id) {
    if (issave) {
      String url = MainURL + DeleteSavePostURL + "${id}";
      http.delete(
        Uri.parse(url),
        headers: TokenHeaders,
        body: {},
      ).then((response) {
        Map Mapvalue = json.decode(response.body);

        if (Mapvalue['success']) {
          issave = !issave;
          emit(PostChangeState());
        } else {
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
                context: context, ok: false, sendedmessage: ErrorMessage),
          );
        }
      }).catchError(
        (error) {
          emit(PostErrorState(error.toString()));
          print("PostErrorState: ${error.toString()}");
        },
      );
    } else {
      String url = MainURL + SavePostURL + "${id}";
      http.post(
        Uri.parse(url),
        headers: TokenHeaders,
        body: {},
      ).then((response) {
        Map Mapvalue = json.decode(response.body);

        if (Mapvalue['success']) {
          issave = !issave;

          emit(PostChangeState());
        } else {
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
                context: context, ok: false, sendedmessage: ErrorMessage),
          );
        }
      }).catchError(
        (error) {
          emit(PostErrorState(error.toString()));
          print("PostErrorState: ${error.toString()}");
        },
      );
    }
  }

  void share(context, int id) {
    String url = MainURL + sharepostURL + "${id}";
    http.post(
      Uri.parse(url),
      headers: TokenHeaders,
      body: {},
    ).then((response) async {
      Map Mapvalue = json.decode(response.body);

      if (Mapvalue['success']) {
        Navigator.pop(context);
        navigateTo(context, HomeScreen());
        ScaffoldMessenger.of(context).showSnackBar(
          MySnakbar(text: "The Post Shared SuccessFully! "),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          MySnakbar(text: Mapvalue["message"]),
        );
      }
    }).catchError(
      (error) {
        emit(PostErrorState(error.toString()));
        print("PostErrorState: ${error.toString()}");
      },
    );
  }

  void deletepost(
      int post_id, context, int nextscreen, int profileid, int groupid) {
    String url = MainURL + DeletePostURL + "${post_id}";
    http.delete(
      Uri.parse(url),
      headers: TokenHeaders,
      body: {},
    ).then((response) async {
      Map Mapvalue = json.decode(response.body);
      if (Mapvalue['success']) {
        Navigator.pop(context);
        if (nextscreen == 1)
          navigateTo(context, HomeScreen());
        else if (nextscreen == 2) {
          profilemodel profile;
          String url = MainURL + GetProfile + '${profileid}';
          await http
              .get(Uri.parse(url), headers: TokenHeaders)
              .then((response) {
            Map Mapvalue = json.decode(response.body);
            profile = profilemodel.fromJson(Mapvalue);
            navigateTo(context, ProfileScreen(profile: profile, id: profileid));
          });
        } else if (nextscreen == 3) {
          groupmodel group;
          String url = MainURL + GetGroupURL + "${groupid}";
          await http
              .get(Uri.parse(url), headers: TokenHeaders)
              .then((response) {
            Map Mapvalue = json.decode(response.body);
            group = groupmodel.fromJson(Mapvalue);
            navigateTo(context, GroupScreen(group: group, id: groupid));
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
                context: context, ok: false, sendedmessage: ErrorMessage),
          );
        }
      }
    }).catchError(
      (error) {
        emit(PostErrorState(error.toString()));
        print("PostErrorState: ${error.toString()}");
      },
    );
  }

  void deletepostshared(int post_id, context, int nextscreen, int profileid) {
    String url = MainURL + DeletePostSharedURL + "${post_id}";
    http.delete(
      Uri.parse(url),
      headers: TokenHeaders,
      body: {},
    ).then((response) async {
      Map Mapvalue = json.decode(response.body);
      if (Mapvalue['success']) {
        Navigator.pop(context);
        if (nextscreen == 1)
          navigateTo(context, HomeScreen());
        else if (nextscreen == 2) {
          profilemodel profile;
          String url = MainURL + GetProfile + '${profileid}';
          await http
              .get(Uri.parse(url), headers: TokenHeaders)
              .then((response) {
            Map Mapvalue = json.decode(response.body);
            profile = profilemodel.fromJson(Mapvalue);
            navigateTo(context, ProfileScreen(profile: profile, id: profileid));
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
                context: context, ok: false, sendedmessage: ErrorMessage),
          );
        }
      }
    }).catchError(
      (error) {
        emit(PostErrorState(error.toString()));
        print("PostErrorState: ${error.toString()}");
      },
    );
  }
}
