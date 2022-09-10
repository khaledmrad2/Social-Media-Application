import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        /// Here We Can add Colors To Make a gradient of them
        colors: [Colors.green[900],Colors.white12,Colors.green[900]],
        //or darken with Colors.green[900],Colors.green[800],Colors.green[900],Colors.green[800],Colors.green[800],Colors.green[900],Colors.green[900]
        /// from where to where we will make the gradient
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(bounds),
      /// Mode of Light of the Picture
      blendMode: BlendMode.lighten,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            ///The Image That Will Put in The Background
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
      ),
    );
  }
}
