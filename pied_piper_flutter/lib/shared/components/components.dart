import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pied_piper/models/post_model.dart';
import 'package:pied_piper/models/reaction_model.dart';
import 'package:pied_piper/modules/Post/add_comment/addcomment_cubit.dart';
import 'package:pied_piper/modules/Post/add_comment/addcomment_screen.dart';
import 'package:pied_piper/modules/Post/comments/comments_Screen.dart';
import 'package:pied_piper/modules/Post/getpost/getpost_cubit.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import '../../models/group_model.dart';
import '../../models/profile_model.dart';
import '../../modules/Post/addpost/Record_Voice/Mycrophone_screen.dart';
import '../../modules/Post/addpost/Record_Voice/SoundPlayer.dart';
import '../../modules/Post/addpost/Record_Voice/my_microphone.dart';
import '../../modules/Post/addpost/Video_Player/videoplayfile.dart';
import '../../modules/Post/view_post/post_cubit.dart';
import '../../modules/Post/view_post/states.dart';
import '../../modules/all_home/news/getpost_cubit.dart';
import '../../modules/groups/groupmain/group_screen.dart';
import '../../modules/users/profile/profile_screen.dart';
import '../../modules/verify/cubit/cubit.dart';
import 'functions.dart';
import 'package:http/http.dart' as http;

////////////////////////////////////////////////////////////////////////////////
///////////////////////////defaultbutton////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Widget defaultbutton({
  double width = double.infinity,
  Color background = Colors.green,
  double fontsize = 20,

  ///On Pressed Function
  @required Function function,
  @required String text,

  ///if text is underline
  bool underline = false,

  ///radius of the borders
  double radius = 24.0,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          ///to right the text in Uppercase
          text.toUpperCase(),
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.bold,

            ///validate if text is underline or not
            decoration: underline == true ? TextDecoration.underline : null,
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        /// to make the border of the bottom as circular as We need
        borderRadius: BorderRadius.circular(radius),

        /// background mean the the bottom will take the color of the background
        color: background,
      ),
    );

////////////////////////////////////////////////////////////////////////////////
///////////////////////////defaultformfield/////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Widget defaultformfield(
        {

        ///content of the field
        @required TextEditingController controller,

        ///tybe of the keyboard
        @required TextInputType type,

        /// Text
        @required String labeltext,

        ///validate function
        @required Function validate,

        ///prefix icon
        IconData prefix,

        ///suffix icon
        IconData suffix,

        ///for the Eye on Password
        bool isclicked = true,

        ///To Know if this field is password
        bool ispassword = false,
        Function onchange,
        var formkey,

        ///to  chane the state of visability for Password
        Function SuffixPressed}) =>
    TextFormField(
      ///all the characters in the text field are replaced by obscuringCharacter
      /// and the text in the field cannot be copied with copy or cut.
      obscureText: ispassword,

      validator: validate,

      controller: controller,
      keyboardType: type,

      key: formkey,
      onChanged: onchange,

      ///for password
      enabled: isclicked,

      decoration: InputDecoration(
        ///number of error lines to appear
        errorMaxLines: 4,

        labelText: '$labeltext',

        ///error style text
        errorStyle: TextStyle(
          color: Colors.red[900],
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceSansPro',
          fontSize: 18,
        ),

        labelStyle: TextStyle(
          color: Colors.white,
        ),
        prefixIcon: Icon(
          prefix,
          color: Colors.white,
        ),

        ///UnderlineInputBorder is line under the field
        enabledBorder: UnderlineInputBorder(
          ///color of the line
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),

        ///Error Border of the field
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                  color: Colors.white,
                ),
                onPressed: SuffixPressed,
              )
            : null,
      ),
    );

////////////////////////////////////////////////////////////////////////////////
///////////////////////////MyText///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Widget MyText({
  ///Text Content
  @required String text,

  ///Font Size
  double fsize = 35,

  ///Font Color
  Color fcolor = Colors.white,
}) =>
    Text(
      text.toString(),
      maxLines: 4,
      style: TextStyle(
          color: fcolor,
          fontSize: fsize,
          fontFamily: 'SourceSansPro',
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none),
    );

////////////////////////////////////////////////////////////////////////////////
///////////////////////////CodeObject///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

