import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pied_piper/modules/Post/comments/comments_Screen.dart';
import 'package:pied_piper/shared/components/constants.dart';

import '../../../models/group_model.dart';
import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../all_home/home/home_screen.dart';
import '../../groups/groupmain/group_screen.dart';
import '../../users/profile/profile_screen.dart';
import 'addcomment_states.dart';

class AddCommentCubit extends Cubit<AddCommentStates> {
  AddCommentCubit() : super(AddCommentInitialState());
  Widget Mine;
  static AddCommentCubit get(context) => BlocProvider.of(context);

  File image;
  final picker = ImagePicker();

  Future opencamera(context, state) async {
    if (state is AddCommentloadImage &&
        state is AddCommentloadImagefromcamera &&
        state is AddCommentWritingwithPhotoCamera &&
        state is AddCommentWritingwithPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is AddCommentInitialState)
        AddCommentCubit.get(context).emit(AddCommentloadImagefromcamera());
      else
        AddCommentCubit.get(context).emit(AddCommentWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }

  Future opengallery(context, state) async {
    if (state is AddCommentloadImage &&
        state is AddCommentloadImagefromcamera &&
        state is AddCommentWritingwithPhotoCamera &&
        state is AddCommentWritingwithPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is AddCommentInitialState)
        AddCommentCubit.get(context).emit(AddCommentloadImagefromcamera());
      else
        AddCommentCubit.get(context).emit(AddCommentWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }

  bool isComment = false;
  void Cancel(context, state) {
    if (state is AddCommentInitialState) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(text: 'You didn\'t Selected any item!'),
      );
    } else if (state is AddCommentloadImage ||
        state is AddCommentWritingwithPhoto) {
      if (state is AddCommentloadImage)
        AddCommentCubit.get(context).emit(AddCommentInitialState());
      else
        AddCommentCubit.get(context).emit(AddCommentWriting());
    } else if (state is AddCommentloadImagefromcamera ||
        state is AddCommentWritingwithPhotoCamera) {
      image = null;
      if (state is AddCommentloadImagefromcamera)
        AddCommentCubit.get(context).emit(AddCommentInitialState());
      else
        AddCommentCubit.get(context).emit(AddCommentWriting());
    }
  }

  void changeWriteComment() {
    isComment = true;
    emit(ChangeWriteComment());
  }

  void changeNoComment() {
    isComment = false;
    emit(AddCommentInitialState());
  }

  bool check() {
    if (state is AddCommentInitialState)
      return false;
    else
      return true;
  }

  Post(
      {@required text,
      @required context,
      @required int id,
      int groupid,
      int numberscreen,
      int profileid}) async {
    String url = MainURL + "comment/create/" + "${id}";
    showLoaderDialog(context);
    var postUri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(TokenHeaders);

    if (text.isNotEmpty) {
      request.fields['text'] = text.toString();
    }
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    await request.send().then((response) async {
      final respStr = await response.stream.bytesToString();
      Navigator.pop(context);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        if (numberscreen == 1) {
          Navigator.pop(context);
          navigateTo(context, HomeScreen());
        } else if (numberscreen == 2) {
          profilemodel profile;
          Navigator.pop(context);

          String url = MainURL + GetProfile + '${profileid}';
          await http
              .get(Uri.parse(url), headers: TokenHeaders)
              .then((response) {
            Map Mapvalue = json.decode(response.body);
            profile = profilemodel.fromJson(Mapvalue);
            navigateTo(context, ProfileScreen(profile: profile, id: profileid));
          });
        } else if (numberscreen == 3) {
          Navigator.pop(context);

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
      } else {
        Navigator.pop(context);
      }
    }).catchError(
      (error) {
        emit(AddCommentErrorState(error.toString()));
        print("AddpostError: ${error.toString()}");
      },
    );
  }

  // void Comment({
  //   @required String Text,
  //   @required int id,
  //   BuildContext context,
  // }) {
  //   ///Update state
  //   emit(AddCommentLoadingState());
  //   String url = '';
  //   http.post(
  //     Uri.parse(MainURL + "comment/create/"+"${id}"),
  //     headers: TokenHeaders,
  //     body:
  //     {
  //       "text":Text,
  //       if(image!=null)
  //   "image":image
  //   }
  //   ).then(
  //         (response) {
  //       ///decode the response
  //       Map Mapvalue = json.decode(response.body);
  //       if (!Mapvalue["success"]) {
  //         ///Need To Verify Email
  //          if (response.statusCode == 403) {
  //           if (Mapvalue["message"] == "unauthenticated")
  //           showDialog(
  //             context: context,
  //             builder: (context) => MyDialogSingleButton(
  //               context: context,
  //               Mapvalue: Mapvalue,
  //
  //               ///Ok Mean that This Button is Cancel
  //               ///and don't Move to Anther Screen
  //               ok: false,
  //             ),
  //           );
  //         }
  //       }
  //
  //       ///This is Success State
  //       else {
  //         emit(AddCommentSuccessState());
  //         navigateTo(context, HomeScreen());
  //       }
  //     },
  //   ).catchError(
  //         (error) {
  //       emit(AddCommentErrorState(error));
  //       ("loginDataEnter: ${error.toString()}");
  //     },
  //   );
  // }

  showLoaderDialog(context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

//
//
//
// void changeWriteComment()
// {
//   isComment = true;
//   emit(ChangeWriteComment());
// }
// void changeNoComment()
// {
//   isComment = false;
//   emit(ChangeWriteComment());
// }
//
//
