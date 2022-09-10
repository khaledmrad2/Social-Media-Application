import 'dart:convert';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import '../../../models/group_model.dart';
import '../../../models/post_model.dart';
import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../Post/getpost/SpaceScreen.dart';
import '../../groups/groupmain/group_screen.dart';
import '../../users/profile/profile_screen.dart';
import 'notification_cubit.dart';
import 'notification_states.dart';

class NotificationScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NotificationCubit()..getNotification(),
      child: BlocConsumer<NotificationCubit, NotificationStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = NotificationCubit.get(context).Notification;
            NotificationCubit.get(context)
                .BuildIsSeen(length: list.length, list: list);

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: MyText(
                    text: "Your Notification", fsize: 20, fcolor: Colors.white),
              ),
              body: ConditionalBuilder(
                condition: list.length > 0,
                builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => NotificationComponnents(
                    NotificationText: list[index]["content"],
                    PictureLink: list[index]["user_pic"],
                    context: (context),
                    index: index,
                    type: list[index]["type"],
                    id: list[index]["id"],
                    notification_id: list[index]["notification_id"],
                  ),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => MyDividor(),
                ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          }),
    );
  }

  Widget NotificationComponnents({
    @required String NotificationText,
    @required String PictureLink,
    @required context,
    @required int id,
    @required String type,
    @required int notification_id,
    @required int index,
  }) =>
      GestureDetector(
        child: Container(
          color: !NotificationCubit.get(context).isSeenOne[index]
              ? Colors.green[500]
              : Colors.white,
          width: double.infinity,
          height: 120,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('$PictureLink'),
                radius: 40,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 240,
                    child: Text(
                      '${NotificationText}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        onTap: () async {
          NotificationCubit.get(context).isSeenNow(index: index);
          profilemodel profile;
          String url = MainURL + GetProfile + "${id}";
          String url2 = MainURL + "post/getPost/" + "${id}";
          String url3 = MainURL + GetGroupURL + "${id}";
          String urlseen =
              MainURL + "notification/isSeen/" + "${notification_id}";
          print(urlseen);
          groupmodel group;
          Widget postwidget;
          postmodel Post;
          type == "post"
              ? http.get(Uri.parse(url2), headers: TokenHeaders).then((value) {
                  {
                    http.post(Uri.parse(urlseen),
                        headers: TokenHeaders, body: {});
                  }
                  Map Mapvalue = json.decode(value.body);
                  Post = postmodel.fromJson(Mapvalue["post"]);
                  if (Post.type == 'normal')
                    postwidget = Normalpost(post: Post, screennumber: 1);
                  else if (Post.type == 'job')
                    postwidget = Jobpost(post: Post, screennumber: 1);
                  else if (Post.type == 'profilePicture')
                    postwidget = Picturepost(post: Post, screennumber: 1);
                  else
                    postwidget = Coverpost(post: Post, screennumber: 1);
                  navigateTo(
                      context,
                      SpaceScreen(
                        postwidget: postwidget,
                      ));
                }).catchError((onError) {
                  print(onError.toString());
                })
              : type == "user"
                  ? await http.get(Uri.parse(url), headers: TokenHeaders).then(
                      (response) {
                        Map Mapvalue = json.decode(response.body);

                        profile = profilemodel.fromJson(Mapvalue);

                        if (Mapvalue["success"]) {
                          http.post(Uri.parse(urlseen),
                              headers: TokenHeaders, body: {});
                          navigateTo(
                              context,
                              ProfileScreen(
                                id: id,
                                profile: profile,
                              ));
                        }
                      },
                    ).catchError(
                      (error) {
                        print("GetPost Error is : ${error.toString()}");
                      },
                    )
                  : await http.get(Uri.parse(url3), headers: TokenHeaders).then(
                      (response) {
                        Map Mapvalue = json.decode(response.body);
                        group = groupmodel.fromJson(Mapvalue);
                        if (Mapvalue["success"]) {
                          http.post(Uri.parse(urlseen),
                              headers: TokenHeaders, body: {});
                          navigateTo(
                              context,
                              GroupScreen(
                                id: id,
                                group: group,
                              ));
                        }
                      },
                    ).catchError(
                      (error) {
                        print("GetPost Error is : ${error.toString()}");
                      },
                    );
        },
      );
}