///this Class is for the code_form_filed
class CodeObject {
  /// This initial Val for the null
  /// the error was The method '[]=' was called on null.
  /// Receiver: null
  /// Tried calling: []=(index, the val of the first box)
  Map<int, String> s = {};
  Widget Codefield({
    @required BuildContext context,
    @required var index,
  }) =>
      Container(
        color: Colors.white,
        width: 40,
        height: 60,
        child: TextFormField(
          decoration: InputDecoration(
            ///to avoid TextFormField raise up when validator throw an error
            counterText: ' ',
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          onChanged: (value) {
            if (value.length == 1) FocusScope.of(context).nextFocus();
          },
          onSaved: (value) {
            ///when save the state of the cubit
            ///by formKey.currentState.save();
            if (value.length == 1 && value != null) {
              s[index] = value;
            }
          },
          validator: (val) {
            if (val.isEmpty) return '       ';
            return null;
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      );
}

////////////////////////////////////////////////////////////////////////////////
///////////////////////////MyDialogDualButton///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Widget MyDialogDualButton({
  @required context,
  Map Mapvalue,
  var nextscreen,
  var email,
}) =>
    AlertDialog(
      title: Center(child: Text("Message")),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      content: Container(
        height: 60,
        child: MyText(
          text: "${Mapvalue["message"]}",
          fsize: 20,
          fcolor: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          child: MyText(
            text: "Cancel",
            fsize: 20,
            fcolor: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: MyText(
            text: "Continue",
            fsize: 20,
            fcolor: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            navigateTo(context, nextscreen);
            if (email != null)
              VerifyCubit().ResendCodeVerfication(email: email);
          },
        ),
      ],
    );

////////////////////////////////////////////////////////////////////////////////
///////////////////////////MyDialogSingleButton/////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Widget MyDialogSingleButton({
  @required context,
  Map Mapvalue,
  sendedmessage,
  bool ok,
  var nextscreen,
  bool pop = false,
  var function,
}) =>
    AlertDialog(
      title: Center(child: Text("Message")),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
      ),
      content: Container(
        alignment: Alignment.center,
        height: 80,
        child: MyText(
          text: (Mapvalue != null
              ? convertToTitleCase(Mapvalue["message"])
              : convertToTitleCase(sendedmessage)),
          fsize: 18,
          fcolor: Colors.black,
        ),
      ),
      actions: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: TextButton(
            child: MyText(
              text: ok ? "OK" : "Cancel",
              fsize: 18,
              fcolor: Colors.black,
            ),
            onPressed: () {
              if (ok) {
                Navigator.pop(context);
                Navigator.pop(context);
                if (pop == true) {
                  function();
                } else
                  navigateTo(context, nextscreen);
              } else
                Navigator.pop(context);
            },
          ),
        ),
      ],
    );

////////////////////////////////////////////////////////////////////////////////
///////////////////////////MySnakbar////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Widget MySnakbar({
  @required String text,
}) =>
    SnackBar(
      content: Text(
        text,
      ),
      duration: Duration(seconds: 1),
    );

////////////////////////////////////////////////////////////////////////////////
///////////////////////////function-navigateTo//////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Widget Post_button({
  @required icon,
  @required function,
  color = Colors.black,
  bool shape1 = false,
  double sz = 35,
}) =>
    Container(
      height: 50.0,
      width: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
              color: shape1 ? Colors.green[900] : Colors.greenAccent),
          primary: Colors.white,
          elevation: 5,
          shape: shape1
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                )
              : CircleBorder(
                  side: BorderSide(
                    style: BorderStyle.solid,
                  ),
                ),
        ),
        child: Icon(
          icon,
          size: sz,
          color: color,
        ),
        onPressed: function,
      ),
    );

Widget ReactionComponent({
  @required reactionmodel reaction,
}) =>
    Container(
      height: 40,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.red,
            backgroundImage: NetworkImage(reaction.user_picture),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            reaction.user_name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(reaction.type == 'like'
                  ? 'assets/images/like.png'
                  : reaction.type == 'haha'
                      ? 'assets/images/haha.png'
                      : reaction.type == 'love'
                          ? 'assets/images/love.png'
                          : reaction.type == 'angry'
                              ? 'assets/images/angry.png'
                              : 'assets/images/sad.png'),
            ),
          )
        ],
      ),
    );

