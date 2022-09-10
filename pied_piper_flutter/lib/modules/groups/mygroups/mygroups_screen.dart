import 'dart:convert';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'as http;

import '../../../models/group_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../groupmain/group_screen.dart';
import 'mygroups_cubit.dart';
import 'mygroups_states.dart';

class MyGroupsScreen extends StatelessWidget {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      MyGroupsCubit()
        ..GetMyGroups(),
      child: BlocConsumer<MyGroupsCubit, MyGroupsStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = MyGroupsCubit
                .get(context)
                .MyGroupsResult;
            return Scaffold(
              backgroundColor: Colors.green[200],
              appBar: AppBar(backgroundColor: Colors.green,),
              body: ConditionalBuilder(condition: true,
                builder: (context) =>
                    ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            BuildMyGroups(
                              id: list[index]['id'],
                              context: context,
                              privacy: list[index]['privacy'],
                              name: list[index]['title'],
                            ),
                        separatorBuilder: (context, index) => MyDividor(),
                        itemCount: list.length),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          }
      ),
    );
  }

  Widget BuildMyGroups({
    @required int id,
    @required String name,
    @required String privacy,
    @required BuildContext context,
  })=>
      GestureDetector(
          child: Container(
            height: 120,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text(
                        '${name}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                      Text(
                        '${privacy}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                        ),
                      )
                    ]
                ),
              ],
            ),
          ),
          onTap: ()
          async{
            groupmodel group;
            String url = MainURL+GetGroupURL+"${id}";
            await http.get(Uri.parse(url), headers: TokenHeaders).then(
                  (response) {
                Map Mapvalue = json.decode(response.body);
                //profilemodel.fromJson(Mapvalue);
                group = groupmodel.fromJson(Mapvalue);
                //
                if(Mapvalue["success"]) {
                   navigateTo(context,
                    GroupScreen(id: id,group: group,));
                  
                }
              },
            ).catchError(
                  (error) {
                print("GetPost Error is : ${error.toString()}");
              },
            );
          }
      );
}