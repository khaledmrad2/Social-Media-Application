import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/piedpiper_app/background.dart';
import '../../../shared/components/components.dart';
import '../home/home_cubit.dart';
import 'group_cubit.dart';
import 'group_states.dart';

class GroupHomescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GroupHomeCubit()..Get(),
      child: BlocConsumer<GroupHomeCubit, GroupHomeStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = GroupHomeCubit.get(context).GroupsPosts;
            List<Widget> postwidget = [];
            for (var v in list) {
              if (v.group_id != null)
                postwidget.add(Normalpost(post: v, screennumber: 1));
            }
            return Scaffold(
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Container(
                  color: Colors.grey[300],
                  child: ListView.builder(
                      shrinkWrap: true,
                      //itemExtent: 1000,
                      itemCount: postwidget.length,
                      primary: false,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext context, int index) {
                        return postwidget[index];
                      }),
                ),
              ),
            );
          }),
    );
  }
}
