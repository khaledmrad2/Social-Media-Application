import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import 'mutualfriends_cubit.dart';
import 'mutualfriends_states.dart';

class MutualFriendsScreen extends StatelessWidget {
  int id;
  MutualFriendsScreen({
    this.id,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          MutualFriendsCubit()..getMutualFriends(id),
      child: BlocConsumer<MutualFriendsCubit, MutualFriendsStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = MutualFriendsCubit.get(context).MutualFriendsResult;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => FriendsComponents(
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
