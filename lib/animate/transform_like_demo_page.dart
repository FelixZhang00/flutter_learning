import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class FacebookLikeDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("facebook like demo"),
        ),
        body: Container(
          child: FbReaction(),
        ));
  }
}

class FbReaction extends StatefulWidget {
  @override
  _FbReactionState createState() => _FbReactionState();
}

class _FbReactionState extends State<FbReaction> with TickerProviderStateMixin {
  bool _isLongPress = false;
  bool _isLike = false;
  Timer holdTimer;
  Duration durationLongPress = Duration(milliseconds: 250);
  final int durationAnimationBox = 500;

  //for short press btn
  AnimationController _animBtnShortPressController;
  Animation _zoomIconLikeInBtnShort, _tiltIconLikeInBtnShort;

  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _animBtnShortPressController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _zoomIconLikeInBtnShort =
        Tween(begin: 1.0, end: 0.2).animate(_animBtnShortPressController);
    _zoomIconLikeInBtnShort.addListener(() {
      setState(() {});
    });
    _tiltIconLikeInBtnShort =
        Tween(begin: 0.0, end: 0.8).animate(_animBtnShortPressController);
    _tiltIconLikeInBtnShort.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animBtnShortPressController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: onTapBtn,
      onTapDown: onTapDownBtn,
      onTapUp: onTapUpBtn,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.white,
            border: Border.all(color: getColorBorderBtn())),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Transform.scale(
                child: Transform.rotate(
                  child: Image.asset(getImageIconBtn(),
                      height: 25, width: 25, fit: BoxFit.contain),
                  angle: !_isLongPress
                      ? handleOutputRnageTiltIconLike(
                          _tiltIconLikeInBtnShort.value)
                      : 0,
                ),
                scale: !_isLongPress
                    ? handleOutputRnageZoomInIconLike(
                        _zoomIconLikeInBtnShort.value)
                    : 0,
              ),
              Transform.scale(
                child: Text(
                  "Like",
                  style: TextStyle(
                      color: getColorTextBtn(),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                scale: !_isLongPress
                    ? handleOutputRnageZoomInIconLike(
                        _zoomIconLikeInBtnShort.value)
                    : 0,
              )
            ],
          ),
        ),
      ),
    ));
  }

  String getImageIconBtn() {
    if ((!_isLongPress && _isLike)) {
      return "assets/ic_like_fill.png";
    } else {
      return "assets/ic_like.png";
    }
  }

  Color getColorBorderBtn() {
    if ((!_isLongPress && _isLike)) {
      return Color(0xff3b5998);
    } else {
      return Colors.grey[400];
    }
  }

  Color getColorTextBtn() {
    if ((!_isLongPress && _isLike)) {
      return Color(0xff3b5998);
    } else {
      return Colors.grey;
    }
  }

  void onTapBtn() {
    print("onTapBtn");
    if (!_isLongPress) {
      _isLike = !_isLike;
    }

    if (_isLike) {
      playSound('short_press_like.mp3');
      _animBtnShortPressController.forward();
    } else {
      _animBtnShortPressController.reverse();
    }
  }

  void onTapDownBtn(TapDownDetails details) {
    print("onTapDownBtn");
    holdTimer = Timer(durationLongPress, showBow);
  }

  void onTapUpBtn(TapUpDetails details) {
    print("onTapUpBtn");
    Timer(Duration(milliseconds: durationAnimationBox), () => _isLongPress);
    holdTimer.cancel();
  }

  void showBow() {
    print("showBow");
  }

  double handleOutputRnageTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  double handleOutputRnageZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  Future playSound(String fileName) async{
    await _audioPlayer.stop();
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.writeAsBytes((await loadAssets(fileName)).buffer.asUint8List());
    await _audioPlayer.play(file.path,isLocal: true);
  }

  Future loadAssets(String fileName) async {
    return await rootBundle.load('sounds/$fileName');
  }
}
