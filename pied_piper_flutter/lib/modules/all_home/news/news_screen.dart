import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/models/story_model.dart';
import 'package:pied_piper/modules/all_home/news/getpost_cubit.dart';
import 'package:pied_piper/modules/users/change_pic/change_pic_screen.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import '../../../layout/piedpiper_app/background.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../Post/getpost/states.dart';
import '../../users/story/storyview_screen.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GetpostCubit()..Get(),
      child: BlocConsumer<GetpostCubit, GetpostStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = posts;
            var storylist = stories;
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
            return Stack(children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Container(
                    color: Colors.grey[300],
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "${CacheHelper.GetData(key: 'picture')}"),
                                      radius: 35,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.green,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                  alignment: Alignment.bottomRight,
                                ),
                                onTap: () {
                                  navigateTo(
                                      context,
                                      ChangePicScreen(
                                        ForWhat: 3,
                                      ));
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  //    physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Storywidget(
                                      story: storylist[index],
                                      context: context),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 15,
                                  ),
                                  itemCount: storylist.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: posts.length,
                            primary: false,
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (BuildContext context, int index) {
                              return postwidget[index];
                            }),
                      ],
                    ),
                  ),
                ),
              )
            ]);
          }),
    );
  }

  Widget Storywidget({@required storymodel story, BuildContext context}) {
    return GestureDetector(
      child: CircleAvatar(
        backgroundImage: NetworkImage(story.user_pic),
        radius: 35,
      ),
      onTap: () {
        navigateTo(context, storyscreen());
      },
    );
  }
}
