
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'members_states.dart';

class MembersCubit extends Cubit<MembersStates>{
  MembersCubit() : super(MembersInitialState());
  static MembersCubit get(context)=> BlocProvider.of(context);
  List<dynamic> Members = [];
  void getMembers({@required int group_id}){
    emit(MembersLoadingState());
    DioHelper.getData(url: MainURL + MemebersURL+"${group_id}", query :{
    },headers2: TokenHeaders
    ).then((value) {
      Members = value.data['users'];
      emit(MembersSuccessState());
    }).catchError((onError)
    {
      print(onError.toString());
      emit(MembersErrorState(onError));
    });
  }
}