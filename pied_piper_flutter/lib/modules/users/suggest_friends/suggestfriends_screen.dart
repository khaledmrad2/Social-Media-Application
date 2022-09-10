import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/users/suggest_friends/suggest_cubit.dart';
import 'package:pied_piper/modules/users/suggest_friends/suggest_states.dart';

import '../../../shared/components/components.dart';

class SugestedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          SuggestFriendsCubit()..getSuggestFriends(),
      child: BlocConsumer<SuggestFriendsCubit, SuggestFriendsStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = SuggestFriendsCubit.get(context).SuggestFriendsResult;
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
