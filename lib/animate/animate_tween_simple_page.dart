import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimateTweenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TweenAnimationBuilder"),
        ),
        body: Container(
          child: AnimateImplicitWidget(),
        ));
  }
}

class AnimateImplicitWidget extends StatelessWidget {

  static final Tween<double> tweenRotate = Tween<double>(begin: 0, end: 2 * pi);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TweenAnimationBuilder<double>(
      tween: tweenRotate,
      duration: Duration(seconds: 2),
      builder: (BuildContext context, double angle, Widget child) {
        return Transform.rotate(
          angle: angle,
          child: Image.asset("assets/ic_saturn.png"),
        );
      },
    ));
  }
}
