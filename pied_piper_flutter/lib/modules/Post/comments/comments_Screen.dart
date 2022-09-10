import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/all_home/home/home_screen.dart';

import '../../../shared/components/components.dart';
import '../update_comment/update_comment_screen.dart';
import 'comments_cubit.dart';
import 'comments_states.dart';

class CommentScreen extends StatelessWidget {
  int post_id;
  BuildContext context;

  CommentScreen({
    @required this.post_id,
  });
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          CommentCubit()..getComments(post_id: post_id),
      child: BlocConsumer<CommentCubit, CommentStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = CommentCubit.get(context).Comments;
            CommentCubit.get(context).comments = list;
            CommentCubit.get(context).ert(list.length,list);
            CommentCubit.get(context).ert2(list.length);

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[500],
                title: MyText(text: 'Comments', fsize: 20),
                centerTitle: true,
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => BuildComment(
                          CommentText: list[index]["text"],
                          UserName: list[index]["user_name"],
                          UserPicture: list[index]["user_picture"],
                          picture: list[index]["image"],
                          context: context,
                          id: list[index]["comment_id"],
                          isMe: list[index]["is_visitor"],
                          index: index,
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

  Widget BuildComment({
    @required int id,
    @required String UserPicture,
    @required String UserName,
    @required String CommentText,
    @required String picture,
    @required BuildContext context,
    @required int index,
    @required bool isMe,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('${UserPicture}'),
                    radius: 35,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[350],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '${UserName}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 20),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              !isMe
                                                  ? IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        CommentCubit.get(
                                                                context)
                                                            .DeleteComment(
                                                                id: id,
                                                                context:
                                                                    context,
                                                                post_id:
                                                                    post_id);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        navigateTo(context, HomeScreen());
                                                        navigateTo(
                                                            context,
                                                            CommentScreen(
                                                                post_id:
                                                                    post_id)
                                                        );
                                                      })
                                                  : Container(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CommentText != null
                                      ? Container(
                                          width: 220,
                                          child: Text(
                                            '${CommentText}',
                                            style: TextStyle(
                                              fontSize: 17,

                                              color: Colors.black,

                                              // fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    picture != null
                        ? Row(
                            children: [
                              Container(
                                height: 180,
                                width: 240,
                                child: Image(
                                  image: NetworkImage('${picture}'),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: CommentCubit.get(context).buttomlist[index]
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage('assets/images/like.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    onTap: () {
                                      CommentCubit.get(context).chooseReation(
                                          index2: 1,
                                          index: index,
                                          id: id,
                                          context: context);
                                    },
                                  ),
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage('assets/images/love.png'),
                                                  backgroundColor: Colors.transparent,

                                    ),
                                    onTap: () {
                                      CommentCubit.get(context).chooseReation(
                                          index2: 2,
                                          index: index,
                                          id: id,
                                          context: context);
                                      CommentCubit.get(context)
                                          .changeFromRow(index);
                                    },
                                  ),
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage('assets/images/angry.png'),
                                                  backgroundColor: Colors.transparent,

                                    ),
                                    onTap: () {
                                      CommentCubit.get(context).chooseReation(
                                          index2: 3,
                                          index: index,
                                          id: id,
                                          context: context);
                                      CommentCubit.get(context)
                                          .changeFromRow(index);
                                    },
                                  ),
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage('assets/images/haha.png'),
                                                  backgroundColor: Colors.transparent,

                                    ),
                                    onTap: () {
                                      CommentCubit.get(context).chooseReation(
                                          index2: 4,
                                          index: index,
                                          id: id,
                                          context: context);
                                      CommentCubit.get(context)
                                          .changeFromRow(index);
                                    },
                                  ),
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage('assets/images/sad.png'),
                                                  backgroundColor: Colors.transparent,

                                    ),
                                    onTap: () {
                                      CommentCubit.get(context).chooseReation(
                                          index2: 5,
                                          index: index,
                                          id: id,
                                          context: context);
                                      CommentCubit.get(context)
                                          .changeFromRow(index);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: GestureDetector(
                              child: CommentCubit.get(context)
                                          .Reactionlist[index] ==
                                      ""
                                  ? TextButton(
                                      child: Text(
                                        'Like',
                                        style: TextStyle(
                                          color: Colors.green[500],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onLongPress: () {
                                        CommentCubit.get(context)
                                            .changeToRow(index);
                                      },
                                      onPressed: () {
                                        CommentCubit.get(context).chooseReation(
                                            index2: 1,
                                            index: index,
                                            id: id,
                                            context: context);
                                      },
                                    )
                                  : CommentCubit.get(context)
                                              .Reactionlist[index] ==
                                          "like"
                                      ? GestureDetector(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Like',
                                                style: TextStyle(
                                                  color: Colors.green[500],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/like.png'),
                                                            backgroundColor: Colors.transparent,

                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            CommentCubit.get(context)
                                                .chooseReation(
                                                    index2: 0,
                                                    index: index,
                                                    id: id,
                                                    context: context);
                                          },
                                          onLongPress: () {
                                            CommentCubit.get(context)
                                                .changeToRow(index);
                                          },
                                        )
                                      : CommentCubit.get(context)
                                                  .Reactionlist[index] ==
                                              "love"
                                          ? GestureDetector(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Love',
                                                    style: TextStyle(
                                                      color: Colors.green[500],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/love.png'),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                CommentCubit.get(context)
                                                    .chooseReation(
                                                        index2: 0,
                                                        index: index,
                                                        id: id,
                                                        context: context);
                                              },
                                              onLongPress: () {
                                                CommentCubit.get(context)
                                                    .changeToRow(index);
                                              },
                                            )
                                          : CommentCubit.get(context)
                                                      .Reactionlist[index] ==
                                                  "angry"
                                              ? GestureDetector(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'angry',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.green[500],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/angry.png'),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    CommentCubit.get(context)
                                                        .chooseReation(
                                                            index2: 0,
                                                            index: index,
                                                            id: id,
                                                            context: context);
                                                  },
                                                  onLongPress: () {
                                                    CommentCubit.get(context)
                                                        .changeToRow(index);
                                                  },
                                                )
                                              : CommentCubit.get(context)
                                                              .Reactionlist[
                                                          index] ==
                                                      "haha"
                                                  ? GestureDetector(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'haha',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green[500],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/images/haha.png'),
                                                            backgroundColor:
                                                                Colors.transparent,
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        CommentCubit.get(
                                                                context)
                                                            .chooseReation(
                                                                index2: 0,
                                                                index: index,
                                                                id: id,
                                                                context:
                                                                    context);
                                                      },
                                                      onLongPress: () {
                                                        CommentCubit.get(
                                                                context)
                                                            .changeToRow(index);
                                                      },
                                                    )
                                                  : CommentCubit.get(context)
                                                                  .Reactionlist[
                                                              index] ==
                                                          "sad"
                                                      ? GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'sad',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .green[
                                                                      500],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              CircleAvatar(
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'assets/images/sad.png'),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () {
                                                            CommentCubit.get(
                                                                    context)
                                                                .chooseReation(
                                                                    index2: 0,
                                                                    index:
                                                                        index,
                                                                    id: id,
                                                                    context:
                                                                        context);
                                                          },
                                                          onLongPress: () {
                                                            CommentCubit.get(
                                                                    context)
                                                                .changeToRow(
                                                                    index);
                                                          },
                                                        )
                                                      : Container(),
                            )),
                    ),
                  ],
                )
              ]),
        ),
      );
}
