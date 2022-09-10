import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import 'members_cubit.dart';
import 'members_states.dart';

class MembersScreen extends StatelessWidget {
  int group_id;
  BuildContext context;
  MembersScreen({
    @required this.group_id,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          MembersCubit()..getMembers(group_id: group_id),
      child: BlocConsumer<MembersCubit, MembersStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = MembersCubit.get(context).Members;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[500],
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => FriendsComponents(
                        context: context,
                        id: list[index]['id'],
                        Picture: list[index]['picture'],
                        Name: list[index]['name']),
                    separatorBuilder: (context, index) => MyDividor(),
                    itemCount: list.length),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          }),
    );
  }
}
