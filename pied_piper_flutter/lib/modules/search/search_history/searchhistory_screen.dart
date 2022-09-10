import 'dart:convert';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/search/search_history/searchhistory_cubit.dart';
import 'package:pied_piper/modules/search/search_history/searchhistory_state.dart';

import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../users/profile/profile_screen.dart';

class SearchHistoryScreen extends StatelessWidget {
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
        create: (BuildContext context) =>
            SearchHistoryCubit()..getSearchHistory(),
        child: BlocConsumer<SearchHistoryCubit, SearchHistoryStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
              var list = SearchHistoryCubit.get(context).SearchHistoryResult;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green[500],
                ),
                body: ConditionalBuilder(
                  condition: true,
                  builder: (context) => ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => SearchHistoryComponents(
                            PictureSearch: list[index]['picture'],
                            name: list[index]['name'],
                            id: list[index]['id'],
                            context: context,
                          ),
                      separatorBuilder: (context, index) => MyDividor(),
                      itemCount: list.length),
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator()),
                ),
              );
            }));
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
          print("url is ${url}");
          await http
              .get(
            Uri.parse(url),
            headers: TokenHeaders,
          )
              .then(
            (response) {
              Map Mapvalue = json.decode(response.body);
              //profilemodel.fromJson(Mapvalue);
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
}