Widget Normalpost({
  @required postmodel post,
  @required int screennumber,
  int profileid,
  int groupid,
}) =>
    BlocProvider(
      create: (BuildContext context) => PostCubit(
        post,
        context,
        (post.myReactionType == 'like'),
        (post.myReactionType == 'angry'),
        (post.myReactionType == 'love'),
        (post.myReactionType == 'sad'),
        (post.myReactionType == 'haha'),
        (post.is_saved_post),
      ),
      child: BlocConsumer<PostCubit, PostStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                post.user_picture,
                              ),
                            ),
                            post.is_shared_post
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundImage: NetworkImage(
                                        post.shared_user_picture,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,child:
                                !post.is_shared_post?
                                    GestureDetector(onTap: ()async{
                                      profilemodel profile;
                                      String url = MainURL + GetProfile + '${post.user_id}';
                                      await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                            (response) {
                                          Map Mapvalue = json.decode(response.body);
                                          profile = profilemodel.fromJson(Mapvalue);
                                          if (Mapvalue["success"]) {
                                            navigateTo(
                                                context,
                                                ProfileScreen(
                                                  id: post.user_id,
                                                  profile: profile,
                                                ));
                                          }
                                        },
                                      ).catchError(
                                            (error) {
                                          print("GetPost Error is : ${error.toString()}");
                                        },
                                      );
                                    },child: MyText(text: "${post.user_name}",  fcolor: Colors.black,
                                      fsize: 20,)):
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(onTap: ()async{
                                      profilemodel profile;
                                      String url = MainURL + GetProfile + '${post.shared_user_id}';
                                      await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                            (response) {
                                          Map Mapvalue = json.decode(response.body);
                                          profile = profilemodel.fromJson(Mapvalue);
                                          if (Mapvalue["success"]) {
                                            navigateTo(
                                                context,
                                                ProfileScreen(
                                                  id: post.user_id,
                                                  profile: profile,
                                                ));
                                          }
                                        },
                                      ).catchError(
                                            (error) {
                                          print("GetPost Error is : ${error.toString()}");
                                        },
                                      );
                                    },child: MyText(text: "${post.shared_user_name}",  fcolor: Colors.black,
                                      fsize: 20,)),
                                    MyText(text: " share ", fcolor: Colors.black,
                                      fsize: 20,),
                                    Row(
                                      children: [
                                        GestureDetector(onTap: ()async{
                                          profilemodel profile;
                                          String url = MainURL + GetProfile + '${post.user_id}';
                                          await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                                (response) {
                                              Map Mapvalue = json.decode(response.body);
                                              profile = profilemodel.fromJson(Mapvalue);
                                              if (Mapvalue["success"]) {
                                                navigateTo(
                                                    context,
                                                    ProfileScreen(
                                                      id: post.user_id,
                                                      profile: profile,
                                                    ));
                                              }
                                            },
                                          ).catchError(
                                                (error) {
                                              print("GetPost Error is : ${error.toString()}");
                                            },
                                          );
                                        },child: MyText(text: "${post.user_name}",  fcolor: Colors.black,
                                          fsize: 20,)),
                                        MyText(text: '  post',fsize: 18,fcolor: Colors.black)

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  post.is_visitor == false
                                      ? Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                        )
                                      : Container(),
                                  post.group_id != null
                                      ? TextButton(
                                          onPressed: () async {
                                            groupmodel group;
                                            String url = MainURL +
                                                GetGroupURL +
                                                '${post.group_id}';
                                            await http
                                                .get(Uri.parse(url),
                                                    headers: TokenHeaders)
                                                .then(
                                              (response) {
                                                Map Mapvalue =
                                                    json.decode(response.body);
                                                group = groupmodel
                                                    .fromJson(Mapvalue);
                                                if (Mapvalue["success"]) {
                                                  navigateTo(
                                                      context,
                                                      GroupScreen(
                                                        id: post.group_id,
                                                        group: group,
                                                      ));
                                                }
                                              },
                                            ).catchError(
                                              (error) {
                                                print(
                                                    "GetPost Error is : ${error.toString()}");
                                              },
                                            );
                                          },
                                          child: MyText(
                                              text: post.group_name + " Group ",
                                              fcolor: Colors.black,
                                              fsize: 15))
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            PostCubit.get(context).save(context, post.post_id);
                          },
                          child: Icon(
                            !PostCubit.get(context).issave
                                ? Icons.bookmark_add
                                : Icons.bookmark_remove_outlined,
                            size: 30,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            post.is_visitor == false && !post.is_the_post_shared
                                ? PostCubit.get(context).deletepost(
                                    post.post_id,
                                    context,
                                    screennumber,
                                    profileid,
                                    groupid)
                                : post.is_visitor == false ||
                                        post.is_the_post_shared
                                    ? PostCubit.get(context).deletepostshared(
                                        post.shared_post_id,
                                        context,
                                        screennumber,
                                        profileid,
                                      )
                                    : PostCubit.get(context)
                                        .report(context, post.post_id);
                          },
                          child: Icon(
                            (post.is_visitor == true &&
                                    !post.is_the_post_shared)
                                ? Icons.report_gmailerrorred
                                : Icons.delete_forever,
                            size: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                post.text != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.text,
                            maxLines: post.text.toString().length,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              letterSpacing: 0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 24,
                ),
                (post.images.isNotEmpty ||
                        post.voice_record != null ||
                        post.video != null)
                    ? Container(
                        height: 300,
                        child: Center(
                          child: fill(post: post, context: context),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 24,
                ),
                state is PostSelectReaction
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/like.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "like";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 1);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/love.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "love";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 2);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/angry.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "angry";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 3);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/haha.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "haha";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 4);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/sad.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "sad";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 5);
                            },
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                          ),
                          onPressed: () {
                            PostCubit.get(context).emit(PostSelectReaction());
                          },
                          child: PostCubit.get(context).islike
                              ? GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: AssetImage(
                                            'assets/images/like.png'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MyText(
                                        text: 'Like',
                                        fsize: 15,
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    PostCubit.get(context)
                                        .removeReaction(context, post.post_id);
                                  },
                                )
                              : PostCubit.get(context).islove
                                  ? GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage: AssetImage(
                                                'assets/images/love.png'),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          MyText(
                                            text: 'Love',
                                            fsize: 15,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        PostCubit.get(context).removeReaction(
                                            context, post.post_id);
                                      },
                                    )
                                  : PostCubit.get(context).isangry
                                      ? GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundImage: AssetImage(
                                                    'assets/images/angry.png'),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              MyText(
                                                text: 'angry',
                                                fsize: 15,
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            PostCubit.get(context)
                                                .removeReaction(
                                                    context, post.post_id);
                                          },
                                        )
                                      : PostCubit.get(context).ishaha
                                          ? GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/haha.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  MyText(
                                                    text: 'HaHa',
                                                    fsize: 15,
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                PostCubit.get(context)
                                                    .removeReaction(
                                                        context, post.post_id);
                                              },
                                            )
                                          : PostCubit.get(context).issad
                                              ? GestureDetector(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 24,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/sad.png'),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      MyText(
                                                        text: 'Sad',
                                                        fsize: 15,
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    post.myReactionType = "";
                                                    post.isReaction = false;
                                                    PostCubit.get(context)
                                                        .removeReaction(context,
                                                            post.post_id);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.add_reaction_outlined,
                                                    size: 24,
                                                  ),
                                                  onPressed: () {
                                                    PostCubit.get(context).emit(
                                                        PostSelectReaction());
                                                  },
                                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
                        icon: Icon(
                          Icons.add_comment,
                        ),
                        onPressed: () {
                          navigateTo(
                              context,
                              AddCommentScreen(
                                id: post.post_id,
                                numberscreen: screennumber,
                                groupid: groupid,
                                profileid: profileid,
                              ));
                        },
                        label: Text(
                          'Comment',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    post.group_id == null
                        ? Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                              ),
                              icon: Icon(
                                Icons.share,
                              ),
                              onPressed: () {
                                PostCubit.get(context)
                                    .share(context, post.post_id);
                              },
                              label: Text('Share'),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            PostCubit.get(context)
                                .GetReactions(post_id: post.post_id);
                          },
                          child: MyText(
                              text: ' Reactions',
                              fcolor: Colors.green,
                              fsize: 20),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        navigateTo(
                            context, CommentScreen(post_id: post.post_id));
                      },
                      child: MyText(
                          text:
                              '${PostCubit.get(context).post.commentsCount} Comments',
                          fcolor: Colors.green,
                          fsize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
Widget fill({@required postmodel post, @required context}) {
  if (post.images != null && post.images.isNotEmpty) {
    List<String> imageFileList = [];
    for (var x in post.images) {
      imageFileList.add(x.url);
    }
    if (imageFileList.length == 1)
      return Center(
        child: Image.network(imageFileList[0]),
      );
    else {
      return GridView.builder(
          itemCount: imageFileList.length,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 24,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Image.network(imageFileList[index]);
          });
    }
  } else if (post.video != null) {
    return VideoPlayerFileCustum(
      videopath: post.video,
      isnetworkvideo: true,
    );
  } else if (post.voice_record != null) {
    final player = MySoundPlayer();
    player.init();
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return ElevatedButton(
            onPressed: () async {
              SoundRecorder.path = post.voice_record;
              await player.play(() => setState(() {}));
              setState(() {});
            },
            child: Icon(Icons.record_voice_over_outlined));
      }),
    );
  }
}

