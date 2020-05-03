
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animate"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Implicit Animations"),
            onTap: ()=> Navigator.of(context).pushNamed("animate_implicit"),
          ),
          ListTile(
            title: Text("TweenAnimationBuilder"),
            onTap: ()=> Navigator.of(context).pushNamed("animate_tween"),
          ),
          ListTile(
            title: Text("TweenAnimationBuilder ColorFilter"),
            onTap: ()=> Navigator.of(context).pushNamed("animate_tween_colorfilter"),
          ),
          ListTile(
            title: Text("Transition widgets"),
            onTap: ()=> Navigator.of(context).pushNamed("animate_transition"),
          )
        ],
      ),
    );
  }
}
