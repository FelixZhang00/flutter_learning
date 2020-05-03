import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimateBuilderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AnimateBuilder"),
        ),
        body: Container(
          child: AnimateBuildDemoWidget(),
        ));
  }
}

class AnimateBuildDemoWidget extends StatefulWidget {
  @override
  _AnimateBuildDemoWidgetState createState() => _AnimateBuildDemoWidgetState();
}

class _AnimateBuildDemoWidgetState extends State<AnimateBuildDemoWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          color: Colors.black26,
        ),
        AnimatedBuilder(
            animation: _animationController,
            builder: (_, __) {
              return ClipPath(
                clipper: const BeamClipper(),
                child: Container(
                  height: 1000,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          radius: 1.5,
                          colors: [Colors.yellow, Colors.transparent],
                          stops: [0, _animationController.value])),
                ),
              );
            }),
        Container(
          width: 200,
          height: 100,
          child: Image.asset("assets/ufo.png"),
        )
      ],
    );
  }
}

class BeamClipper extends CustomClipper<Path> {
  const BeamClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    //Return false always because we always clip the same area.
    return false;
  }
}
