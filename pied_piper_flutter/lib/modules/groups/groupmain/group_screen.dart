import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import '../../../layout/piedpiper_app/background.dart';
import '../../../models/group_model.dart';
import '../../../models/post_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/functions.dart';
import '../../Post/addpost/addpost_screen.dart';
import '../../all_home/home/home_screen.dart';
import '../group_invite/groupinvite_screen.dart';
import '../invite_requests/invite_requests_screen.dart';
import '../members/members_screen.dart';
import 'group_cubit.dart';
import 'group_states.dart';

class GroupScreen extends StatelessWidget {
  groupmodel group;
  var formKey = GlobalKey<FormState>();
  int id;
  IconData PrivacyIcon;
  String TextButtom;
  BuildContext context;
  String GroupCover;
  GroupScreen({
    @required this.group,
    @required this.id,
  });
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => GroupCubit(),
        child: BlocConsumer<GroupCubit, GroupStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
              var list = group.user.groupPosts;
              List<Widget> postwidget = [];
              List<postmodel> userpost = [];
              for (var postdata in list) {
                postmodel post = postmodel.fromJson(postdata);
                userpost.add(post);
              }
              for (var v in userpost) {
                if (v.type == 'normal')
                  postwidget.add(Normalpost(post: v, screennumber: 3,groupid: group.user.id));
           else
                  postwidget.add(Jobpost(post: v, screennumber: 3,groupid: group.user.id));
              }
              GroupCubit.get(context).isMember = group.user.isMember;
              GroupCubit.get(context).isRequested = group.user.isRequested;
              GroupCubit.get(context).isInvited = group.user.isInvited;
              PrivacyIcon =
                  GroupCubit.get(context).SetPrivacy(x: group.user.privacy);
              TextButtom = GroupCubit.get(context).ChangeText();
              GroupCubit.get(context).privacy = group.user.privacy;
              GroupCover = GroupCubit.get(context).IsNotCover(group.user.cover);
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      navigateTo(
                          context,
                          AddpostScreen(
                            ForWhat: group.user.id,
                          ));
                    },
                    backgroundColor: Colors.green[500],
                    child: Form(
                      key: formKey,
                      child: Icon(Icons.edit),
                    )
                ),
                appBar: AppBar(
                  backgroundColor: Colors.green[700],
                  leading: group.user.isadmin
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => SureButtom(
                                    context: context,
                                    nextScreen: HomeScreen(),
                                    ok: true,
                                    Text:
                                        "Are You Sure You Want To Delete The Group",
                                    Function: () {
                                      String url =
                                          MainURL + DeleteGroupURL + "${id}";
                                      http
                                          .delete(
                                        Uri.parse(url),
                                        headers: TokenHeaders,
                                      )
                                          .then(
                                        (response) {
                                          Map Mapvalue =
                                              json.decode(response.body);
                                          if (Mapvalue["success"]) {
                                            print(Mapvalue);
                                            // Navigator.pop(context);
                                            // Navigator.pop(context);
                                           // Navigator.pop(context);
                                           // navigateTo(context, HomeScreen());
                                          }
                                        },
                                      ).catchError(
                                        (error) {
                                          ("Search error: ${error.toString()}");
                                        },
                                      );
                                    }));
                          },
                          icon: Icon(Icons.delete),
                        )
                      : Container(),
                  actions: [
                    group.user.isMember && !group.user.isadmin
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => SureButtom(
                                      context: context,
                                      nextScreen: HomeScreen(),
                                      ok: true,
                                      Text:
                                          "Are You Sure You Want To Leave The Group",
                                      Function: () {
                                        String url =
                                            MainURL + LeaveGroupURL + "${id}";
                                        http
                                            .delete(
                                          Uri.parse(url),
                                          headers: TokenHeaders,
                                        )
                                            .then(
                                          (response) {
                                            Map Mapvalue =
                                                json.decode(response.body);
                                                                                if (Mapvalue["success"]) {
                                              navigateTo(context, HomeScreen());
                                            }
                                          },
                                        ).catchError(
                                          (error) {
                                            ("Search error: ${error.toString()}");
                                          },
                                        );
                                      }));
                            },
                            icon: Icon(Icons.logout),
                          )
                        : Container(),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(alignment: Alignment.topRight, children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 240,
                            width: double.infinity,
                            child: GroupCubit.get(context).image != null
                                ? Image.file(GroupCubit.get(context).image)
                                : Image(
                                    image: NetworkImage('${group.user.cover}')),
                          ),
                        ),
                        group.user.isadmin
                            ? Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green[500],
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          GroupCubit.get(context)
                                              .opengallery(context, state);
                                          GroupCubit.get(context)
                                              .UpdatedSuccess();
                                          // GroupCubit.get(context).UpdateCover(context: context, group_id: group.user.id);
                                        }),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.green[500],
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          GroupCubit.get(context)
                                              .opencamera(context, state);
                                          GroupCubit.get(context)
                                              .UpdatedSuccess();
                                          //GroupCubit.get(context).UpdateCover(context: context, group_id: group.user.id);
                                        }),
                                  ),
                                  GroupCubit.get(context).isUpdateCover
                                      ? CircleAvatar(
                                          backgroundColor: Colors.green[500],
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                GroupCubit.get(context).Post(
                                                    context: context,
                                                    group_id: group.user.id);
                                                GroupCubit.get(context)
                                                    .UpdatedSuccess();
                                                group.user.cover =
                                                    GroupCubit.get(context)
                                                        .Cover;
                                                //print(group.user.cover);
                                              }),
                                        )
                                      : Container(),
                                  group.user.isadmin &&
                                          GroupCubit.get(context).Cover !=
                                              "https://res.cloudinary.com/dxntbhjao/image/upload/v1658823449/groups/covers/bh6skvmorc1xvhgwtptr.webp"
                                      ? CircleAvatar(
                                          backgroundColor: Colors.green[500],
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                GroupCubit.get(context)
                                                    .DeleteCover(
                                                        context: context,
                                                        id: id);
                                                group.user.cover =
                                                    GroupCubit.get(context)
                                                        .Cover;
                                                print(group.user.cover);
                                              }),
                                        )
                                      : Container(),
                                  GroupCubit.get(context).image != null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.green[500],
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                GroupCubit.get(context)
                                                    .Cancel(context, state);
                                                GroupCubit.get(context)
                                                    .DeleteCoverCode(
                                                        id: group.user.id,
                                                        context: context);
                                                group.user.cover =
                                                    GroupCubit.get(context)
                                                        .Cover;
                                                print(group.user.cover);
                                              }),
                                        )
                                      : Container(),
                                ],
                              )
                            : Container(),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${group.user.title}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.privacy_tip),
                                  Text(
                                    '${group.user.privacy}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.grey[500]),
                                  ),
                                  group.user.isadmin
                                      ? IconButton(
                                          icon: Icon(
                                            PrivacyIcon,
                                            size: 60,
                                          ),
                                          onPressed: () {
                                            group.user.privacy == "private"
                                                ? {
                                                    GroupCubit.get(context)
                                                        .ChangeFromPrivate(
                                                            x: group
                                                                .user.privacy,
                                                            context: context,
                                                            id: group.user.id),
                                                    PrivacyIcon =
                                                        GroupCubit.get(context)
                                                            .isPublic2
                                                  }
                                                : {
                                                    GroupCubit.get(context)
                                                        .ChangeFromPrivate(
                                                            x: group
                                                                .user.privacy,
                                                            context: context,
                                                            id: group.user.id),
                                                    PrivacyIcon =
                                                        GroupCubit.get(context)
                                                            .isPublic2
                                                  };
                                            group.user.privacy =
                                                GroupCubit.get(context).privacy;
                                          })
                                      : Container(),
                                ]),
                            !isAdmin && !group.user.isMember
                                ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 130,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.0),
                                      color: Colors.green[500],
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        group.user.isInvited
                                            ? {
                                                GroupCubit.get(context)
                                                    .ChangeAcceptRequest(
                                                        context: context,
                                                        id: id),
                                                group.user.isInvited =
                                                    GroupCubit.get(context)
                                                        .isInvited,
                                                group.user.isMember =
                                                    GroupCubit.get(context)
                                                        .isMember,
                                              }
                                            : group.user.isRequested
                                                ? {
                                                    GroupCubit.get(context)
                                                        .changeCancelRequest(
                                                            context:
                                                                context,
                                                            id: id),
                                                    group.user.isRequested =
                                                        GroupCubit.get(
                                                                context)
                                                            .isRequested,
                                                  }
                                                : {
                                                    GroupCubit.get(context)
                                                        .changeInviteRequest(
                                                            context:
                                                                context,
                                                            id: id,
                                                            user_id: group.user.admin_id,),
                                                    group.user.isRequested =
                                                        GroupCubit.get(
                                                                context)
                                                            .isRequested
                                                  };
                                        TextButtom = GroupCubit.get(context)
                                            .ChangeText();
                                      },
                                      child: Text(
                                        '${TextButtom}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            backgroundColor:
                                                Colors.green[500]),
                                      ),
                                    ),
                                  )
                                ],
                                  )
                                : Container(),
                            Divider(
                              color: Colors.grey,
                            ),
                            group.user.isadmin
                                ? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          navigateTo(
                                              context,
                                              InviteRequestsScreen(
                                                  group_id: group.user.id));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.group_add),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Join Requests',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                    ],
                                  )
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                navigateTo(context,
                                    MembersScreen(group_id: group.user.id));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${group.user.memberCount} Member',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey),
                            Row(
                              children: [
                                Icon(Icons.post_add),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '${group.user.groupPosts.length} Post',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            group.user.isMember || group.user.isadmin
                                ? Column(
                                    children: [
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Icon(Icons.group_add),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'Invite Your Friends',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          navigateTo(
                                              context,
                                              InviteGroupScreen(
                                                group_id: id,
                                                admin_id: group.user.admin_id,
                                              )
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                     group.user.privacy=="public"||group.user.isMember||group.user.isadmin?
                      Stack(
                        children: [
                          BackgroundImage(),
                          Container(
                            color: Colors.grey[300],
                            child: ListView.builder(
                                shrinkWrap: true,
                                //itemExtent: 1000,
                                itemCount: postwidget.length,
                                primary: false,
                                padding: const EdgeInsets.all(8),
                                itemBuilder: (BuildContext context, int index) {
                                  return postwidget[index];
                                }),
                          ),
                        ],
                      ):Container(),
                    ],
                  ),
                ),
              );
            }));
  }

  Widget SureButtom2({
    @required Cubit cubit,
    @required context,
    @required nextScreen,
    bool ok,
    @required int id,
    @required Function function2,
    @required Text,
  }) =>
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content: Container(
          alignment: Alignment.center,
          height: 80,
          child: MyText(
            text: (convertToTitleCase("${Text}")),
            fsize: 20,
            fcolor: Colors.black,
          ),
        ),
        actions: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: MyText(
                    text: "Cancel",
                    fsize: 18,
                    fcolor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton(
                    child: MyText(
                      text: "OK",
                      fsize: 18,
                      fcolor: Colors.black,
                    ),
                    onPressed: () {
                      GroupCubit.get(context)
                          .DeleteGroup(id: id, context: context);
                      Navigator.pop(context);
                      navigateTo(context, nextScreen);
                    }),
              ],
            ),
          ),
        ],
      );

  Widget ChangePrivacyButtom({
    @required context,
    bool ok,
    @required Function,
    @required Text,
  }) =>
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content: Container(
          alignment: Alignment.center,
          height: 80,
          child: MyText(
            text: (convertToTitleCase("${Text}")),
            fsize: 20,
            fcolor: Colors.black,
          ),
        ),
        actions: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: MyText(
                    text: "Private",
                    fsize: 18,
                    fcolor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                TextButton(
                    child: MyText(
                      text: "Public",
                      fsize: 18,
                      fcolor: Colors.black,
                    ),
                    onPressed: () {
                      Function();
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        ],
      );
}
