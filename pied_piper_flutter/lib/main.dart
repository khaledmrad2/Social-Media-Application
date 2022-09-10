import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pied_piper/models/login_model.dart';
import 'package:pied_piper/models/post_model.dart';
import 'package:pied_piper/modules/Post/getpost/SpaceScreen.dart';
import 'package:pied_piper/modules/all_home/home/home_screen.dart';
import 'package:pied_piper/modules/register/register_screen.dart';
import 'package:pied_piper/modules/verify/cubit/verify_screen.dart';
import 'package:pied_piper/shared/bloc_observer.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
import 'package:pied_piper/shared/network/remote/dio_helper.dart';
import 'modules/Post/addpost/addpost_screen.dart';
import 'modules/login/cubit/login_screen.dart';
import 'modules/reset_password/cubit/resetpassword_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  var Screen;
  await CacheHelper.init();
  await DioHelper.init();
  // CacheHelper.removeData(key: 'token');
  if (CacheHelper.GetData(key: 'token') != null)
    Screen = HomeScreen();
  else
    Screen = LoginScreen();
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        Screen: Screen,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  var Screen;
  MyApp({@required this.Screen});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Colors.green,
          selectedIconTheme: IconThemeData(color: Colors.green),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 2.0,
        ),
      ),
      home: Screen,
    );
  }
}
