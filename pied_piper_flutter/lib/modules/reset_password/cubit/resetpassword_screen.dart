import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/layout/piedpiper_app/background.dart';
import 'package:pied_piper/modules/reset_password/cubit/cubit.dart';
import 'package:pied_piper/modules/reset_password/cubit/states.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:flutter/services.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/components/functions.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';
// ignore: must_be_immutable

class ResetPasswordScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var passwordcontroller = TextEditingController();
  var confirmpasswordcontroller = TextEditingController();
  var email;
  CodeObject codes = CodeObject();
  var code;
  ResetPasswordScreen({@required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Stack(
          children: [
            BackgroundImage(),
            Scaffold(
              appBar: AppBar(
                title: Center(
                  child: MyText(
                    text: 'Reset Password',
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
                            height: 40.0,
                          ),
                          Container(
                            width: double.infinity,
                            child: MyText(
                              text:
                                  'We Have Sent the Verfication Code to ${email.toString()}, please check it !',
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
                                  codes.Codefield(context: context, index: 0),
                                  codes.Codefield(context: context, index: 1),
                                  codes.Codefield(context: context, index: 2),
                                  codes.Codefield(context: context, index: 3),
                                  codes.Codefield(context: context, index: 4),
                                  codes.Codefield(context: context, index: 5),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                          defaultformfield(
                            controller: passwordcontroller,
                            type: TextInputType.visiblePassword,
                            labeltext: 'Password',
                            validate: (value) =>
                                functions.validate_Password(value),
                            prefix: Icons.lock_outline,
                            suffix: ResetPasswordCubit.get(context).suffix1,
                            ispassword:
                                ResetPasswordCubit.get(context).ispassword1,
                            SuffixPressed: () {
                              ResetPasswordCubit.get(context)
                                  .changePasswordVisibility1();
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultformfield(
                            ispassword:
                                ResetPasswordCubit.get(context).ispassword2,
                            controller: confirmpasswordcontroller,
                            type: TextInputType.visiblePassword,
                            labeltext: 'Confirm Password',
                            validate: (value) =>
                                functions.validate_Equal_password(
                                    passwordcontroller.text,
                                    confirmpasswordcontroller.text),
                            prefix: Icons.lock_outline,
                            suffix: ResetPasswordCubit.get(context).suffix2,
                            SuffixPressed: () {
                              ResetPasswordCubit.get(context)
                                  .changePasswordVisibility2();
                            },
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! ResetPasswordLoadingState,
                            builder: (context) => defaultbutton(
                              text: 'RESET PASSWORD',
                              radius: 50.0,
                              background: Colors.green[900],
                              function: () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  codes.s.forEach((key, khaled) {
                                    if (key == 0)
                                      code = khaled;
                                    else
                                      code += khaled;
                                  });
                                  ResetPasswordCubit.get(context).ResetCode(
                                    code: '${code}',
                                    context: context,
                                    password: passwordcontroller.text,
                                  );
                                }
                              },
                            ),
                            fallback: (context) {
                              {
                                ResetPasswordCubit.get(context)
                                    .changeisLoading();
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
                            height: 20,
                          ),
                          defaultbutton(
                            background: Colors.transparent,
                            text: "ReSend Code",
                            underline: true,
                            function: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                MySnakbar(text: 'Code Resended Successfully!'),
                              );
                              ResetPasswordCubit()
                                  .ResendCodeVerfication(email: email);
                            },
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