Widget Picturepost({
  @required postmodel post,
  @required int screennumber,
  int profileid,
  int groupid,
}) =>
    BlocProvider(
      create: (BuildContext context) => PostCubit(
        post,
        context,
        (post.myReactionType == 'like'),
        (post.myReactionType == 'angry'),
        (post.myReactionType == 'love'),
        (post.myReactionType == 'sad'),
        (post.myReactionType == 'haha'),
        (post.is_saved_post),
      ),
      child: BlocConsumer<PostCubit, PostStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            post.user_picture,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                child: GestureDetector(
                                  child: MyText(
                                    text: post.user_name,
                                    fcolor: Colors.black,
                                    fsize: 24,
                                  ),
                                  onTap: ()async{
                                    profilemodel profile;
                                    String url = MainURL + GetProfile + '${post.user_id}';
                                    await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                          (response) {
                                        Map Mapvalue = json.decode(response.body);
                                        profile = profilemodel.fromJson(Mapvalue);
                                        if (Mapvalue["success"]) {
                                          navigateTo(
                                              context,
                                              ProfileScreen(
                                                id: post.user_id,
                                                profile: profile,
                                              ));
                                        }
                                      },
                                    ).catchError(
                                          (error) {
                                        print("GetPost Error is : ${error.toString()}");
                                      },
                                    );
                                  },
                                ),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            PostCubit.get(context).save(context, post.post_id);
                          },
                          child: Icon(
                            !PostCubit.get(context).issave
                                ? Icons.bookmark_add
                                : Icons.bookmark_remove_outlined,
                            size: 30,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            post.is_visitor == false
                                ? PostCubit.get(context).deletepost(
                                    post.post_id,
                                    context,
                                    screennumber,
                                    profileid,
                                    groupid)
                                : PostCubit.get(context)
                                    .report(context, post.post_id);
                          },
                          child: Icon(
                            post.is_visitor == true
                                ? Icons.report_gmailerrorred
                                : Icons.delete_forever,
                            size: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                MyText(
                  text: '${post.user_name} Changes Profile Picture',
                  fcolor: Colors.grey,
                  fsize: 24,
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  child: Center(
                    child: CircleAvatar(
                      radius: 150,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(post.images[0].url),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                state is PostSelectReaction
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/like.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "like";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 1);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/love.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "love";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 2);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/angry.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "angry";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 3);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/haha.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "haha";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 4);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/sad.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "sad";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 5);
                            },
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                          ),
                          onPressed: () {
                            PostCubit.get(context).emit(PostSelectReaction());
                          },
                          child: PostCubit.get(context).islike
                              ? GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: AssetImage(
                                            'assets/images/like.png'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MyText(
                                        text: 'Like',
                                        fsize: 15,
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    PostCubit.get(context)
                                        .removeReaction(context, post.post_id);
                                  },
                                )
                              : PostCubit.get(context).islove
                                  ? GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage: AssetImage(
                                                'assets/images/love.png'),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          MyText(
                                            text: 'Love',
                                            fsize: 15,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        PostCubit.get(context).removeReaction(
                                            context, post.post_id);
                                      },
                                    )
                                  : PostCubit.get(context).isangry
                                      ? GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundImage: AssetImage(
                                                    'assets/images/angry.png'),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              MyText(
                                                text: 'angry',
                                                fsize: 15,
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            PostCubit.get(context)
                                                .removeReaction(
                                                    context, post.post_id);
                                          },
                                        )
                                      : PostCubit.get(context).ishaha
                                          ? GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/haha.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  MyText(
                                                    text: 'HaHa',
                                                    fsize: 15,
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                PostCubit.get(context)
                                                    .removeReaction(
                                                        context, post.post_id);
                                              },
                                            )
                                          : PostCubit.get(context).issad
                                              ? GestureDetector(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 24,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/sad.png'),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      MyText(
                                                        text: 'Sad',
                                                        fsize: 15,
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    post.myReactionType = "";
                                                    post.isReaction = false;
                                                    PostCubit.get(context)
                                                        .removeReaction(context,
                                                            post.post_id);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.add_reaction_outlined,
                                                    size: 24,
                                                  ),
                                                  onPressed: () {
                                                    PostCubit.get(context).emit(
                                                        PostSelectReaction());
                                                  },
                                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
                        icon: Icon(
                          Icons.add_comment,
                        ),
                        onPressed: () {
                          navigateTo(
                              context,
                              AddCommentScreen(
                                id: post.post_id,
                                numberscreen: screennumber,
                                profileid: profileid,
                                groupid: groupid,
                              ));
                        },
                        label: Text(
                          'Comment',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            PostCubit.get(context)
                                .GetReactions(post_id: post.post_id);
                          },
                          child: MyText(
                              text: 'Reactions',
                              fcolor: Colors.green,
                              fsize: 20),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        navigateTo(
                            context, CommentScreen(post_id: post.post_id));
                      },
                      child: MyText(
                          text:
                              '${PostCubit.get(context).post.commentsCount} Comments',
                          fcolor: Colors.green,
                          fsize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
Widget Coverpost({
  @required postmodel post,
  @required int screennumber,
  int profileid,
  int groupid,
}) =>
    BlocProvider(
      create: (BuildContext context) => PostCubit(
        post,
        context,
        (post.myReactionType == 'like'),
        (post.myReactionType == 'angry'),
        (post.myReactionType == 'love'),
        (post.myReactionType == 'sad'),
        (post.myReactionType == 'haha'),
        (post.is_saved_post),
      ),
      child: BlocConsumer<PostCubit, PostStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            post.user_picture,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                child: GestureDetector(
                                  child:   MyText(
                                    text: post.user_name,
                                    fcolor: Colors.black,
                                    fsize: 24,
                                  ),
                                  onTap: ()async{
                                    profilemodel profile;
                                    String url = MainURL + GetProfile + '${post.user_id}';
                                    await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                          (response) {
                                        Map Mapvalue = json.decode(response.body);
                                        profile = profilemodel.fromJson(Mapvalue);
                                        if (Mapvalue["success"]) {
                                          navigateTo(
                                              context,
                                              ProfileScreen(
                                                id: post.user_id,
                                                profile: profile,
                                              ));
                                        }
                                      },
                                    ).catchError(
                                          (error) {
                                        print("GetPost Error is : ${error.toString()}");
                                      },
                                    );
                                  },
                                ),
                              ),
                              // MyText(
                              //   text: post.user_name,
                              //   fcolor: Colors.black,
                              //   fsize: 24,
                              // ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            PostCubit.get(context).save(context, post.post_id);
                          },
                          child: Icon(
                            !PostCubit.get(context).issave
                                ? Icons.bookmark_add
                                : Icons.bookmark_remove_outlined,
                            size: 30,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            post.is_visitor == false
                                ? PostCubit.get(context).deletepost(
                                    post.post_id,
                                    context,
                                    screennumber,
                                    profileid,
                                    groupid)
                                : PostCubit.get(context)
                                    .report(context, post.post_id);
                          },
                          child: Icon(
                            post.is_visitor == true
                                ? Icons.report_gmailerrorred
                                : Icons.delete_forever,
                            size: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                MyText(
                  text: '${post.user_name} Change Profile Cover',
                  fcolor: Colors.grey,
                  fsize: 24,
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  child: Center(
                      child: Container(
                    height: 250.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post.images[0].url),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  )),
                ),
                SizedBox(
                  height: 24,
                ),
                state is PostSelectReaction
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/like.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "like";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 1);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/love.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "love";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 2);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/angry.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "angry";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 3);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/haha.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "haha";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 4);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/sad.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "sad";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 5);
                            },
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                          ),
                          onPressed: () {
                            PostCubit.get(context).emit(PostSelectReaction());
                          },
                          child: PostCubit.get(context).islike
                              ? GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: AssetImage(
                                            'assets/images/like.png'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MyText(
                                        text: 'Like',
                                        fsize: 15,
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    PostCubit.get(context)
                                        .removeReaction(context, post.post_id);
                                  },
                                )
                              : PostCubit.get(context).islove
                                  ? GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage: AssetImage(
                                                'assets/images/love.png'),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          MyText(
                                            text: 'Love',
                                            fsize: 15,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        PostCubit.get(context).removeReaction(
                                            context, post.post_id);
                                      },
                                    )
                                  : PostCubit.get(context).isangry
                                      ? GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundImage: AssetImage(
                                                    'assets/images/angry.png'),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              MyText(
                                                text: 'angry',
                                                fsize: 15,
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            PostCubit.get(context)
                                                .removeReaction(
                                                    context, post.post_id);
                                          },
                                        )
                                      : PostCubit.get(context).ishaha
                                          ? GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/haha.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  MyText(
                                                    text: 'HaHa',
                                                    fsize: 15,
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                PostCubit.get(context)
                                                    .removeReaction(
                                                        context, post.post_id);
                                              },
                                            )
                                          : PostCubit.get(context).issad
                                              ? GestureDetector(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 24,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/sad.png'),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      MyText(
                                                        text: 'Sad',
                                                        fsize: 15,
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    post.myReactionType = "";
                                                    post.isReaction = false;
                                                    PostCubit.get(context)
                                                        .removeReaction(context,
                                                            post.post_id);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.add_reaction_outlined,
                                                    size: 24,
                                                  ),
                                                  onPressed: () {
                                                    PostCubit.get(context).emit(
                                                        PostSelectReaction());
                                                  },
                                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
                        icon: Icon(
                          Icons.add_comment,
                        ),
                        onPressed: () {
                          navigateTo(
                              context,
                              AddCommentScreen(
                                id: post.post_id,
                                numberscreen: screennumber,
                                profileid: profileid,
                                groupid: groupid,
                              ));
                        },
                        label: Text(
                          'Comment',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            PostCubit.get(context)
                                .GetReactions(post_id: post.post_id);
                          },
                          child: MyText(
                              text: 'Reactions',
                              fcolor: Colors.green,
                              fsize: 20),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        navigateTo(
                            context, CommentScreen(post_id: post.post_id));
                      },
                      child: MyText(
                          text:
                              '${PostCubit.get(context).post.commentsCount} Comments',
                          fcolor: Colors.green,
                          fsize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
Widget Jobpost({
  @required postmodel post,
  @required int screennumber,
  int profileid,
  int groupid,
}) =>
    BlocProvider(
      create: (BuildContext context) => PostCubit(
        post,
        context,
        (post.myReactionType == 'like'),
        (post.myReactionType == 'angry'),
        (post.myReactionType == 'love'),
        (post.myReactionType == 'sad'),
        (post.myReactionType == 'haha'),
        (post.is_saved_post),
      ),
      child: BlocConsumer<PostCubit, PostStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                post.user_picture,
                              ),
                            ),
                            post.is_shared_post
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundImage: NetworkImage(
                                        post.shared_user_picture,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                                !post.is_shared_post?
                                GestureDetector(onTap: ()async{
                                  profilemodel profile;
                                  String url = MainURL + GetProfile + '${post.user_id}';
                                  await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                        (response) {
                                      Map Mapvalue = json.decode(response.body);
                                      profile = profilemodel.fromJson(Mapvalue);
                                      if (Mapvalue["success"]) {
                                        navigateTo(
                                            context,
                                            ProfileScreen(
                                              id: post.user_id,
                                              profile: profile,
                                            ));
                                      }
                                    },
                                  ).catchError(
                                        (error) {
                                      print("GetPost Error is : ${error.toString()}");
                                    },
                                  );
                                },child: MyText(text: "${post.user_name}",  fcolor: Colors.black,
                                  fsize: 20,)):
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(onTap: ()async{
                                      profilemodel profile;
                                      String url = MainURL + GetProfile + '${post.shared_user_id}';
                                      await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                            (response) {
                                          Map Mapvalue = json.decode(response.body);
                                          profile = profilemodel.fromJson(Mapvalue);
                                          if (Mapvalue["success"]) {
                                            navigateTo(
                                                context,
                                                ProfileScreen(
                                                  id: post.user_id,
                                                  profile: profile,
                                                ));
                                          }
                                        },
                                      ).catchError(
                                            (error) {
                                          print("GetPost Error is : ${error.toString()}");
                                        },
                                      );
                                    },child: MyText(text: "${post.shared_user_name}",  fcolor: Colors.black,
                                      fsize: 20,)),
                                    MyText(text: " share ", fcolor: Colors.black,
                                      fsize: 20,),
                                    Row(
                                      children: [
                                        GestureDetector(onTap: ()async{
                                          profilemodel profile;
                                          String url = MainURL + GetProfile + '${post.user_id}';
                                          await http.get(Uri.parse(url), headers: TokenHeaders).then(
                                                (response) {
                                              Map Mapvalue = json.decode(response.body);
                                              profile = profilemodel.fromJson(Mapvalue);
                                              if (Mapvalue["success"]) {
                                                navigateTo(
                                                    context,
                                                    ProfileScreen(
                                                      id: post.user_id,
                                                      profile: profile,
                                                    ));
                                              }
                                            },
                                          ).catchError(
                                                (error) {
                                              print("GetPost Error is : ${error.toString()}");
                                            },
                                          );
                                        },child: MyText(text: "${post.user_name}",  fcolor: Colors.black,
                                          fsize: 20,)),
                                        MyText(text: '  post',fsize: 18,fcolor: Colors.black)

                                      ],
                                    ),
                                  ],
                                ),
                              Icon(
                                Icons.verified,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            PostCubit.get(context).save(context, post.post_id);
                          },
                          child: Icon(
                            !PostCubit.get(context).issave
                                ? Icons.bookmark_add
                                : Icons.bookmark_remove_outlined,
                            size: 30,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 5,
                            onPrimary: Colors.green,
                          ),
                          onPressed: () {
                            post.is_visitor == false && !post.is_the_post_shared
                                ? PostCubit.get(context).deletepost(
                                    post.post_id,
                                    context,
                                    screennumber,
                                    profileid,
                                    groupid)
                                : post.is_visitor == false ||
                                        post.is_the_post_shared
                                    ? PostCubit.get(context).deletepostshared(
                                        post.shared_post_id,
                                        context,
                                        screennumber,
                                        profileid,
                                      )
                                    : PostCubit.get(context)
                                        .report(context, post.post_id);
                          },
                          child: Icon(
                            (post.is_visitor == true &&
                                    !post.is_the_post_shared)
                                ? Icons.report_gmailerrorred
                                : Icons.delete_forever,
                            size: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ), // Set rounded corner radius
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.white,
                              offset: Offset(1, 3))
                        ] // Make rounded corner of border
                        ), //
                    child: MyText(
                      text: 'Job Title : ${post.user_job_title}',
                      fsize: 20,
                      fcolor: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    //margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.white,
                              offset: Offset(1, 3))
                        ] // Make rounded corner of border
                        ), //
                    child: MyText(
                      text: 'Location : Syria-${post.user_location}',
                      fsize: 20,
                      fcolor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                post.text != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.text,
                            maxLines: post.text.toString().length,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              letterSpacing: 0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 24,
                ),
                (post.images.isNotEmpty ||
                        post.voice_record != null ||
                        post.video != null)
                    ? Container(
                        height: 300,
                        child: Center(
                          child: fill(post: post, context: context),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 24,
                ),
                state is PostSelectReaction
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/like.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "like";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 1);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/love.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "love";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 2);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/angry.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "angry";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 3);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/haha.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "haha";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 4);
                            },
                          ),
                          GestureDetector(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/sad.png'),
                            ),
                            onTap: () {
                              post.myReactionType = "sad";
                              post.isReaction = true;
                              PostCubit.get(context)
                                  .makeReaction(context, post.post_id, 5);
                            },
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                          ),
                          onPressed: () {
                            PostCubit.get(context).emit(PostSelectReaction());
                          },
                          child: PostCubit.get(context).islike
                              ? GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: AssetImage(
                                            'assets/images/like.png'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MyText(
                                        text: 'Like',
                                        fsize: 15,
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    PostCubit.get(context)
                                        .removeReaction(context, post.post_id);
                                  },
                                )
                              : PostCubit.get(context).islove
                                  ? GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage: AssetImage(
                                                'assets/images/love.png'),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          MyText(
                                            text: 'Love',
                                            fsize: 15,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        PostCubit.get(context).removeReaction(
                                            context, post.post_id);
                                      },
                                    )
                                  : PostCubit.get(context).isangry
                                      ? GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundImage: AssetImage(
                                                    'assets/images/angry.png'),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              MyText(
                                                text: 'angry',
                                                fsize: 15,
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            PostCubit.get(context)
                                                .removeReaction(
                                                    context, post.post_id);
                                          },
                                        )
                                      : PostCubit.get(context).ishaha
                                          ? GestureDetector(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/haha.png'),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  MyText(
                                                    text: 'HaHa',
                                                    fsize: 15,
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                PostCubit.get(context)
                                                    .removeReaction(
                                                        context, post.post_id);
                                              },
                                            )
                                          : PostCubit.get(context).issad
                                              ? GestureDetector(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 24,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/sad.png'),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      MyText(
                                                        text: 'Sad',
                                                        fsize: 15,
                                                      )
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    post.myReactionType = "";
                                                    post.isReaction = false;
                                                    PostCubit.get(context)
                                                        .removeReaction(context,
                                                            post.post_id);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.add_reaction_outlined,
                                                    size: 24,
                                                  ),
                                                  onPressed: () {
                                                    PostCubit.get(context).emit(
                                                        PostSelectReaction());
                                                  },
                                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                        ),
                        icon: Icon(
                          Icons.add_comment,
                        ),
                        onPressed: () {
                          navigateTo(
                              context,
                              AddCommentScreen(
                                id: post.post_id,
                                numberscreen: screennumber,
                                profileid: profileid,
                                groupid: groupid,
                              ));
                        },
                        label: Text(
                          'Comment',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    post.group_id == null
                        ? Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                              ),
                              icon: Icon(
                                Icons.share,
                              ),
                              onPressed: () {
                                PostCubit.get(context)
                                    .share(context, post.post_id);
                              },
                              label: Text('Share'),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            PostCubit.get(context)
                                .GetReactions(post_id: post.post_id);
                          },
                          child: MyText(
                              text: 'Reactions',
                              fcolor: Colors.green,
                              fsize: 20),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        navigateTo(
                            context, CommentScreen(post_id: post.post_id));
                      },
                      child: MyText(
                          text:
                              '${PostCubit.get(context).post.commentsCount} Comments',
                          fcolor: Colors.green,
                          fsize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

Widget FriendsComponents({
  @required int id,
  @required String Picture,
  @required String Name,
  BuildContext context,
}) =>
    Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
      child: GestureDetector(
        onTap: () async {
          profilemodel profile;
          String url = MainURL + GetProfile + "${id}";
          await http.get(Uri.parse(url), headers: TokenHeaders).then(
            (response) {
              Map Mapvalue = json.decode(response.body);
              profile = profilemodel.fromJson(Mapvalue);

              if (Mapvalue["success"]) {
                navigateTo(
                  context,
                  ProfileScreen(
                    id: id,
                    profile: profile,
                  ),
                );
              }
            },
          ).catchError(
            (error) {
              print("GetPost Error is : ${error.toString()}");
            },
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage('${Picture}'),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 180,
              child: Text(
                '${Name}',
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );

Widget personalformfield(
        {

        ///content of the field
        @required TextEditingController controller,

        ///tybe of the keyboard
        @required TextInputType type,

        /// Text
        @required String labeltext,

        ///validate function
        @required Function validate,

        ///prefix icon
        IconData prefix,

        ///suffix icon
        IconData suffix,

        ///for the Eye on Password
        bool isclicked = true,

        ///To Know if this field is password
        bool ispassword = false,
        Function onchange,
        var formkey,

        ///to  chane the state of visability for Password
        Function SuffixPressed}) =>
    TextFormField(
      ///all the characters in the text field are replaced by obscuringCharacter
      /// and the text in the field cannot be copied with copy or cut.
      obscureText: ispassword,

      validator: validate,

      controller: controller,

      keyboardType: type,

      key: formkey,
      onChanged: onchange,

      ///for password
      enabled: isclicked,
      decoration: InputDecoration(
        ///number of error lines to appear
        errorMaxLines: 4,

        labelText: '$labeltext',

        ///error style text
        errorStyle: TextStyle(
          color: Colors.red[900],
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceSansPro',
          fontSize: 18,
        ),

        labelStyle: TextStyle(
          color: Colors.black,
        ),
        prefixIcon: Icon(
          prefix,
          color: Colors.green[500],
        ),

        ///UnderlineInputBorder is line under the field
        enabledBorder: UnderlineInputBorder(
          ///color of the line
          borderSide: BorderSide(color: Colors.green[500]),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green[500]),
        ),

        ///Error Border of the field
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green[500]),
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                  color: Colors.white,
                ),
                onPressed: SuffixPressed,
              )
            : null,
      ),
    );

