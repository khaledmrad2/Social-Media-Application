import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/Post/addpost/addpost_screen.dart';
import 'package:pied_piper/modules/users/profile/profile_screen.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../login/cubit/login_screen.dart';
import '../../search/search/search_screen.dart';
import '../news/getpost_cubit.dart';
import 'home_cubit.dart';
import 'home_states.dart';

class HomeScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                '      Pied Piper',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  color: Colors.green[700],
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context, SearchScreen());
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.green[700],
                    )),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage:
                        NetworkImage(CacheHelper.GetData(key: 'picture')),
                  ),
                  onTap: () async {
                    int x = CacheHelper.GetDataint(key: 'id');
                    profilemodel profile;
                    String url = MainURL + GetProfile + '${x}';
                    print(url);
                    await http.get(Uri.parse(url), headers: TokenHeaders).then(
                      (response) {
                        Map Mapvalue = json.decode(response.body);
                        profile = profilemodel.fromJson(Mapvalue);
                        if (Mapvalue["success"]) {
                          navigateTo(
                              context,
                              ProfileScreen(
                                id: x,
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
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currenIndex,
                onTap: (index) {
                  cubit.changeBottomNavBar(index);
                },
                items: cubit.bottomItems),
            body: cubit.screens[cubit.currenIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigateTo(
                    context,
                    AddpostScreen(
                      ForWhat: -1,
                    ));
              },
              backgroundColor: Colors.green[700],
              child: Form(
                key: formKey,
                child: Icon(Icons.post_add),
              ),
            ),
          );
        },
      ),
    );
  }
}
