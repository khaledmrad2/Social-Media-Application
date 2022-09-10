import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pied_piper/modules/Post/addpost/addpost_cubit.dart';
import 'package:pied_piper/modules/Post/addpost/states.dart';
import 'package:pied_piper/modules/users/personal_information/personalinformation_screen.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import 'package:video_player/video_player.dart';
import '../../../shared/components/constants.dart';
import 'Record_Voice/Mycrophone_screen.dart';
import 'Record_Voice/my_microphone.dart';

class AddpostScreen extends StatelessWidget {
  var text = TextEditingController();
  SoundRecorder mic;
  bool isjpb = false;
  int ForWhat;
  AddpostScreen({
    @required this.ForWhat,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddpostCubit(),
      child: BlocConsumer<AddpostCubit, AddpostStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Pied Piper',
              style: TextStyle(
                color: Colors.green,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              AddpostCubit.get(context).check(state, text)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50, 50),
                        primary: Colors.white,
                        elevation: 0,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        showLoaderDialog(context);
                        AddpostCubit.get(context).Post(
                          text: text.text.toString(),
                          context: context,
                          id: ForWhat,
                        );
                      },
                      child: Icon(
                        Icons.done_outline,
                        color: Colors.green,
                        size: 40,
                      ),
                    )
                  : Container(),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            NetworkImage(CacheHelper.GetData(key: 'picture')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: CacheHelper.GetData(key: 'name'),
                              fcolor: Colors.black,
                              fsize: 25,
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 22,
                      overflow: TextOverflow.ellipsis,
                    ),
                    controller: text,
                    onChanged: (String value) =>
                        AddpostCubit.get(context).Switch(value, context, state),
                    maxLines: 6,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      alignLabelWithHint: true,
                      hintText:
                          'What\'s in your mind ${CacheHelper.GetData(key: 'name')}?',
                      hintStyle: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: AddpostCubit.get(context).MyWidget(state),
                      ),
                      (!AddpostCubit.get(context).isjob)
                          ? ElevatedButton.icon(
                              icon: Icon(Icons.work_history_outlined),
                              label: MyText(text: 'Post is A Job', fsize: 25),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.teal),
                              onPressed: () {
                                if (CacheHelper.GetDataint(
                                            key: 'available_to_hire') ==
                                        0 ||
                                    CacheHelper.GetData(key: 'job_title') ==
                                        null) {
                                  navigateTo(
                                    context,
                                    PersonalInformationScreen(
                                      isHire: CacheHelper.GetDataint(
                                          key: 'available_to_hire'),
                                      location:
                                          CacheHelper.GetData(key: 'location'),
                                      JobTitle:
                                          CacheHelper.GetData(key: 'job_title'),
                                      id: CacheHelper.GetDataint(key: 'id'),
                                      fromWhat: 2,
                                      isHome: 1,
                                    ),
                                  );
                                  AddpostCubit.get(context).isjob = true;
                                  AddpostCubit.get(context).emit(state);
                                } else {
                                  AddpostCubit.get(context).isjob = true;
                                  AddpostCubit.get(context).emit(state);
                                }
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Post_button(
                            color: state is AddpostloadImagefromcamera ||
                                    state is AddpostWritingwithPhotoCamera
                                ? AddpostCubit.get(context).SelectedItemIcon
                                : AddpostCubit.get(context).NormalColorIcon,
                            icon: Icons.camera_alt,
                            shape1: state is AddpostloadImagefromcamera ||
                                state is AddpostWritingwithPhotoCamera,
                            function: () => AddpostCubit.get(context)
                                .opencamera(context, state),
                          ),
                          Post_button(
                            icon: Icons.image,
                            shape1: state is AddpostloadImage ||
                                state is AddpostWritingwithPhoto,
                            color: state is AddpostloadImage ||
                                    state is AddpostWritingwithPhoto
                                ? AddpostCubit.get(context).SelectedItemIcon
                                : AddpostCubit.get(context).NormalColorIcon,
                            function: () => AddpostCubit.get(context)
                                .Picimage(context, state),
                          ),
                          Post_button(
                            icon: Icons.video_call,
                            shape1: state is AddpostloadVideo ||
                                state is AddpostWritingwithVideo,
                            color: state is AddpostloadVideo ||
                                    state is AddpostWritingwithVideo
                                ? AddpostCubit.get(context).SelectedItemIcon
                                : AddpostCubit.get(context).NormalColorIcon,
                            function: () => AddpostCubit.get(context)
                                .getVideo(context, state),
                          ),
                          Post_button(
                              icon: Icons.keyboard_voice,
                              shape1: state is AddpostloadVoice ||
                                  state is AddpostWritingwithVoice,
                              color: state is AddpostloadVoice ||
                                      state is AddpostWritingwithVoice
                                  ? AddpostCubit.get(context).SelectedItemIcon
                                  : AddpostCubit.get(context).NormalColorIcon,
                              function: () =>
                                  AddpostCubit.get(context).getVoice(context)),
                          Post_button(
                            icon: Icons.cancel,
                            color: state is AddpostInitialState ||
                                    state is AddpostWriting ||
                                    state is AddpostLoadingState
                                ? Colors.teal
                                : Colors.redAccent,
                            function: () => AddpostCubit.get(context)
                                .Cancel(context, state),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
