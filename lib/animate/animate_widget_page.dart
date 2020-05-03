import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimateWidgetDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AnimateWidget"),
        ),
        body: Container(
          child: AnimateWidgetDemoWidget(),
        ));
  }
}

class AnimateWidgetDemoWidget extends StatefulWidget {
  @override
  _AnimateWidgetDemoWidgetState createState() =>
      _AnimateWidgetDemoWidgetState();
}

class _AnimateWidgetDemoWidgetState extends State<AnimateWidgetDemoWidget>
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
        BeamTransition(animation: _animationController),
        Container(
          width: 200,
          height: 100,
          child: Image.asset("assets/ufo.png"),
        )
      ],
    );
  }
}

class BeamTransition extends AnimatedWidget {
  const BeamTransition(
      {Key key, @required Animation<double> animation, Widget child})
      : _child = child,
        super(key: key, listenable: animation);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return ClipPath(
      clipper: const BeamClipper(),
      child: Container(
        height: 1000,
        decoration: BoxDecoration(
            gradient: RadialGradient(
                radius: 1.5,
                colors: [Colors.yellow, Colors.transparent],
                stops: [0, animation.value])),
      ),
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
