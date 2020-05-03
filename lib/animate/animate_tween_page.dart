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

class AnimateImplicitWidget extends StatefulWidget {
  @override
  _AnimateImplicitWidgetState createState() => _AnimateImplicitWidgetState();
}

class _AnimateImplicitWidgetState extends State<AnimateImplicitWidget> {
  bool _bigger = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            width: _bigger ? 300 : 100,
            child: Image.asset("assets/ic_saturn.png"),
            duration: Duration(seconds: 1),
            curve: Curves.easeOutBack,
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [Colors.red, Colors.transparent],
                    stops: [_bigger ? 0.2 : 0.5, 1.0])),
          ),
          RaisedButton(
            onPressed: () => setState(() {
              _bigger = !_bigger;
            }),
            child: Icon(Icons.star),
          )
        ],
      ),
    );
  }
}
