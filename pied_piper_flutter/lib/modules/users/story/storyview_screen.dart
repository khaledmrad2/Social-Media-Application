import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/users/story/state.dart';
import 'package:pied_piper/modules/users/story/story_cubit.dart';

import '../../../shared/components/constants.dart';

class storyscreen extends StatelessWidget {
  const storyscreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => StoryCubit(),
        child: BlocConsumer<StoryCubit, StoryStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) => Scaffold(
                  body: ConditionalBuilder(
                    condition: true,
                    builder: (context) => GestureDetector(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      stories[StoryCubit.get(context).i]
                                          .user_pic),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  stories[StoryCubit.get(context).i]
                                      .user_name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                stories[StoryCubit.get(context).i].is_visitor
                                    ? Container()
                                    : IconButton(
                                        onPressed: () {
                                          StoryCubit.get(context).delete(
                                              stories[StoryCubit.get(context)
                                                      .i]
                                                  .id,
                                              context);
                                        },
                                        icon: Icon(Icons.delete))
                              ],
                            ),
                            Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Image(
                                  image: NetworkImage(
                                      stories[StoryCubit.get(context).i]
                                          .image),
                                ),
                                StoryCubit.get(context).i > 0
                                    ? GestureDetector(
                                        child: Icon(
                                          Icons.chevron_left,
                                          size: 50,
                                        ),
                                        onTap: () {
                                          StoryCubit.get(context)
                                              .ToPrevious();
                                        })
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        StoryCubit.get(context).i < stories.length - 1
                            ? StoryCubit.get(context).ToNext()
                            : {};
                      },
                    ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                )));
  }
}
