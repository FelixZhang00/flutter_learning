import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimateTransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Transition Animations"),
        ),
        body: Container(
          child: RotateImageWidget(),
        ));
  }
}

class RotateImageWidget extends StatefulWidget {
  @override
  _RotateImageWidgetState createState() => _RotateImageWidgetState();
}

class _RotateImageWidgetState extends State<RotateImageWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RotationTransition(
            alignment: Alignment.center,
            child: Image.asset("assets/ic_saturn.png"),
            turns: _animationController,
          ),
          TimeStopper(controller: _animationController)
        ],
      ),
    );
  }
}

class TimeStopper extends StatelessWidget {
  final AnimationController controller;

  const TimeStopper({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.isAnimating) {
          controller.stop();
        } else {
          controller.repeat();
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.green),
        width: 100,
        height: 100,
      ),
    );
  }
}
