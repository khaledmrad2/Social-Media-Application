import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/Post/saved_post/savedposts_cubit.dart';
import 'package:pied_piper/modules/Post/saved_post/savedposts_states.dart';

import '../../../shared/components/components.dart';

class SavedPostsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SavedPostsCubit()..getSvaedPosts(),
      child: BlocConsumer<SavedPostsCubit, SvaedPostsStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = SavedPostsCubit.get(context).SavedPosts;
            List<Widget> postwidget = [];
            for (var v in list) {
              if (v.type == 'normal')
                postwidget.add(Normalpost(post: v, screennumber: 1));
              else if (v.type == 'profilePicture')
                postwidget.add(Picturepost(post: v, screennumber: 1));
              else if (v.type == 'job')
                postwidget.add(Jobpost(post: v, screennumber: 1));
              else
                postwidget.add(Coverpost(post: v, screennumber: 1));
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[700],
                title: MyText(text: 'Saved Posts', fsize: 25),
                centerTitle: true,
              ),
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
