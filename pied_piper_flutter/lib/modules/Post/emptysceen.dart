import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pied_piper/modules/Post/view_post/post_cubit.dart';
import 'package:pied_piper/modules/Post/view_post/states.dart';

import '../../models/post_model.dart';
import '../../models/reaction_model.dart';
import '../../shared/components/components.dart';
import 'getpost/getpost_cubit.dart';

class empty extends StatelessWidget {
  postmodel post;
  empty(this.post);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
