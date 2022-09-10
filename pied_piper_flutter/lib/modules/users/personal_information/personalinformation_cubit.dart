import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pied_piper/modules/Post/addpost/addpost_screen.dart';
import 'package:pied_piper/modules/users/personal_information/personalinformation_states.dart';
import 'package:pied_piper/shared/network/local/cache_helper.dart';

import '../../../models/profile_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../profile/profile_screen.dart';

class PersonalInformationCubit extends Cubit<PersonalInformationStates> {
  PersonalInformationCubit() : super(PersonalInformationInitialState());
  static PersonalInformationCubit get(context) => BlocProvider.of(context);
  int isHire = 0;
  void ChangeToHire() {
    isHire = 1;
    emit(ChangeToggleHire());
  }

  void ChangeFromHire() {
    isHire = 0;
    emit(ChangeToggleHire());
  }

  void EditPersonalCode(
      {@required int available,
      @required isHome,
      @required BuildContext context,
      @required String JobTitle,
      @required String Location,
      @required int id,
      @required int FromWhat}) async {
    String url = MainURL + UpdatePersonalURL;
    http.post(
      Uri.parse(url),
      headers: TokenHeaders,
      body: {
        "available_to_hire": "${available}",
        "job_title": "${JobTitle}",
        "location": "${Location}"
      },
    ).then((response) {
      Map Mapvalue = json.decode(response.body);
    }).catchError((error) {
      print("loginDataEnter: ${error.toString()}");
    });

    profilemodel.fromJson({
      "available_to_hire": "${available}",
      "job_title": "${JobTitle}",
      "location": "${Location}"
    });
    profilemodel profile;

    String url2 = MainURL + GetProfile + "${id}";
    FromWhat == 1
        ? await http.get(Uri.parse(url2), headers: TokenHeaders).then(
            (response) {
              Map Mapvalue = json.decode(response.body);

              profile = profilemodel.fromJson(Mapvalue);
              if (Mapvalue["success"]) {
                Navigator.pop(context);
                Navigator.pop(context);
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
              print("GetPost Error is : ${error.toString()}");
            },
          )
        : {
            Navigator.pop(context),
            CacheHelper.saveDataint(key: 'available_to_hire', value: available),
            CacheHelper.saveData(key: 'job_title', value: JobTitle),
            CacheHelper.saveData(key: 'location', value: Location),
          };
  }
}
