import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlatformChannelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Platform Channel"),
        ),
        body: Column(children: [
          ListTile(
            title: Text("method channel"),
            onTap: () =>
                Navigator.of(context).pushNamed("/platform_channel/method_channel_demo_page"),
          ),
        ]));
  }
}
