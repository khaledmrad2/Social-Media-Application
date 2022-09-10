import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/users/personal_information/personalinformation_cubit.dart';
import 'package:pied_piper/modules/users/personal_information/personalinformation_states.dart';
import 'package:pied_piper/shared/components/constants.dart';

import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../profile/profile_screen.dart';

class PersonalInformationScreen extends StatelessWidget {
  int isHire;
  String location;
  String JobTitle;
  int id;
  int fromWhat;
  int isHome;
  var formKey = GlobalKey<FormState>();
  BuildContext context;
  PersonalInformationScreen({
    @required this.isHire,
    @required this.location,
    @required this.JobTitle,
    @required this.id,
    @required this.isHome,
    @required this.fromWhat,
  });
  var locationcontroller = TextEditingController();
  var Jobcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PersonalInformationCubit(),
        child: BlocConsumer<PersonalInformationCubit,
                PersonalInformationStates>(
            listener: (context, state) {},
            builder: (BuildContext context, state) {
              locationcontroller..text = location;
              Jobcontroller..text = JobTitle;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green[700],
                  title: Center(
                    child: Text(
                      'Edit The Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          child: Image(
                              image: AssetImage('assets/images/piedpiper.png')),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Are you available to hire ?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    PersonalInformationCubit.get(context)
                                        .ChangeToHire();
                                    isHire =
                                        PersonalInformationCubit.get(context)
                                            .isHire;
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: isHire == 1
                                          ? Colors.green[500]
                                          : Colors.grey[400],
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    PersonalInformationCubit.get(context)
                                        .ChangeFromHire();
                                    isHire =
                                        PersonalInformationCubit.get(context)
                                            .isHire;
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: isHire == 1
                                          ? Colors.grey[400]
                                          : Colors.green[500],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your Location',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        personalformfield(
                          prefix: Icons.location_on,
                          controller: locationcontroller,
                          type: TextInputType.text,
                          labeltext: 'Location',
                          validate: (value) {
                            if (value.isEmpty)
                              return "Required Filed";
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        // Container(
                        //   height: 5,
                        //   color: Colors.black,
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your Job',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        personalformfield(
                          prefix: Icons.work,
                          controller: Jobcontroller,
                          type: TextInputType.text,
                          labeltext: 'Job Title',
                          validate: (value) {
                            if (value.isEmpty)
                              return "Required Filed";
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        // Container(
                        //   height: 5,
                        //   color: Colors.black,
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultbutton(
                            radius: 500,
                            width: 300,
                            function: () {
                              if (formKey.currentState.validate()) {
                                isHire == 1
                                    ? PersonalInformationCubit.get(context)
                                        .EditPersonalCode(
                                        available: 1,
                                        isHome: isHome,
                                        Location: '${locationcontroller.text}',
                                        JobTitle: '${Jobcontroller.text}',
                                        context: context,
                                        id: id,
                                        FromWhat: fromWhat,
                                      )
                                    : PersonalInformationCubit.get(context)
                                        .EditPersonalCode(
                                        available: 0,
                                        Location: '${locationcontroller.text}',
                                        JobTitle: '${Jobcontroller.text}',
                                        context: context,
                                        id: id,
                                        isHome: isHome,
                                        FromWhat: fromWhat,
                                      );
                              }
                              // available_to_hire: isHire,);
                            },
                            text: "Apply Changes"),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  void goto() async {
    profilemodel profile;
    String url = 'http://10.0.2.2:8000/api/profile/' + '${id}';
    await http.get(Uri.parse(url), headers: TokenHeaders).then(
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
          //
        }
      },
    ).catchError(
      (error) {
        print("GetPost Error is : ${error.toString()}");
      },
    );
  }
}
