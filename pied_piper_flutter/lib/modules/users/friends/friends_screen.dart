import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import 'friends_cubit.dart';
import 'friends_states.dart';

class FriendsScreen extends StatelessWidget{
  int id;
  List<dynamic> list;
  BuildContext context;
  FriendsScreen({
    @required this.id,
    @required this.list
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>FriendsCubit(),
      child: BlocConsumer<FriendsCubit,FriendsStates>(
          listener: (context,state){},
          builder: (BuildContext context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[500],
              ),
              body: ConditionalBuilder(
                condition:true,
                builder: (context) =>ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)=>FriendsComponents(
                      context: context,
                        id: list[index]['id'],
                        Picture: list[index]['picture'],
                        Name: list[index]['name']
                    ),
                    separatorBuilder: (context,index)=> MyDividor(),
                    itemCount: list.length),
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
            );
          }
      ),
    );
  }

}