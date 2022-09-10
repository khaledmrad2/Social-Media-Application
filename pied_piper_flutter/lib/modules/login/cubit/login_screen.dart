import 'dart:convert';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/layout/piedpiper_app/background.dart';
import 'package:pied_piper/modules/login/cubit/cubit.dart';
import 'package:pied_piper/modules/login/cubit/states.dart';
import 'package:pied_piper/modules/register/register_screen.dart';
import 'package:pied_piper/modules/reset_password/cubit/resetpassword_screen.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:flutter/services.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/components/functions.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  ///formkey for Valiadtion
  var formKey = GlobalKey<FormState>();

  ///Store Email to send it to  forget password button
  final _emailformFieldKey = GlobalKey<FormFieldState>();

  ///email and password Controller
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Stack(
          children: [
            BackgroundImage(),
            Scaffold(
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage(LogoImage),
                                height: 150,
                                width: 150,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: 'Hello .',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              MyText(
                                text: 'Welcome Back',
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              defaultformfield(
                                  controller: emailcontroller,
                                  formkey: _emailformFieldKey,
                                  type: TextInputType.emailAddress,
                                  labeltext: 'Email Address',
                                  validate: (value) =>
                                      functions.validate_Email(value),
                                  prefix: Icons.email_outlined,
                                  onchange: (value) {}),
                              SizedBox(
                                height: 20,
                              ),
                              defaultformfield(
                                controller: passwordcontroller,
                                type: TextInputType.visiblePassword,
                                labeltext: 'Password',
                                validate: (value) =>
                                    functions.validate_Password(value),
                                prefix: Icons.lock_outline,
                                suffix: LoginCubit.get(context).suffix,
                                ispassword: LoginCubit.get(context).ispassword,
                                SuffixPressed: () {
                                  LoginCubit.get(context)
                                      .changePasswordVisibility();
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextButton(
                                  child: MyText(
                                    text: 'Forget Password ?',
                                    fcolor: Colors.white,
                                    fsize: 20,
                                  ),
                                  onPressed: () {
                                    if (_emailformFieldKey.currentState
                                        .validate())
                                      LoginCubit.get(context)
                                          .SendEmailtoResetPassword(
                                        context: context,
                                        email: emailcontroller.text,
                                      );
                                  }),
                              SizedBox(
                                height: 20.0,
                              ),
                              ConditionalBuilder(
                                condition: state is! LoginLoadingState,
                                builder: (context) => defaultbutton(
                                  radius: 7,
                                  text: 'LOGIN',
                                  function: () async {
                                    if (formKey.currentState.validate()) {
                                      await LoginCubit.get(context).userLogin(
                                        email: '${emailcontroller.text}',
                                        password: '${passwordcontroller.text}',
                                        context: context,
                                      );
                                    }
                                  },
                                ),
                                fallback: (context) {
                                  {
                                    LoginCubit.get(context).changeisLoading();
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
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    child: MyText(
                                        text: 'Creat Account !',
                                        fsize: 20,
                                        fcolor: Colors.white),
                                    onPressed: () {
                                      navigateTo(context, RegisterScreen());
                                    },
                                  ),
                                ],
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
