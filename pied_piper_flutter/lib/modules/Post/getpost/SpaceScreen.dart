import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/Post/getpost/getpost_cubit.dart';
import 'package:pied_piper/modules/Post/getpost/states.dart';
import '../../../shared/components/components.dart';


class SpaceScreen extends StatelessWidget {
  Widget postwidget;
  SpaceScreen({this.postwidget});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GetpostCubit(),
      child: BlocConsumer<GetpostCubit, GetpostStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: MyText(
                text: "Your Notification", fsize: 20, fcolor: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  postwidget,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
