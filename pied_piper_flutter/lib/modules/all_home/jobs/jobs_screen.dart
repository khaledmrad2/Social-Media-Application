import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/piedpiper_app/background.dart';
import '../../../shared/components/components.dart';
import 'jobs_cubit.dart';
import 'jobs_status.dart';

class jobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => JobsCubit()..Get(),
      child: BlocConsumer<JobsCubit, JobsStates>(
          listener: (context, state) {},
          builder: (BuildContext context, state) {
            var list = JobsCubit.get(context).JobsPosts;
            List<Widget> postwidget = [];
            for (var v in list) {
              if (v.type == 'job')
                postwidget.add(Jobpost(post: v, screennumber: 1));
            }
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Container(
                  color: Colors.grey[300],
                  child: ListView.builder(
                      shrinkWrap: true,
                      //itemExtent: 1000,
                      itemCount: postwidget.length,
                      primary: false,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext context, int index) {
                        return postwidget[index];
                      }),
                ),
              ),
            );
          }),
    );
  }
}
