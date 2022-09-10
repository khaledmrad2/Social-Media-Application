import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import 'groupinvite_cubit.dart';
import 'groupinvite_states.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

class InviteGroupScreen extends StatelessWidget {
  int group_id;int admin_id;
  InviteGroupScreen({
    @required this.admin_id,
    @required this.group_id,
  });
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          GroupInviteCubit()..getAllGroupInvite(group_id: group_id),
      child: BlocConsumer<GroupInviteCubit, GroupInviteStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {

            var list = GroupInviteCubit.get(context).AllGroupInviteResult;
            GroupInviteCubit.get(context).ert(list.length);
            return Scaffold(
              backgroundColor: Colors.green[200],
              appBar: AppBar(
                backgroundColor: Colors.green,
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => BuildInviteList(
                          index: index,
                          picture: list[index]["user_picture"],
                          context: context,
                          id: list[index]["user_id"],
                          name: list[index]["user_name"],
                          group_id: group_id, admin_id: admin_id,
                        ),
                    separatorBuilder: (context, index) => MyDividor(),
                    itemCount: list.length),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          }),
    );
  }

  Widget BuildInviteList({
    @required String name,
    @required int id,
    @required String picture,
    @required BuildContext context,
    @required group_id,
    @required int index,
    @required int admin_id,
  }) =>
      Container(

        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${picture}'),
                      radius: 35,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            '${name}',
                            style: TextStyle(
                              fontSize: 20,
                              backgroundColor: Colors.white,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: 20,
            ),
            GroupInviteCubit.get(context).buttomlist[index] == false
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.green[500],
                          ),
                          child: TextButton(
                              onPressed: () {
                                GroupInviteCubit.get(context).changeinvite();
                                GroupInviteCubit.get(context).SendInvite(
                                    user_id: admin_id,
                                    group_id: group_id,
                                    context: context);
                                GroupInviteCubit.get(context).changeplease(
                                  user_id: id,
                                  context: context,
                                  index: index,
                                  group_id: group_id,
                                );
                              },
                              child: Text(
                                'Invite',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  backgroundColor: Colors.green[500],
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      );
}
