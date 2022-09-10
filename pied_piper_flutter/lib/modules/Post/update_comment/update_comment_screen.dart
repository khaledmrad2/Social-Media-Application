import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/Post/update_comment/update_comment_cubit.dart';
import 'package:pied_piper/modules/Post/update_comment/update_comment_states.dart';

import '../../../shared/components/components.dart';

class UpdateScreen extends StatelessWidget{
  var TextController =TextEditingController();
  String Picture ;
  String text;
  int id;
  int post_id;
  UpdateScreen({
    @required this.text,
    @required this.id,
    @required this.Picture,
    @required this.post_id,
  });
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (BuildContext context) =>UpdateCubit(),
        child: BlocConsumer<UpdateCubit,UpdateStates>(
            listener: (context,state){ },
            builder: (BuildContext context, state) {
              TextController..text =text;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green[500],
                ),

                body: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Your comment text is "${text}"',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  ),
                                  personalformfield(
                                    controller: TextController,
                                    type: TextInputType.text,
                                    labeltext: 'Your Comment',
                                    onchange: (value){

                                    },

                                    validate: (value) {},
                                    prefix: Icons.comment,
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    color: Colors.grey[300],
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        IconButton(icon: Icon(Icons.photo), onPressed: (){
                                          UpdateCubit.get(context).opengallery(context, state);
                                          UpdateCubit.get(context).changedeleteorginal();
                                        }),
                                        IconButton(icon: Icon(Icons.camera), onPressed: (){
                                          UpdateCubit.get(context).opencamera(context, state);
                                          UpdateCubit.get(context).changedeleteorginal();
                                        }),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(icon: Icon(Icons.delete), onPressed: (){

                                                UpdateCubit.get(context).Cancel(context, state);
                                                print(UpdateCubit.get(context).image);
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
                                  (Picture !=null||Picture != "")&&UpdateCubit.get(context).xorginalphoto==false?
                                  Row(
                                    children: [
                                      Container(
                                        height: 240,
                                        width: 200,
                                        child: Image(
                                          image: NetworkImage("${Picture}"),
                                        ),
                                      ),
                                      IconButton(icon: Icon(Icons.delete), onPressed: (){
                                        UpdateCubit.get(context).changedeleteorginal();
                                      })
                                    ],
                                  ):Container(),
                                  UpdateCubit.get(context).image == null?Container():Image.file(UpdateCubit.get(context).image),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ConditionalBuilder(condition: state is !UpdateLoadingState, builder:(context)=>
                                      defaultbutton(
                                          width: 180,
                                          radius: 180,
                                          function: ()
                                          {
                                            if(TextController.text==text&&UpdateCubit.get(context).image==null&&!UpdateCubit.get(context).xorginalphoto)
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(MySnakbar(text: 'Nothing has changed in the comment'));
                                            }
                                            else {
                                              UpdateCubit.get(context).Post(text: TextController.text, context: context, id: id, post_id: post_id);

                                            }
                                          },
                                          text:'Change'
                                      ),
                                  )
                                ]
                            )
                        )
                    )
                ),
              );
            }
        )
    );
  }

}