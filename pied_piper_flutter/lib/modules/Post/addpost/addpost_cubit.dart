import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/Post/addpost/states.dart';
import 'package:pied_piper/modules/Post/addpost/Video_Player/videoplayfile.dart';
import 'package:pied_piper/modules/all_home/home/home_screen.dart';
import 'package:pied_piper/modules/groups/groupmain/group_screen.dart';
import '../../../models/group_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import 'Record_Voice/Mycrophone_screen.dart';
import 'Record_Voice/my_microphone.dart';

class AddpostCubit extends Cubit<AddpostStates> {
  AddpostCubit() : super(AddpostInitialState());
  static AddpostCubit get(context) => BlocProvider.of(context);
  File image;
  final picker = ImagePicker();
  List<File> imageFileList = [];
  File video;
  bool isjob = false;
  Color SelectedItemIcon = Colors.green[900];
  Color NormalColorIcon = Colors.teal;
  Future<PickedFile> pickedFile = Future.value(null);

  Future opencamera(context, state) async {
    if (state is AddpostloadVideo ||
        state is AddpostloadImage ||
        state is AddpostloadImagefromcamera ||
        state is AddpostloadVoice ||
        state is AddpostWritingwithVoice ||
        state is AddpostWritingwithPhotoCamera ||
        state is AddpostWritingwithPhoto ||
        state is AddpostWritingwithVideo) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final image1 = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image1 == null) return null;
      image = File(image1.path);
      if (state is AddpostInitialState)
        AddpostCubit.get(context).emit(AddpostloadImagefromcamera());
      else
        AddpostCubit.get(context).emit(AddpostWritingwithPhotoCamera());
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnakbar(text: 'Image have taken Successfully!'));
      return image;
    }
  }

  Future Picimage(context, state) async {
    if (state is AddpostloadVideo ||
        state is AddpostloadImage ||
        state is AddpostloadImagefromcamera ||
        state is AddpostloadVoice ||
        state is AddpostWritingwithVoice ||
        state is AddpostWritingwithPhotoCamera ||
        state is AddpostWritingwithPhoto ||
        state is AddpostWritingwithVideo) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final List<XFile> selectedImages = await picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        for (var i = 0; i < selectedImages.length; i++)
          imageFileList.add(File(selectedImages[i].path));
        if (state is AddpostInitialState)
          AddpostCubit.get(context).emit(AddpostloadImage());
        else
          AddpostCubit.get(context).emit(AddpostWritingwithPhoto());
        ScaffoldMessenger.of(context).showSnackBar(
          MySnakbar(text: 'Images Picked Successfully!'),
        );
      }
    }
  }

  Future<String> getVideo(context, state) async {
    if (state is AddpostloadVideo ||
        state is AddpostloadImage ||
        state is AddpostloadImagefromcamera ||
        state is AddpostloadVoice ||
        state is AddpostWritingwithVoice ||
        state is AddpostWritingwithPhotoCamera ||
        state is AddpostWritingwithPhoto ||
        state is AddpostWritingwithVideo) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    } else {
      final video1 = await picker.pickVideo(source: ImageSource.gallery);
      if (video1 != null) {
        video = File(video1.path);
        if (state is AddpostInitialState)
          AddpostCubit.get(context).emit(AddpostloadVideo());
        else
          AddpostCubit.get(context).emit(AddpostWritingwithVideo());
        ScaffoldMessenger.of(context)
            .showSnackBar(MySnakbar(text: 'Video Picked Successfully!'));
      }
    }
  }

  void getVoice(context) {
    if (state is AddpostloadVideo ||
        state is AddpostloadImage ||
        state is AddpostloadImagefromcamera ||
        state is AddpostWritingwithPhotoCamera ||
        state is AddpostWritingwithPhoto ||
        state is AddpostWritingwithVideo)
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(
            text:
                'You Selected anther item ,please press cancel then try again'),
      );
    else {
      navigateTo(
          context,
          micro_screen(
            Mycontext: context,
            state: state,
            runonly: false,
          ));
    }
  }

  File Run() {
    File f = File(SoundRecorder.path);
    return f;
  }

  void Cancel(context, state) {
    if (state is AddpostInitialState) {
      ScaffoldMessenger.of(context).showSnackBar(
        MySnakbar(text: 'You didn\'t Selected any item!'),
      );
    } else if (state is AddpostloadImage || state is AddpostWritingwithPhoto) {
      imageFileList.clear();
      if (state is AddpostloadImage)
        AddpostCubit.get(context).emit(AddpostInitialState());
      else
        AddpostCubit.get(context).emit(AddpostWriting());
    } else if (state is AddpostloadVideo || state is AddpostWritingwithVideo) {
      video = null;
      if (state is AddpostloadVideo)
        AddpostCubit.get(context).emit(AddpostInitialState());
      else
        AddpostCubit.get(context).emit(AddpostWriting());
    } else if (state is AddpostloadImagefromcamera ||
        state is AddpostWritingwithPhotoCamera) {
      image = null;
      if (state is AddpostloadImagefromcamera)
        AddpostCubit.get(context).emit(AddpostInitialState());
      else
        AddpostCubit.get(context).emit(AddpostWriting());
    } else if (state is AddpostloadVoice || state is AddpostWritingwithVoice) {
      SoundRecorder.path = "";
      if (state is AddpostloadVoice)
        AddpostCubit.get(context).emit(AddpostInitialState());
      else
        AddpostCubit.get(context).emit(AddpostWriting());
    }
  }

  bool check(state, text) {
    if (state is AddpostInitialState && text.text.isEmpty)
      return false;
    else
      return true;
  }

  Widget MyWidget(state) {
    if (state is AddpostloadImage || state is AddpostWritingwithPhoto)
      return photos();
    else if (state is AddpostloadVideo || state is AddpostWritingwithVideo)
      return VideoPlayerFileCustum(
        videopath: video.path,
        isnetworkvideo: false,
      );
    else if (state is AddpostloadImagefromcamera ||
        state is AddpostWritingwithPhotoCamera)
      return Center(
        child: Image.file(
          image,
          fit: BoxFit.contain,
        ),
      );
    return null;
  }

  Widget photos() => Padding(
        padding: const EdgeInsets.all(15.0),
        child: imageFileList.length > 1
            ? GridView.builder(
                itemCount: imageFileList.length,
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(imageFileList[index]);
                })
            : Center(
                child: Image.file(imageFileList[0]),
              ),
      );
  void Switch(String value, context, state) {
    if (value.toString().isNotEmpty) {
      if (state is AddpostloadVoice)
        AddpostCubit.get(context).emit(AddpostWritingwithVoice());
      else if (state is AddpostloadVideo)
        AddpostCubit.get(context).emit(AddpostWritingwithVideo());
      else if (state is AddpostloadImage)
        AddpostCubit.get(context).emit(AddpostWritingwithPhoto());
      else if (state is AddpostloadImagefromcamera)
        AddpostCubit.get(context).emit(AddpostWritingwithPhotoCamera());
      else if (state is AddpostInitialState)
        AddpostCubit.get(context).emit(AddpostWriting());
    } else {
      if (state is AddpostWritingwithVoice)
        AddpostCubit.get(context).emit(AddpostloadVoice());
      else if (state is AddpostWritingwithVideo)
        AddpostCubit.get(context).emit(AddpostloadVideo());
      else if (state is AddpostWritingwithPhoto)
        AddpostCubit.get(context).emit(AddpostloadImage());
      else if (state is AddpostWritingwithPhotoCamera)
        AddpostCubit.get(context).emit(AddpostloadImagefromcamera());
      else
        AddpostCubit.get(context).emit(AddpostInitialState());
    }
  }

  Post({@required text, @required context, int id}) async {
    File Voicefile = Run();
    String url;
    if (!isjob)
      url = MainURL + CreateNormalPostURL;
    else
      url = MainURL + CreateJobPostURL;
    var postUri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(TokenHeaders);
    if (text.isNotEmpty) {
      request.fields['text'] = text.toString();
    }
    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('images[]', image.path));
    } else if (imageFileList.length != 0 && imageFileList != null) {
      for (var i = 0; i < imageFileList.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'images[]', imageFileList[i].path));
      }
    } else if (video != null) {
      request.files.add(await http.MultipartFile.fromPath('video', video.path));
    } else if (Voicefile != null && Voicefile.path.isNotEmpty) {
      request.files.add(
          await http.MultipartFile.fromPath('voice_record', Voicefile.path));
    }
    if (id != -1) {
      request.fields['group_id'] = id.toString();
    }
    await request.send().then((response) async {
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => MyDialogSingleButton(
                context: context,
                ok: true,
                pop: true,
                nextscreen: HomeScreen(),
                sendedmessage: "Post Added Successfully!",
                function: () async {
                  if (id > -1) {
                    groupmodel group;
                    String url = MainURL + GetGroupURL + "${id}";
                    await http
                        .get(Uri.parse(url), headers: TokenHeaders)
                        .then((response) {
                      Map Mapvalue = json.decode(response.body);
                      group = groupmodel.fromJson(Mapvalue);
                      navigateTo(context, GroupScreen(group: group, id: id));
                    });
                  } else {
                    navigateTo(context, HomeScreen());
                  }
                }));
      } else {
        Navigator.pop(context);
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
        emit(AddpostErrorState(error.toString()));
        print("AddpostError: ${error.toString()}");
      },
    );
  }
}
