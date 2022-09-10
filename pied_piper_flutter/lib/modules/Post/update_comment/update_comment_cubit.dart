
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:pied_piper/modules/Post/update_comment/update_comment_states.dart';
import 'package:pied_piper/shared/components/constants.dart';

import '../../../shared/components/components.dart';
import '../comments/comments_Screen.dart';

class UpdateCubit extends Cubit<UpdateStates> {
  UpdateCubit() : super(UpdateInitialState());
  Widget Mine;
  static UpdateCubit get(context) => BlocProvider.of(context);
  bool xorginalphoto = false;
  void changedeleteorginal(){
    xorginalphoto = true;
    emit(deleteorginalimage());
  }
  File image;
  final picker = ImagePicker();
  File video;
  Color SelectedItemIcon = Colors.green[900];
  Color NormalColorIcon = Colors.teal;
  Future<PickedFile> pickedFile = Future.value(null);

  Future opencamera(context, state) async {
    
    if (
    state is UpdateCommentloadImage  &&
        state is UpdateCommentloadImagefromcamera &&
        state is UpdateCommentWritingwithPhotoCamera &&
        state is UpdateCommentWritingwithPhoto
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
            'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is UpdateInitialState)
        UpdateCubit.get(context).emit(UpdateCommentloadImagefromcamera());
      else
        UpdateCubit.get(context).emit(UpdateCommentWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }
  Future opengallery(context, state) async {
    
    if (
    state is UpdateCommentloadImage  &&
        state is UpdateCommentloadImagefromcamera &&
        state is UpdateCommentWritingwithPhotoCamera &&
        state is UpdateCommentWritingwithPhoto
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
            'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is UpdateInitialState)
        UpdateCubit.get(context).emit(UpdateCommentloadImagefromcamera());
      else
        UpdateCubit.get(context).emit(UpdateCommentWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }
  bool isComment = false;
  void Cancel(context, state) {
    
    if (state is UpdateInitialState) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(text: 'You didn\'t Selected any item!'),
      );
    } else if (state is UpdateCommentloadImage || state is UpdateCommentWritingwithPhoto) {
      if (state is UpdateCommentloadImage)
        UpdateCubit.get(context).emit(UpdateInitialState());
      else
        UpdateCubit.get(context).emit(UpdateCommentWriting());
    } else if (state is UpdateCommentloadImagefromcamera ||
        state is UpdateCommentWritingwithPhotoCamera) {
      image = null;
      if (state is UpdateCommentloadImagefromcamera)
        UpdateCubit.get(context).emit(UpdateInitialState());
      else
        UpdateCubit.get(context).emit(UpdateCommentWriting());
    }
  }


  void changeWriteComment()
  {
    isComment = true;
    emit(ChangeWriteComment());
  }
  void changeNoComment()
  {
    isComment = false;
    emit(UpdateInitialState());
  }


  Post({@required text, @required context,@required int id,@required int post_id}) async {
    String url = MainURL+"comment/update/"+"${id}";
    var postUri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(TokenHeaders);

    if (text.isNotEmpty) {
      request.fields['text'] = text.toString();
    }
    if(xorginalphoto) {
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }
      else request.fields['image'] = "null";
    }
    await request.send().then((response) async {
      final respStr = await response.stream.bytesToString();
      print(respStr.toString());
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        navigateTo(context, CommentScreen(post_id: post_id));
      } else {

      }
    }).catchError(
          (error) {
        emit(UpdateErrorState(error.toString()));
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

