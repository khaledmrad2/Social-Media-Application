import 'dart:convert';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/layout/piedpiper_app/background.dart';
import 'package:pied_piper/modules/verify/cubit/cubit.dart';
import 'package:pied_piper/modules/verify/cubit/states.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:flutter/services.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

class VerifyScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var codecontroller = TextEditingController();
  var code;
  VerifyScreen({@required this.email});
  var email;
  CodeObject codeobject = CodeObject();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => VerifyCubit(),
      child: BlocConsumer<VerifyCubit, VerifyStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Stack(
          children: [
            BackgroundImage(),
            Scaffold(
              appBar: AppBar(
                title: Center(
                  child: MyText(
                    text: 'Email Verfictaion',
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                  image: AssetImage(LogoImage),
                                  height: 150,
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            width: double.infinity,
                            child: MyText(
                              text: 'We Have Sent the Verfication Code to ${email.toString()} , please check it',
                              fcolor: Colors.white,
                              fsize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  codeobject.Codefield(
                                      context: context, index: 0),
                                  codeobject.Codefield(
                                      context: context, index: 1),
                                  codeobject.Codefield(
                                      context: context, index: 2),
                                  codeobject.Codefield(
                                      context: context, index: 3),
                                  codeobject.Codefield(
                                      context: context, index: 4),
                                  codeobject.Codefield(
                                      context: context, index: 5),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              ConditionalBuilder(
                                condition: state is! VerifyLoadingState,
                                builder: (context) => defaultbutton(
                                  text: 'Verify',
                                  radius: 50.0,
                                  background: Colors.green.shade500,
                                  function: () {
                                    if (formKey.currentState.validate()) {
                                      ///Saves every FormField that is a descendant of this Form
                                      formKey.currentState.save();
                                      codeobject.s.forEach(
                                        (key, khaled) {
                                          ///expect the initial value  I intialize the map with (99)
                                          if (key == 0)
                                            code = khaled;
                                          else
                                            code += khaled;
                                        },
                                      );
                                      VerifyCubit.get(context).userVerify(
                                        code: '${code}',
                                        context: context,
                                      );
                                    }
                                  },
                                ),
                                fallback: (context) {
                                  {
                                    VerifyCubit.get(context).changeisLoading();
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                        backgroundColor: Colors.white,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              defaultbutton(
                                background: Colors.transparent,
                                text: "ReSend Code",
                                underline: true,
                                function: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    MySnakbar(
                                        text: 'Code Resended Successfully!'),
                                  );
                                  VerifyCubit()
                                      .ResendCodeVerfication(email: email);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
