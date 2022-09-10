import 'dart:convert';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/all_home/requests/request_cubit.dart';
import 'package:pied_piper/modules/all_home/requests/request_states.dart';

import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../users/profile/profile_screen.dart';

class RequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RequestCubit()..getRequests(),
      child: BlocConsumer<RequestCubit, RequestStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = RequestCubit.get(context).Requests;
            RequestCubit.get(context).ert(list.length);
            return ConditionalBuilder(
              condition: true,
              builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Requsetcomponents(
                        context: context,
                        id: list[index]['id'],
                        username: list[index]['name'],
                        userImage: list[index]['picture'],
                        index: index,
                      ),
                  separatorBuilder: (context, index) => MyDividor(),
                  itemCount: list.length),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            );
          }),
    );
  }

  Widget Requsetcomponents(
          {@required int id,
          @required BuildContext context,
          @required String userImage,
          @required String username,
          @required int index}) =>
      GestureDetector(
        child: Container(
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${userImage}'),
                radius: 35,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${username}',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RequestCubit.get(context).buttomlist[index]
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.green[500],
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    RequestCubit.get(context)
                                        .changetoAcceptplease(
                                      index: index,
                                      id: id,
                                      context: context,
                                    );
                                  },
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      backgroundColor: Colors.green[500],
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[500],
                              ),
                              height: 40,
                              width: 120,
                              child: TextButton(
                                  onPressed: () {
                                    RequestCubit.get(context)
                                        .changetoRefuseplease(
                                            index: index,
                                            id: id,
                                            context: context);
                                  },
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        backgroundColor: Colors.grey[500]),
                                  )),
                            ),
                          ],
                        )
                ],
              )
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
              print("Request Error is : ${error.toString()}");
            },
          );
        },
      );
}
