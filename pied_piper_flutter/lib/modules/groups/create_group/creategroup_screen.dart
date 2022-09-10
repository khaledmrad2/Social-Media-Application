import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import 'creategroup_cubit.dart';
import 'creategroup_states.dart';

class CreateGroupScreen extends StatelessWidget {
  var nameController = TextEditingController();
  int isPrivate;
  BuildContext context;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => CreateGroupCubit(),
        child: BlocConsumer<CreateGroupCubit, CreateGroupStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green[500],
                  title: Center(
                    child: Text(
                      'Create Group',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          personalformfield(
                            controller: nameController,
                            type: TextInputType.text,
                            labeltext: "Group Name",
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'The Privacy Of The Group',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      CreateGroupCubit.get(context)
                                          .ChangeToprivate();
                                      isPrivate = CreateGroupCubit.get(context)
                                          .isPrivate;
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: isPrivate == 1
                                            ? Colors.green[500]
                                            : Colors.grey[400],
                                      ),
                                      child: Center(
                                          child: Text(
                                        'Private',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      CreateGroupCubit.get(context)
                                          .ChangeFromprivate();
                                      isPrivate = CreateGroupCubit.get(context)
                                          .isPrivate;
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: isPrivate == 1
                                            ? Colors.grey[400]
                                            : Colors.green[500],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Public',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'The Cover Of The Group',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
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
                                    icon: Icon(Icons.photo),
                                    onPressed: () {
                                      CreateGroupCubit.get(context)
                                          .opengallery(context, state);
                                    }),
                                IconButton(
                                    icon: Icon(Icons.camera),
                                    onPressed: () {
                                      CreateGroupCubit.get(context)
                                          .opencamera(context, state);
                                    }),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            CreateGroupCubit.get(context)
                                                .Cancel(context, state);
                                          }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 240,
                            width: double.infinity,
                            child: CreateGroupCubit.get(context).image == null
                                ? Container()
                                : Image.file(
                                    CreateGroupCubit.get(context).image),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! CreateGroupLoadingState,
                            builder: (context) => defaultbutton(
                              text: 'Create',
                              radius: 50.0,
                              width: 120,
                              background: Colors.green.shade500,
                              function: () {
                                if (formKey.currentState.validate()) {
                                  showLoaderDialog(context);

                                  CreateGroupCubit.get(context).Post(
                                      name: nameController.text,
                                      context: context);
                                  print(nameController.text);
                                }
                              },
                            ),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
