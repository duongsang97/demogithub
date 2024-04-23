import 'package:flutter/material.dart';

class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;

  ImageScannerAnimation(this.stopped, this.width,{Key? key, Animation<double>? animation}): super(key: key, listenable: animation!);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * (width*.9));

    Color color1 = Color(0x5532CD32);
    Color color2 = Color(0x0032CD32);

    if (animation.status == AnimationStatus.reverse) {
      color1 = Color(0x0032CD32);
      color2 = Color(0x5532CD32);
    }

    return Visibility(
      visible: !stopped,
      child: Positioned(
        bottom: scorePosition,
        left: 0.0,
        child: new Opacity(
          opacity: (stopped) ? 0.0 : 1.0,
          child: Container(
            height: 80.0,
            width: width,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.9],
              colors: [color1, color2],
            )
          ),
        )
      )),
    );
  }
}