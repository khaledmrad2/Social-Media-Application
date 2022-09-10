import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import 'addcomment_cubit.dart';
import 'addcomment_states.dart';

class AddCommentScreen extends StatelessWidget {
  int id;
  int numberscreen;
  int groupid;
  int profileid;
  AddCommentScreen(
      {@required this.id,
      @required this.numberscreen,
      this.profileid,
      this.groupid});
  var TextController = TextEditingController();
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AddCommentCubit(),
        child: BlocConsumer<AddCommentCubit, AddCommentStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
               return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green[500],
                  actions: [
                    AddCommentCubit.get(context).check()
                        ? IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.white,
                            onPressed: () {
                              AddCommentCubit.get(context).Post(
                                text: TextController.text,
                                context: context,
                                id: id,
                                groupid: groupid,
                                profileid: profileid,
                                numberscreen: numberscreen,
                              );
                            })
                        : Container(),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          personalformfield(
                            controller: TextController,
                            type: TextInputType.text,
                            labeltext: 'Your Comment',
                            onchange: (value) {
                              value.toString().length != 0
                                  ? AddCommentCubit.get(context)
                                      .changeWriteComment()
                                  : AddCommentCubit.get(context)
                                      .changeNoComment();
                            },
                            validate: (value) {},
                            prefix: Icons.comment,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Colors.grey[300],
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.camera),
                                    onPressed: () {
                                      AddCommentCubit.get(context)
                                          .opengallery(context, state);
                                    }),
                                IconButton(
                                    icon: Icon(Icons.photo),
                                    onPressed: () {
                                      AddCommentCubit.get(context)
                                          .opencamera(context, state);
                                    }),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            AddCommentCubit.get(context)
                                                .Cancel(context, state);

                                          }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 240,
                            width: double.infinity,
                            child: AddCommentCubit.get(context).image == null
                                ? Container()
                                : Image.file(
                                    AddCommentCubit.get(context).image),
                          ),

                          // image !=null?Image.file(image):Text("no picture"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
