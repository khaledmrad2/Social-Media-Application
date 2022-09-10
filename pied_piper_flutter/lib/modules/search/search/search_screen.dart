import 'dart:convert';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/search/search/search_cubit.dart';
import 'package:pied_piper/modules/search/search/search_states.dart';

import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../users/profile/profile_screen.dart';
import '../search_history/searchhistory_screen.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  bool issearch = false;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit()..getSearchHistory(),
      child: BlocConsumer<SearchCubit, SearchStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            String BottomText = SearchCubit.get(context).ChangeText();
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green[500],
                  title: Container(
                    height: 40,
                    child: mydefaultformfield(
                        controller: searchController,
                        type: TextInputType.text,
                        labeltext: 'Search',
                        validate: (value) {},
                        suffix: Icons.search,
                        Onchanged: (value) {
                          value.toString().length != 0
                              ? SearchCubit.get(context)
                                  .getSearch(value, context)
                              : SearchCubit.get(context).getSearchHistory();
                          value.toString().length != 0
                              ? issearch = true
                              : issearch = false;
                        }),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                navigateTo(context, SearchHistoryScreen());
                              },
                              child: Text(
                                'All Search History ',
                                style: TextStyle(
                                    color: Colors.green[500],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      ConditionalBuilder(
                        condition: true,
                        builder: (context) => ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => !issearch
                                ? SearchHistoryComponents(
                                    name: SearchCubit.get(context)
                                        .SearchHistoryResult[index]['name'],
                                    PictureSearch: SearchCubit.get(context)
                                        .SearchHistoryResult[index]['picture'],
                                    id: SearchCubit.get(context)
                                        .SearchHistoryResult[index]['id'],
                                    context: context,
                                  )
                                : SearchModel(
                                    userpicture: SearchCubit.get(context)
                                        .SearchResult[index]['picture'],
                                    username: SearchCubit.get(context)
                                        .SearchResult[index]['name'],
                                    id: SearchCubit.get(context)
                                        .SearchResult[index]['id'],
                                    context: context,
                                    isFriend: SearchCubit.get(context)
                                        .SearchResult[index]['isFriend'],
                                    isMe: SearchCubit.get(context)
                                        .SearchResult[index]['isMe'],
                                    isRequest: SearchCubit.get(context)
                                        .SearchResult[index]['isSendToMe'],
                                    isSentRequest: SearchCubit.get(context)
                                        .SearchResult[index]['isSentToHim'],
                                  ),
                            separatorBuilder: (context, index) => MyDividor(),
                            itemCount: issearch
                                ? SearchCubit.get(context).SearchResult.length
                                : SearchCubit.get(context)
                                    .SearchHistoryResult
                                    .length),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  Widget SearchHistoryComponents({
    @required String name,
    @required String PictureSearch,
    @required int id,
    @required BuildContext context,
  }) =>
      GestureDetector(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.green[300],
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
              ]), // Make rounded corner of border

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage('${PictureSearch}'),
                radius: 35,
              ),
              SizedBox(
                width: 20,
              ),
              MyText(text: '${name}', fcolor: Colors.black, fsize: 25),
            ],
          ),
        ),
        onTap: () async {
          profilemodel profile;
          String url = MainURL + GetProfile + "${id}";
          await http.get(Uri.parse(url), headers: TokenHeaders).then(
            (response) {
              Map Mapvalue = json.decode(response.body);
              profile = profilemodel.fromJson(Mapvalue);
              if (Mapvalue["success"]) {
                navigateTo(
                    context,
                    ProfileScreen(
                      id: id,
                      profile: profile,
                    ));
              }
            },
          ).catchError(
            (error) {
              print("GetPost Error is : ${error.toString()}");
            },
          );
        },
      );

  Widget SearchModel({
    @required String username,
    @required String userpicture,
    @required int id,
    @required bool isMe,
    @required bool isFriend,
    @required bool isRequest,
    @required bool isSentRequest,
    @required BuildContext context,
  }) =>
      GestureDetector(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.grey, offset: Offset(1, 3))
                ]), // Make rounded corner of border

            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage('${userpicture}'),
                      radius: 35,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        MyText(
                            text: '${username}',
                            fsize: 25,
                            fcolor: Colors.black),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          onTap: () async {
            profilemodel profile;
            String url = MainURL + GetProfile + '${id}';
            print(url);
            await http.get(Uri.parse(url), headers: TokenHeaders).then(
              (response) {
                Map Mapvalue = json.decode(response.body);
                profile = profilemodel.fromJson(Mapvalue);
                print(Mapvalue);
                if (Mapvalue["success"]) {
                  navigateTo(
                      context,
                      ProfileScreen(
                        id: id,
                        profile: profile,
                      ));
                  //
                  SearchCubit.get(context)
                      .AddToHistory(context: context, id: id);
                }
              },
            ).catchError(
              (error) {
                print("GetPost Error is : ${error.toString()}");
              },
            );
          });
}
