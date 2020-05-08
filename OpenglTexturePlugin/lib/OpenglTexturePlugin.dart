import 'dart:async';

import 'package:flutter/services.dart';

class OpenglTexturePlugin {
  static const MethodChannel _channel =
      const MethodChannel('OpenglTexturePlugin');

  int textureId;

  Future<int> initialize(double width, double height) async {
    textureId = await _channel.invokeMethod('create', {
      'width': width,
      'height': height,
    });
    return textureId;
  }

  Future<Null> dispose() =>
      _channel.invokeMethod('dispose', {'textureId': textureId});

  bool get isInitialized => textureId != null;

  //just a example for method channel
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