Widget SureButtom({
  @required context,
  @required nextScreen,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                    Function();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    navigateTo(context, nextScreen);
                  }),
            ],
          ),
        ),
      ],
    );

/// widget for notifications

Widget mydefaultformfield(
        {@required TextEditingController controller,
        @required TextInputType type,
        @required String labeltext,
        @required Function validate,
        IconData prefix,
        Function OnTap,
        IconData suffix,
        Function functionvalidate,
        Function function2,
        bool isclicked = true,
        bool ispassword = false,
        Color c = Colors.white,
        Function function3,
        Function Onchanged,
        Function SuffixPressed}) =>
    TextFormField(
      obscureText: ispassword,
      validator: validate,
      controller: controller,
      keyboardType: type,
      onTap: OnTap,
      onChanged: Onchanged,
      enabled: isclicked,
      decoration: InputDecoration(
        labelText: '$labeltext',
        labelStyle: TextStyle(
          color: c,
        ),
        prefixIcon: Icon(
          prefix,
          color: Colors.green[500],
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.green[500]),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.green[500]),
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                  color: Colors.green[500],
                ),
                onPressed: SuffixPressed,
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget MyDividor() => Container(
      height: 1.0,
      color: Colors.grey,
      width: double.infinity,
    );

/// request friends components

Widget BottomMenu(
        {@required Widget screen,
        @required String BottomName,
        @required context,
        @required Icon BottomIcon}) =>
    GestureDetector(
      onTap: () {
        navigateTo(context, screen);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          height: 75,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomIcon,
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${BottomName}',
                  style: TextStyle(
                    color: Colors.green[500],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
