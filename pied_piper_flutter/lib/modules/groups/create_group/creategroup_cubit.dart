import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../all_home/home/home_screen.dart';
import 'creategroup_states.dart';

class CreateGroupCubit extends Cubit<CreateGroupStates> {
  CreateGroupCubit() : super(CreateGroupInitialState());

  static CreateGroupCubit get(context) => BlocProvider.of(context);
  int isPrivate = 0;
  void ChangeToprivate() {
    isPrivate = 1;
    emit(ChangeTogglePrivate());
  }

  void ChangeFromprivate() {
    isPrivate = 0;
    emit(ChangeTogglePrivate());
  }


  File image;
  Future opencamera(context, state) async {
    
    if (state is AddCoverloadImage &&
        state is AddCoverloadImagefromcamera &&
        state is AddCoverWritingwithPhotoCamera) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is CreateGroupInitialState)
        CreateGroupCubit.get(context).emit(AddCoverloadImagefromcamera());
      else
        CreateGroupCubit.get(context).emit(AddCoverWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }

  Future opengallery(context, state) async {
    
    if (state is AddCoverloadImage &&
        state is AddCoverloadImagefromcamera &&
        state is AddCoverWritingwithPhotoCamera) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is CreateGroupInitialState)
        CreateGroupCubit.get(context).emit(AddCoverloadImagefromcamera());
      else
        CreateGroupCubit.get(context).emit(AddCoverWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }

  bool isComment = false;
  void Cancel(context, state) {
    
    if (state is CreateGroupInitialState) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(text: 'You didn\'t Selected any item!'),
      );
    } else if (state is AddCoverloadImage ||
        state is AddCoverWritingwithPhotoCamera) {
      if (state is AddCoverloadImage)
        CreateGroupCubit.get(context).emit(CreateGroupInitialState());
      else
        CreateGroupCubit.get(context).emit(CreateGroupWriting());
    } else if (state is AddCoverloadImagefromcamera ||
        state is AddCoverWritingwithPhotoCamera) {
      image = null;
      if (state is AddCoverloadImagefromcamera)
        CreateGroupCubit.get(context).emit(CreateGroupInitialState());
      else
        CreateGroupCubit.get(context).emit(CreateGroupWriting());
    }
  }

  Post({
    @required name,
    @required context,
  }) async {
    String url = MainURL + "group/create";
    var postUri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(TokenHeaders);

    if (name.isNotEmpty) {
      request.fields['title'] = name.toString();
    }
    if (isPrivate == 1) {
      request.fields['security'] = "private";
    } else {
      request.fields['security'] = "public";
    }
    if (image != null) {
      print("Camera Try ");
      request.files.add(await http.MultipartFile.fromPath('cover', image.path));
    }
    await request.send().then((response) async {
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        print(response.statusCode);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) => MyDialogSingleButton(
              context: context, ok: false, sendedmessage: ErrorMessage),
        );
      }
    }).catchError(
      (error) {
        emit(CreateGroupErrorState(error.toString()));
        print("AddpostError: ${error.toString()}");
      },
    );
  }
}
