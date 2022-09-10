
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import 'myinvitations_cubit.dart';
import 'myinvitations_states.dart';

class MyInvitationsScreen extends StatelessWidget{
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>MyInvitationsCubit()..getMyInvitations(),
      child: BlocConsumer<MyInvitationsCubit,MyInvitationsStates>(
          listener: (context,state){},
          builder: (BuildContext context, state) {

            var list = MyInvitationsCubit.get(context).MyInvitations;
            MyInvitationsCubit.get(context).ert(list.length);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[500],
              ),
              backgroundColor: Colors.green[200],
              body: ConditionalBuilder(condition:list.length>0,
                builder: (context) =>ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)=>BuildInvitation(
                        context: context,
                        id: list[index]["id"],
                        name: list[index]["title"],
                        index: index
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







Widget BuildInvitation({
  @required String name,
  @required BuildContext context,
  @required int index,
  @required int id})=> Padding(
  padding: const EdgeInsets.all(15.0),
  child: Center(
    child: Container(
      height: 120,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'You have an Invitations to "${name}" Group',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.green[500],
            ),
            child: TextButton(onPressed: (){
              MyInvitationsCubit.get(context).AcceptRequest(
                  context: context,id: id);
              MyInvitationsCubit.get(context).ChangeToAccept(index: index);
            },
                child:Text('Accept',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    backgroundColor: Colors.green[500],
                  ),
                )
            ),
          ),
        ],
      ),
    ),
  ),
);



