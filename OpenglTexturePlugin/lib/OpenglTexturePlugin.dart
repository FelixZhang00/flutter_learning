import 'dart:async';

import 'package:flutter/services.dart';

class OpenglTexturePlugin {
  static const MethodChannel _channel =
      const MethodChannel('OpenglTexturePlugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
