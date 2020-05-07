import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OpenGlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("OpenGl"),
        ),
        body: Column(children: [
          ListTile(
            title: Text("opengl demo"),
            onTap: () =>
                Navigator.of(context).pushNamed("/opengl/opengl_demo_page"),
          ),
        ]));
  }
}
