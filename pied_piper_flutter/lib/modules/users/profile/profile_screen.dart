import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:pied_piper/layout/piedpiper_app/background.dart';
import 'package:pied_piper/modules/users/change_pic/change_pic_screen.dart';
import 'package:pied_piper/modules/users/profile/profile_cubit.dart';
import 'package:pied_piper/modules/users/profile/profile_states.dart';

import '../../../models/post_model.dart';
import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../friends/friends_screen.dart';
import '../mutual_friends/mutualfriends_screen.dart';
import '../personal_information/personalinformation_screen.dart';

class ProfileScreen extends StatelessWidget {
  String location;
  List<dynamic> listFriends;
  String TextBottom;
  String JobTitle;
  bool isFriend;
  bool isSentToMe;
  bool isSendToHim;
  int available;
  int id;
  profilemodel profile;
  BuildContext context;
  ProfileScreen({
    @required this.profile,
    @required this.id,
  });
  final double Coverheight = 240;
  final double Profileheight = 155;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ProfileCubit(),
        child: BlocConsumer<ProfileCubit, ProfileStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
              var list = profile.user.userpost;
              List<Widget> postwidget = [];
              List<postmodel> userpost = [];
              for (var postdata in list) {
                postmodel post = postmodel.fromJson(postdata);
                userpost.add(post);
              }
              for (var v in userpost) {
                if (v.type == 'normal')
                  postwidget.add(Normalpost(
                      post: v, screennumber: 2, profileid: profile.user.id));
                else if (v.type == 'profilePicture')
                  postwidget.add(Picturepost(
                      post: v, screennumber: 2, profileid: profile.user.id));
                else if (v.type == 'job')
                  postwidget.add(Jobpost(
                      post: v, screennumber: 2, profileid: profile.user.id));
                else
                  postwidget.add(Coverpost(
                      post: v, screennumber: 2, profileid: profile.user.id));
              }

