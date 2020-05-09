import 'package:flutter/material.dart';
import 'package:flutter_learning/dynamic/dynamic_page.dart';
import 'package:flutter_learning/opengl/opengl_page.dart';
import 'package:flutter_learning/platform_channel/platform_channel_page.dart';

import 'animate/animate_builder_page.dart';
import 'animate/animate_implicit_page.dart';
import 'animate/animate_page.dart';
import 'animate/animate_transition_page.dart';
import 'animate/animate_tween_colorfilter_page.dart';
import 'animate/animate_tween_simple_page.dart';
import 'animate/animate_widget_page.dart';
import 'animate/transform_like_demo_page.dart';
import 'dynamic/dynamic_widget_page.dart';
import 'opengl/opengl_texture_page.dart';
import 'platform_channel/method_channel_demo_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Learning',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "animate":(_)=> AnimatePage(),
        "animate_implicit":(_)=> AnimateImplicitPage(),
        "animate_tween":(_)=> AnimateTweenPage(),
        "animate_tween_colorfilter":(_)=> AnimateTweenColorFilterPage(),
        "animate_transition" : (_)=> AnimateTransitionPage(),
        "animate_builder" : (_)=> AnimateBuilderPage(),
        "animate_widget" : (_)=> AnimateWidgetDemoPage(),
        "transform_like_demo" : (_)=> FacebookLikeDemoPage(),
        "/platform_channel":(_)=> PlatformChannelPage(),
        "/platform_channel/method_channel_demo_page" : (_)=> MethodChannelDemoPage(),
        "/opengl":(_)=> OpenGlPage(),
        "/opengl/opengl_texture_page":(_)=> OpenGlTexturePage(),
        "/dynamic":(_)=> DynamicPage(),
        "/dynamic/dynamic_widget":(_)=> DynamicWidgetPage(),
      },
      home: HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Learning"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Animate"),
            onTap: ()=> Navigator.of(context).pushNamed("animate"),
          ),
          ListTile(
            title: Text("platform channel"),
            onTap: ()=> Navigator.of(context).pushNamed("/platform_channel"),
          ),
          ListTile(
            title: Text("OpenGl"),
            onTap: ()=> Navigator.of(context).pushNamed("/opengl"),
          ),
          ListTile(
            title: Text("Dynamic"),
            onTap: ()=> Navigator.of(context).pushNamed("/dynamic"),
          )
        ],
      ),
    );
  }
}

