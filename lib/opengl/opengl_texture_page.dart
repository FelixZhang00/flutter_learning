import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:OpenglTexturePlugin/OpenglTexturePlugin.dart';

class OpenGlTexturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("opengl texture"),
        ),
        body: Container(
          child: OpenGlTextureWidget(),
        ));
  }
}

class OpenGlTextureWidget extends StatefulWidget {
  @override
  _OpenGlTextureWidgetState createState() => _OpenGlTextureWidgetState();
}

class _OpenGlTextureWidgetState extends State<OpenGlTextureWidget> {
  final _controller = OpenglTexturePlugin();
  final _width = 200.0;
  final _height = 200.0;

  @override
  void initState() {
    super.initState();

    initController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initController() async {
    await _controller.initialize(_width, _height);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: _width,
        height: _height,
        child: _controller.isInitialized
            ? new Texture(textureId: _controller.textureId)
            : new Container(),
      ),
    );
  }
}
