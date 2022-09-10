import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

import '../group/grouphome_screen.dart';
import '../jobs/jobs_screen.dart';
import '../menu/menu_screen.dart';
import '../news/news_screen.dart';
import '../notifications/notification_screen.dart';
import '../requests/request_screen.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);
  int currenIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      label: 'News',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.work,
      ),
      label: 'Work',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.group_rounded,
      ),
      label: 'Group',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.notification_important,
      ),
      label: 'Notification',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.group_add_outlined,
      ),
      label: 'Requests',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.menu,
      ),
      label: 'Menu',
    ),
  ];
  List<Widget> screens = [
    NewsScreen(),
    jobsScreen(),
    GroupHomescreen(),
    NotificationScreen(),
    RequestScreen(),
    MenuScreen(),
  ];

  void changeBottomNavBar(int index) {
    currenIndex = index;
    emit(HomeBottomNavState());
  }

  List<dynamic> Posts = [];
}
