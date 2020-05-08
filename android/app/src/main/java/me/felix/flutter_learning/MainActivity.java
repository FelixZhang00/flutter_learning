package me.felix.flutter_learning;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import me.felix.OpenglTexturePlugin.OpenglTexturePlugin;
import xyz.luan.audioplayers.AudioplayersPlugin;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    AudioplayersPlugin.registerWith(registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    OpenglTexturePlugin.registerWith(registrarFor("me.felix.OpenglTexturePlugin.OpenglTexturePlugin"));
  }


}
