import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../all_home/home/home_screen.dart';
import 'group_states.dart';

class GroupCubit extends Cubit<GroupStates> {
  GroupCubit() : super(GroupInitialState());

  static GroupCubit get(context) => BlocProvider.of(context);

  bool isMember = false;
  bool isRequested = false;
  bool isInvited = false;
  String Text2 = "";
  String BottomText = "";
  String ChangeText() {
    isMember
        ? Text2 = ""
        : isRequested
            ? Text2 = "Cancel Request"
            : isInvited
                ? Text2 = "Accept Request"
                : Text2 = "Join Request";
    return Text2;
    // emit(ChangeButtomState());
  }

  void JoinGroup({
    @required BuildContext context,
    @required int id,
    @required int user_id,
  }) {
    emit(GroupLoadingState());
    String url = MainURL + JoinRequestURL + "${user_id}" + "/" + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);

        if (Mapvalue["success"]) {
          emit(GroupSuccessState());
          // navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(GroupErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void CancelJoinRequest({
    @required BuildContext context,
    @required int id,
  }) {
    emit(GroupLoadingState());
    String url = MainURL + CancelRequestInviteURL + "${id}";
    http
        .delete(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(GroupSuccessState());
        }
      },
    ).catchError(
      (error) {
        emit(GroupErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  void AcceptJoinRequest({
    @required BuildContext context,
    @required int id,
  }) {
    emit(GroupLoadingState());
    String url = MainURL + AcceptInvitationURL + "${id}";
    http
        .post(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(GroupSuccessState());
          // navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(GroupErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  String Cover = "";
  String IsNotCover(String picture) {
    picture ==
            "https://res.cloudinary.com/dxntbhjao/image/upload/v1658823449/groups/covers/bh6skvmorc1xvhgwtptr.webp"
        ? Cover =
            "https://res.cloudinary.com/dxntbhjao/image/upload/v1658823449/groups/covers/bh6skvmorc1xvhgwtptr.webp"
        : Cover = picture;
    return Cover;
  }

  void DeleteCover({@required BuildContext context, @required int id}) {
    DeleteCoverCode(id: id, context: context);
    Cover =
        "https://res.cloudinary.com/dxntbhjao/image/upload/v1658823449/groups/covers/bh6skvmorc1xvhgwtptr.webp";
    emit(DeleteCoverState());
  }

  String privacy = "";
//bool isPrivate = false;
  IconData isPublic2 = Icons.edit_attributes_outlined;

  IconData SetPrivacy({String x}) {
    x == "private"
        ? isPublic2 = Icons.edit_attributes
        : isPublic2 = Icons.edit_attributes_outlined;
    return isPublic2;
  }

  void ChangePrivacyCode({
    @required BuildContext context,
    @required int id,
    @required String NewPrivacy,
  }) {
    emit(GroupLoadingState());
    String url = MainURL + ChangeGroupPrivacyURL + "${id}";
    http.post(Uri.parse(url),
        headers: TokenHeaders, body: {"privacy": "${NewPrivacy}"}).then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(GroupSuccessState());
          // navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(GroupErrorState(error));
        ("Change Privacy error: ${error.toString()}");
      },
    );
  }

  void ChangeFromPrivate(
      {@required String x, @required int id, @required BuildContext context}) {
    x == "public"
        ? {
            privacy = "private",
            isPublic2 = Icons.edit_attributes_outlined,
            ChangePrivacyCode(context: context, id: id, NewPrivacy: "private")
          }
        : {
            privacy = "public",
            isPublic2 = Icons.edit_attributes,
            ChangePrivacyCode(context: context, id: id, NewPrivacy: "public")
          };
    emit(ChangeToPrivateState());
  }

  void ChangeAcceptRequest({
    @required BuildContext context,
    @required int id,
  }) {
    AcceptJoinRequest(context: context, id: id);
    BottomText = "";
    isMember = true;
    isInvited = false;
    emit(ChangeButtomState());
  }

  void changeCancelRequest({
    @required BuildContext context,
    @required int id,
  }) {
    CancelJoinRequest(context: context, id: id);
    BottomText = "Join Request";
    isRequested = !isRequested;
    emit(ChangeButtomState());
  }

  void changeInviteRequest({
    @required BuildContext context,
    @required int id,
    @required int user_id,
  }) {
    JoinGroup(context: context, id: id, user_id: user_id);
    BottomText = "Cancel Request";
    isRequested = true;
    emit(ChangeButtomState());
  }

  Function DeleteCoverCode({
    @required int id,
    @required BuildContext context,
  }) {
    emit(GroupLoadingState());
    String url = MainURL + DeleteCoverGroupURL + "${id}";
    http
        .delete(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);

        if (Mapvalue["success"]) {
          emit(GroupSuccessState());
          //  navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(GroupErrorState(error));
        ("GroupDelete error: ${error.toString()}");
      },
    );
  }

  Function DeleteGroup({
    @required int id,
    @required BuildContext context,
  }) {
    emit(GroupLoadingState());
    String url = MainURL + DeleteGroupURL + "${id}";
    http
        .delete(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);

        if (Mapvalue["success"]) {
          emit(GroupSuccessState());
          navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(GroupErrorState(error));
        ("GroupDelete error: ${error.toString()}");
      },
    );
  }

  Function LeaveGroup({
    @required int id,
    @required BuildContext context,
  }) {
    emit(GroupLoadingState());
    String url = MainURL + LeaveGroupURL + "${id}";
    http
        .delete(
      Uri.parse(url),
      headers: TokenHeaders,
    )
        .then(
      (response) {
        Map Mapvalue = json.decode(response.body);
        if (Mapvalue["success"]) {
          emit(GroupSuccessState());
          navigateTo(context, HomeScreen());
        }
      },
    ).catchError(
      (error) {
        emit(GroupErrorState(error));
        ("Search error: ${error.toString()}");
      },
    );
  }

  File image;
  final picker = ImagePicker();

  Future opencamera(context, state) async {
    if (state is AddCoverloadImage &&
        state is AddCoverloadImagefromcamera &&
        state is AddCoverWritingwithCameraphoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image1 == null) return null;
      isUpdateCover = false;
      image = File(image1.path);
      if (state is GroupInitialState)
        GroupCubit.get(context).emit(AddCoverloadImagefromcamera());
      else
        GroupCubit.get(context).emit(AddCoverWritingwithCameraphoto());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      isUpdateCover = true;
      return image;
    }
  }

  Future opengallery(context, state) async {
    if (state is AddCoverloadImage &&
        state is AddCoverloadImagefromcamera &&
        state is AddCoverWritingwithCameraphoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image1 == null) return null;
      image = File(image1.path);

      if (state is GroupInitialState)
        GroupCubit.get(context).emit(AddCoverloadImagefromcamera());
      else
        GroupCubit.get(context).emit(AddCoverWritingwithCameraphoto());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      isUpdateCover = true;
      return image;
    }
  }

  bool isComment = false;
  void Cancel(context, state) {
    if (state is GroupInitialState) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(text: 'You didn\'t Selected any item!'),
      );
    } else if (state is AddCoverloadImage ||
        state is AddCoverWritingwithPhoto) {
      if (state is AddCoverloadImage)
        GroupCubit.get(context).emit(GroupInitialState());
      else
        GroupCubit.get(context).emit(GroupWriting());
    } else if (state is AddCoverloadImagefromcamera ||
        state is AddCoverWritingwithCameraphoto) {
      image = null;
      isUpdateCover = false;
      if (state is AddCoverloadImagefromcamera)
        GroupCubit.get(context).emit(GroupInitialState());
      else
        GroupCubit.get(context).emit(GroupWriting());
    }
  }

  Post({
    @required group_id,
    @required context,
  }) async {
    String url = MainURL + UpdateGroupCoverURL + "${group_id}";
    var postUri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(TokenHeaders);

    if (image != null) {
      print("Camera Try ");
      request.files.add(await http.MultipartFile.fromPath('cover', image.path));
    }
    await request.send().then((response) async {
      final respStr = await response.stream.bytesToString();
      print(respStr.toString());
      if (response.statusCode == 201) {
        // navigateTo(context, HomeScreen());
      } else {
        // navigateTo(context, HomeScreen());
      }
    }).catchError(
      (error) {
        emit(GroupErrorState(error.toString()));
        print("AddpostError: ${error.toString()}");
      },
    );
  }

  bool isUpdateCover = false;
  void UpdatedSuccess() {
    isUpdateCover = false;
    emit(UpdatedSuccefully());
  }
}
