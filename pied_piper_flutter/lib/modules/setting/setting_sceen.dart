import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/setting/setting_cubit.dart';
import 'package:pied_piper/modules/setting/setting_states.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:pied_piper/shared/components/functions.dart';

class SettingScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => settingCubit(),
      child: BlocConsumer<settingCubit, settingStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            return Scaffold(
              appBar: AppBar(
                title: MyText(text: 'Setting', fsize: 25, fcolor: Colors.white),
                centerTitle: true,
                backgroundColor: Colors.green,
              ),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            MyText(
                                text: 'Logout ',
                                fcolor: Colors.white,
                                fsize: 25)
                          ],
                        ),
                      ),
                      onTap: () {
                        settingCubit.get(context).logout(context);
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyText(
                      text: 'Delete Your Account ? ',
                      fcolor: Colors.black,
                      fsize: 25,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.green[400],
                      ),
                      child: Form(
                        key: formKey,
                        child: defaultformfield(
                          controller: passwordcontroller,
                          type: TextInputType.visiblePassword,
                          labeltext: 'Password',

                          validate: (value) =>
                              functions.validate_Password(value),
                          prefix: Icons.lock_outline,
                          suffix: settingCubit.get(context).suffix,
                          ispassword: settingCubit.get(context).ispassword,
                          SuffixPressed: () {
                            settingCubit
                                .get(context)
                                .changePasswordVisibility();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever_sharp,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            MyText(
                                text: 'Delete Account ',
                                fcolor: Colors.white,
                                fsize: 25)
                          ],
                        ),
                      ),
                      onTap: () {
                        if (formKey.currentState.validate()) {
                          settingCubit.get(context).deleteAccount(context, passwordcontroller.text.toString())
;                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
