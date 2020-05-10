import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DynamicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dynamic"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("dynamic_widget"),
            onTap: () => Navigator.of(context).pushNamed("/dynamic/dynamic_widget"),
          ),
        ],
      ),
    );
  }
}
