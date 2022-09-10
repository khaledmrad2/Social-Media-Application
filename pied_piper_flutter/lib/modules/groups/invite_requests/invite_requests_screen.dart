
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import 'invite_requests_cubit.dart';
import 'invite_requests_states.dart';

class InviteRequestsScreen extends StatelessWidget {
  int group_id;

  InviteRequestsScreen({
    @required this.group_id,
  });

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      InviteRequestsCubit()
        ..getAllGroupRequests(group_id: group_id),
      child: BlocConsumer<InviteRequestsCubit, InviteRequestsStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            //GroupInviteCubit.get(context).buttomin();

            var list = InviteRequestsCubit
                .get(context)
                .AllGroupInviteRequests;
            InviteRequestsCubit.get(context).ert(list.length);
            // GroupInviteCubit.get(context).ert();
            return Scaffold(
              backgroundColor: Colors.green[200],
              appBar: AppBar(backgroundColor: Colors.green,),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) =>
                    ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            BuildInviteList(
                              index: index,
                              picture: list[index]["user_picture"],
                              context: context,
                              id: list[index]["user_id"],
                              name: list[index]["user_name"],
                              group_id: group_id,
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


  Widget BuildInviteList({
    @required String name,
    @required int id,
    @required String picture,
    @required BuildContext context,
    @required group_id,
    @required int index,
  }) =>
      Container(
        height: 100,
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
                      radius: 50,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            '${name}',
                            style: TextStyle(
                              fontSize: 30,
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
            InviteRequestsCubit
                .get(context)
                .buttomlist[index] == false ?
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green[500],
                    ),
                    child: TextButton(onPressed: () {
                      InviteRequestsCubit.get(context).changeinvite();
                      //  GroupInviteCubit.get(context).SendInvite(user_id: id, group_id: 2, context: context);
                      InviteRequestsCubit.get(context).changeplease(
                        user_id: id,
                        context: context,
                        index: index,
                        group_id: group_id,
                      );
                    },
                        child:
                        Text('Accept',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            backgroundColor: Colors.green[500],
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ) : Container(),
          ],
        ),
      );
}