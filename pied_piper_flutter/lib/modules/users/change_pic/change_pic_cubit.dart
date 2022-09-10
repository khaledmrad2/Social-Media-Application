import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../all_home/home/home_screen.dart';
import '../profile/profile_screen.dart';
import 'cahnge_pic_states.dart';

class ChangePicCubit extends Cubit<ChangePicStates> {
  ChangePicCubit() : super(ChangePicInitialState());
  Widget Mine;
  static ChangePicCubit get(context) => BlocProvider.of(context);

  File image;
  final picker = ImagePicker();

  Future opencamera(context, state) async {
    if (state is ChangePicloadImage &&
        state is ChangePicloadImagefromcamera &&
        state is ChangePicWritingwithPhotoCamera &&
        state is ChangePicWritingwithPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is ChangePicInitialState)
        ChangePicCubit.get(context).emit(ChangePicloadImagefromcamera());
      else
        ChangePicCubit.get(context).emit(ChangePicWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }

  Future opengallery(context, state) async {
    if (state is ChangePicloadImage &&
        state is ChangePicloadImagefromcamera &&
        state is ChangePicWritingwithPhotoCamera &&
        state is ChangePicWritingwithPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is ChangePicInitialState)
        ChangePicCubit.get(context).emit(ChangePicloadImagefromcamera());
      else
        ChangePicCubit.get(context).emit(ChangePicWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }

  bool isComment = false;
  void Cancel(context, state) {
    if (state is ChangePicInitialState) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(text: 'You didn\'t Selected any item!'),
      );
    } else if (state is ChangePicloadImage ||
        state is ChangePicWritingwithPhoto) {
      if (state is ChangePicloadImage)
        ChangePicCubit.get(context).emit(ChangePicInitialState());
      else
        ChangePicCubit.get(context).emit(ChangePicWriting());
    } else if (state is ChangePicloadImagefromcamera ||
        state is ChangePicWritingwithPhotoCamera) {
      image = null;
      if (state is ChangePicloadImagefromcamera)
        ChangePicCubit.get(context).emit(ChangePicInitialState());
      else
        ChangePicCubit.get(context).emit(ChangePicWriting());
    }
  }

  Post({
    @required context,
    @required int forWhat,
  }) async {
    String url;
    forWhat == 2
        ? url = MainURL + UpdateProfilePicURL
        : forWhat == 1
            ? url = MainURL + UpdateProfileCovURL
            : url = MainURL + CraeteStoryURL;
    var postUri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(TokenHeaders);
    if (image != null && forWhat == 2) {
      request.files
          .add(await http.MultipartFile.fromPath('picture', image.path));
    }
    if (image != null && forWhat == 1) {
      request.files.add(await http.MultipartFile.fromPath('cover', image.path));
    }
    if (forWhat == 2) {
      String url3;
      url3 = MainURL + CreatePicturePostURL;
      var postUri = Uri.parse(url3);
      var request2 = new http.MultipartRequest("POST", postUri);
      request2.headers.addAll(TokenHeaders);
      request2.files
          .add(await http.MultipartFile.fromPath('images[]', image.path));
      await request2.send().then((response) async {
        final respStr = await response.stream.bytesToString();
        if (response.statusCode == 200) {
        } else {
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
                context: context, ok: false, sendedmessage: ErrorMessage),
          );
        }
      });
    } else if (forWhat == 1) {
      String url3;
      url3 = MainURL + CreateCoverPostURL;
      var postUri = Uri.parse(url3);
      var request2 = new http.MultipartRequest("POST", postUri);
      request2.headers.addAll(TokenHeaders);
      request2.files
          .add(await http.MultipartFile.fromPath('images[]', image.path));
      await request2.send().then((response) async {
        final respStr = await response.stream.bytesToString();
        if (response.statusCode == 200) {
        } else {
          showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
                context: context, ok: false, sendedmessage: ErrorMessage),
          );
        }
      });
    } else if (forWhat == 3) {
      if (image != null && forWhat == 3) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }
    }
    await request.send().then((response) async {
      Navigator.pop(context);
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (forWhat == 3) {
          Navigator.pop(context);
          Navigator.pop(context);
          navigateTo(context, HomeScreen());
        } else {
          int x = CacheHelper.GetDataint(key: 'id');
          profilemodel profile;
          String url = MainURL + GetProfile + '${x}';
          await http.get(Uri.parse(url), headers: TokenHeaders).then(
            (response) {
              Map Mapvalue = json.decode(response.body);
              profile = profilemodel.fromJson(Mapvalue);
              if (Mapvalue["success"]) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                CacheHelper.saveData(
                    key: 'picture', value: profile.user.picture);
                navigateTo(context, HomeScreen());
                navigateTo(
                    context,
                    ProfileScreen(
                      id: x,
                      profile: profile,
                    ));
              } else {
                showDialog(
                  context: context,
                  builder: (context) => MyDialogSingleButton(
                      context: context, ok: false, sendedmessage: ErrorMessage),
                );
              }
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
              context: context, ok: false, sendedmessage: ErrorMessage),
        );
      }
    }).catchError(
      (error) {
        emit(ChangePicErrorState(error.toString()));
        print("AddpostError: ${error.toString()}");
      },
    );
  }

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
