import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/layout/piedpiper_app/background.dart';
import 'package:pied_piper/modules/register/cubit/cubit.dart';
import 'package:pied_piper/modules/register/cubit/states.dart';
import 'package:pied_piper/modules/verify/cubit/verify_screen.dart';
import 'package:pied_piper/shared/components/components.dart';
import 'package:flutter/services.dart';
import 'package:pied_piper/shared/components/constants.dart';
import 'package:pied_piper/shared/components/functions.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var passwordcontroller = TextEditingController();

  var namecontroller = TextEditingController();

  var emailcontroller = TextEditingController();
  var Confirmpasswordcontroller = TextEditingController();
  bool isnt = true;
  bool isnt2 = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image(
                                image:
                                    AssetImage(LogoImage),
                                height: 150,
                                width: 150,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 70.0,
                          ),
                          defaultformfield(
                            controller: namecontroller,
                            type: TextInputType.name,
                            labeltext: 'User Name',
                            validate: (value) => functions.validate_Name(value),
                            prefix: Icons.person_outline,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultformfield(
                            controller: emailcontroller,
                            type: TextInputType.emailAddress,
                            labeltext: 'Email Address',
                            validate: (value) =>
                                functions.validate_Email(value),
                            prefix: Icons.email_outlined,
                          ),
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
                            suffix: RegisterCubit.get(context).suffix1,
                            ispassword: RegisterCubit.get(context).ispassword1,
                            SuffixPressed: () {
                              RegisterCubit.get(context)
                                  .changePasswordVisibility1();
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          defaultformfield(
                            ispassword: RegisterCubit.get(context).ispassword2,
                            controller: Confirmpasswordcontroller,
                            type: TextInputType.visiblePassword,
                            labeltext: 'Confirm Password',
                            validate: (value) =>
                                functions.validate_Equal_password(
                                    passwordcontroller.text,
                                    Confirmpasswordcontroller.text),
                            prefix: Icons.lock_outline,
                            suffix: RegisterCubit.get(context).suffix2,
                            SuffixPressed: () {
                              RegisterCubit.get(context)
                                  .changePasswordVisibility2();
                            },
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => defaultbutton(
                              text: 'REGISTER',
                              function: () async {
                                if (formKey.currentState.validate()) {
                                  await RegisterCubit.get(context).userRegister(
                                    name: '${namecontroller.text}',
                                    email: '${emailcontroller.text}',
                                    password: '${passwordcontroller.text}',
                                    context: context,
                                  );
                                }
                              },
                            ),
                            fallback: (context) {
                              {
                                RegisterCubit.get(context).changeisLoading();
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                    backgroundColor: Colors.white,
                                  ),
                                );
                              }
                            },
                          )
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
