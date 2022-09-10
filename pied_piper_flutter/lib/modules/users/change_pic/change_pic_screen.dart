import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/shared/components/components.dart';
import '../../../shared/components/constants.dart';
import 'cahnge_pic_states.dart';
import 'change_pic_cubit.dart';

class ChangePicScreen extends StatelessWidget {
  int ForWhat;
  ChangePicScreen({
    this.ForWhat,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ChangePicCubit(),
        child: BlocConsumer<ChangePicCubit, ChangePicStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.green[500],
                    title: MyText(
                      text: "Select Photo",
                      fcolor: Colors.white,
                      fsize: 20,
                    ),
                    centerTitle: true,
                    actions: [
                      ChangePicCubit.get(context).image != null
                          ? IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                showLoaderDialog(context);
                                ChangePicCubit.get(context)
                                    .Post(context: context, forWhat: ForWhat);
                              })
                          : Container(),
                    ],
                  ),
                  body: Center(
                    child: Column(children: [
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                ChangePicCubit.get(context)
                                    .opencamera(context, state);
                              }),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              icon: Icon(Icons.photo),
                              onPressed: () {
                                ChangePicCubit.get(context)
                                    .opengallery(context, state);
                              }),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      ChangePicCubit.get(context)
                                          .Cancel(context, state);
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ChangePicCubit.get(context).image != null
                          ? Image.file(ChangePicCubit.get(context).image)
                          : Container(),
                    ]),
                  ));
            }));
  }
}
