import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimateTweenColorFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TweenAnimationBuilder ColorFilter"),
        ),
        body: Container(
          child: ColorAnimation(),
        ));
  }
}

class ColorAnimation extends StatefulWidget {
  @override
  _ColorAnimationState createState() => _ColorAnimationState();
}

class _ColorAnimationState extends State<ColorAnimation> {
  double _newValue = 0.4;
  Color _newColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Center(
          child: TweenAnimationBuilder(
              tween: ColorTween(begin: Colors.white, end: _newColor),
              duration: Duration(seconds: 2),
              builder: (_, Color color, __) {
                return ColorFiltered(
                  child: Image.asset("assets/sun.png"),
                  colorFilter: ColorFilter.mode(color, BlendMode.modulate),
                );
              }),
        ),
        Slider.adaptive(
            value: _newValue,
            onChanged: (double value) {
              setState(() {
                _newValue = value;
                _newColor = Color.lerp(Colors.white, Colors.red, value);
              });
            })
      ],
    ));
  }
}
