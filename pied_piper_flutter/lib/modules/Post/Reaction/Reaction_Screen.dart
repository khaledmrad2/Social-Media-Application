import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../layout/piedpiper_app/background.dart';

class reactionscreen extends StatelessWidget {
  List<Widget> reactions;
  reactionscreen({@required this.reactions});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BackgroundImage(),
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Total Reactions : ${reactions.length}',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            // height: 1000,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: reactions.length,
                primary: false,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  return reactions[index];
                }),
          ),
        ),
      )
    ]);
  }
}