              profile.user.visitor
                  ? {
                      ProfileCubit.get(context).isFriend =
                          profile.user.isFriend,
                      ProfileCubit.get(context).isSentToMe =
                          profile.user.isSendToMe,
                      ProfileCubit.get(context).isSendToHim =
                          profile.user.isSentToHim
                    }
                  : {};
              ProfileCubit.get(context).id = profile.user.id;
              listFriends = profile.user.listFriends;
              profile.user.visitor
                  ? {
                      isFriend = ProfileCubit.get(context).isFriend,
                      isSendToHim = ProfileCubit.get(context).isSendToHim,
                      isSentToMe = ProfileCubit.get(context).isSentToMe
                    }
                  : {};
              available = profile.user.available_to_hire;
              TextBottom = ProfileCubit.get(context).ChangeText();
              return Scaffold(
                body: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    BuildTop(context: context),
                    SizedBox(
                      height: 5,
                    ),
                    Column(children: [
                      Text(
                        '${profile.user.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      profile.user.job_title == null
                          ? Container()
                          : Text(
                              '${profile.user.job_title}',
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      profile.user.visitor
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                profile.user.isSendToMe
                                    ? Row(
                                        children: [
                                          Container(
                                            width: 130,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.green[500],
                                            ),
                                            child: Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  ProfileCubit.get(context)
                                                      .ChangeAcceptFriend(
                                                          context: context,
                                                          id: id);
                                                  profile.user.isFriend =
                                                      ProfileCubit.get(context)
                                                          .isFriend;
                                                  profile.user.isSendToMe =
                                                      ProfileCubit.get(context)
                                                          .isSentToMe;
                                                },
                                                child: Text(
                                                  'Accept Request',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      backgroundColor:
                                                          Colors.green[500]),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Container(
                                  width: 130,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.green[500],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      available = available + 1;
                                      profile.user.isFriend
                                          ? {
                                              ProfileCubit.get(context)
                                                  .changeRemoveFriend(
                                                      context: context, id: id),
                                              profile.user.isFriend =
                                                  ProfileCubit.get(context)
                                                      .isFriend
                                            }
                                          : profile.user.isSentToHim
                                              ? {
                                                  ProfileCubit.get(context)
                                                      .changeCancelRequestFriend(
                                                          context: context,
                                                          id: id),
                                                  profile.user.isSentToHim =
                                                      ProfileCubit.get(context)
                                                          .isSendToHim
                                                }
                                              : profile.user.isSendToMe
                                                  ? {
                                                      ProfileCubit.get(context)
                                                          .changeRefuseFriend(
                                                              context: context,
                                                              id: id),
                                                      profile.user.isSendToMe =
                                                          ProfileCubit.get(
                                                                  context)
                                                              .isSentToMe
                                                    }
                                                  : {
                                                      ProfileCubit.get(context)
                                                          .changeAddFriend(
                                                              context: context,
                                                              id: id),
                                                      profile.user.isSentToHim =
                                                          ProfileCubit.get(
                                                                  context)
                                                              .isSendToHim
                                                    };
                                      TextBottom = ProfileCubit.get(context)
                                          .ChangeText();

                                    },
                                    child: Text(
                                      '${TextBottom}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          backgroundColor: Colors.green[500]),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      Divider(
                        color: Colors.grey,
                      ),
                      TextButton(
                        child: Text(
                          '${profile.user.listFriends.length}  Friends',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {

                          navigateTo(
                              context,
                              FriendsScreen(
                                id: profile.user.id,
                                list: profile.user.listFriends,
                              ));
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Column(
                        children: [
                          profile.user.location == null
                              ? Container()
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'From ${profile.user.location}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                          profile.user.visitor
                              ? GestureDetector(
                                  child: Row(
                                    children: [
                                      Icon(Icons.group),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${profile.user.mutualFriendsCount}  Mutual Friends',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        MutualFriendsScreen(
                                            id: profile.user.id));
                                  },
                                )
                              : Container(),
                          profile.user.available_to_hire == 1
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.work),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Available To Hire',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    profile.user.visitor
                                        ? SizedBox(
                                            height: 10,
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
                          profile.user.visitor
                              ? Container()
                              : Column(
                                  children: [
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Edit Personal Information',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            PersonalInformationScreen(
                                              isHome: 1,
                                              fromWhat: 1,
                                              JobTitle: profile.user.job_title,
                                              isHire: profile
                                                  .user.available_to_hire,
                                              location: profile.user.location,
                                              id: id,
                                            ));
                                      },
                                    )
                                  ],
                                ),
                        ],
                      ),
                      Container(
                        height: 10,
                        color: Colors.grey[500],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text('Posts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                      Container(
                        height: 10,
                        color: Colors.grey[500],
                      ),
                    ]),
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
                ),
              );
            }));
  }

  void changetext() {
    isFriend
        ? TextBottom = "Remove Friend"
        : isSentToMe
            ? TextBottom = "Accept Request"
            : isSendToHim
                ? TextBottom = "Cancel Request"
                : TextBottom = "Add Friend";
  }

  Widget BuildTop({@required BuildContext context}) {
    final bottom = Profileheight / 2;
    final top = Coverheight - Profileheight / 2;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: bottom),
              child: BuildCoverImage(context: context)),
          Positioned(
            top: top,
            child: BuildProfileImage(context: context),
          ),
        ]);
  }

  Widget BuildCoverImage({@required BuildContext context}) => Container(
        color: Colors.grey,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Image.network(
              '${profile.user.cover}',
              width: double.infinity,
              height: Coverheight,
              fit: BoxFit.cover,
            ),
            profile.user.visitor?Container():
            IconButton(onPressed: (){
              navigateTo(context, ChangePicScreen(ForWhat: 1,));
            }, icon: Icon(Icons.add_photo_alternate_outlined,color: Colors.white,)),
          ],
        ),
      );
  Widget BuildProfileImage({@required BuildContext context}) => Stack(alignment: Alignment.center, children: [
        CircleAvatar(
          radius: Profileheight / 2 + 5,
          backgroundColor: Colors.white,
        ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
                radius: Profileheight / 2,
                backgroundColor: Colors.grey.shade800,
                backgroundImage: NetworkImage(
                  '${profile.user.picture}',
                )),
            profile.user.visitor?Container():
            IconButton(onPressed: (){
              navigateTo(context, ChangePicScreen(ForWhat: 2,));
            }, icon: Icon(Icons.add_photo_alternate_outlined,color: Colors.white))
          ],
        ),
      ]);
}
