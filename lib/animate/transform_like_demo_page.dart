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
  bool _isDragging = false;
  Timer holdTimer;
  Duration durationLongPress = Duration(milliseconds: 250);
  final int durationAnimationBox = 500;

  //for short press btn
  AnimationController _animBtnShortPressController;
  Animation _zoomIconLikeInBtnShort, _tiltIconLikeInBtnShort;

  // For long press btn
  AnimationController _animControlBtnLongPress, animControlBox;
  Animation zoomIconLikeInBtn, tiltIconLikeInBtn, zoomTextLikeInBtn;
  Animation fadeInBox;
  Animation moveRightGroupIcon;
  Animation pushIconLikeUp,
      pushIconLoveUp,
      pushIconHahaUp,
      pushIconWowUp,
      pushIconSadUp,
      pushIconAngryUp;
  Animation zoomIconLike,
      zoomIconLove,
      zoomIconHaha,
      zoomIconWow,
      zoomIconSad,
      zoomIconAngry;

  AudioPlayer _audioPlayer;

  // 0 = nothing, 1 = like, 2 = love, 3 = haha, 4 = wow, 5 = sad, 6 = angry
  int whichIconUserChoose = 0;

  // 0 = nothing, 1 = like, 2 = love, 3 = haha, 4 = wow, 5 = sad, 6 = angry
  int currentIconFocus = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    //for short press
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

    //for long press
    _animControlBtnLongPress =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    zoomIconLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(_animControlBtnLongPress);
    tiltIconLikeInBtn =
        Tween(begin: 0.0, end: 0.2).animate(_animControlBtnLongPress);
    zoomTextLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(_animControlBtnLongPress);

    zoomIconLikeInBtn.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn.addListener(() {
      setState(() {});
    });
    zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    animControlBox = AnimationController(
        vsync: this, duration: Duration(milliseconds: durationAnimationBox));
    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animControlBox, curve: Interval(0.7, 1.0)));
    fadeInBox.addListener(() {
      setState(() {});
    });
    // General
    moveRightGroupIcon = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
  }

  @override
  void dispose() {
    _animBtnShortPressController.dispose();
    _animControlBtnLongPress.dispose();
    animControlBox.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(children: <Widget>[
      Container(
        width: double.infinity,
        height: 100,
      ),
      Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          height: 350,
          child: Stack(children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[buildBox(), buildIcons()],
            ),
            buildBtnLike()
          ])),
    ]));
  }

  Widget buildBox() {
    return Opacity(
      opacity: this.fadeInBox.value,
      child: Container(
        width: 300,
        height: 50,
        margin: EdgeInsets.only(bottom: 130, left: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: Colors.grey[300], width: 0.3),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  // LTRB
                  offset: Offset.lerp(Offset(0.0, 0.0), Offset(0.0, 0.5), 10.0))
            ]),
      ),
    );
  }

  Widget buildIcons() {
    return Container(
      width: 300.0,
      height: 250.0,
      margin: EdgeInsets.only(left: this.moveRightGroupIcon.value, top: 50.0),
      child: Row(
        children: [
          Transform.scale(
            scale: this.zoomIconLike.value,
            child: Container(
              margin: EdgeInsets.only(bottom: 60),
              width: 40.0,
              height: 40,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 1
                      ? Container(
                          child: Text(
                            "Like",
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3)),
                          padding: EdgeInsets.only(
                              left: 7.0, right: 7.0, top: 2.0, bottom: 2.0),
                          margin: EdgeInsets.only(bottom: 8.0),
                        )
                      : Container(),
                  Image.asset(
                    'assets/like.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBtnLike() {
    return Container(
      child: GestureDetector(
        onTap: onTapBtn,
        onTapDown: onTapDownBtn,
        onTapUp: onTapUpBtn,
        child: Container(
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
                        : tiltIconLikeInBtn.value,
                  ),
                  scale: !_isLongPress
                      ? handleOutputRnageZoomInIconLike(
                          _zoomIconLikeInBtnShort.value)
                      : zoomIconLikeInBtn.value,
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
                      : zoomTextLikeInBtn.value,
                )
              ],
            ),
          ),
        ),
      ),
      width: 100,
      margin: EdgeInsets.only(top: 190),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
          border: Border.all(color: getColorBorderBtn())),
    );
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
    } else if (!_isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return Color(0xff3b5998);
        case 2:
          return Color(0xffED5167);
        case 3:
        case 4:
        case 5:
          return Color(0xffFFD96A);
        case 6:
          return Color(0xffF6876B);
        default:
          return Colors.grey;
      }
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

    if (_isLongPress) {
      if (whichIconUserChoose == 0) {
        playSound('box_down.mp3');
      } else {
        playSound('icon_choose.mp3');
      }
    }

    Timer(Duration(milliseconds: durationAnimationBox),
        () => _isLongPress = false);
    holdTimer.cancel();

    _animControlBtnLongPress.reverse();
    setReverseValue();
    animControlBox.reverse();

//    animControlIconWhenRelease.reset();
//    animControlIconWhenRelease.forward();
  }

  void showBow() {
    print("showBow");

    playSound('box_up.mp3');
    _isLongPress = true;

    _animControlBtnLongPress.forward();

    setForwardValue();
    animControlBox.forward();
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

  Future playSound(String fileName) async {
    await _audioPlayer.stop();
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.writeAsBytes((await loadAssets(fileName)).buffer.asUint8List());
    await _audioPlayer.play(file.path, isLocal: true);
  }

  Future loadAssets(String fileName) async {
    return await rootBundle.load('sounds/$fileName');
  }

  // When set the reverse value, we need set value to normal for the forward
  void setForwardValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
  }

  // We need to set the value for reverse because if not
  // the angry-icon will be pulled down first, not the like-icon
  void setReverseValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.5, 1.0)),
    );

    pushIconLoveUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );
    zoomIconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.4, 0.9)),
    );

    pushIconHahaUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );
    zoomIconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.3, 0.8)),
    );

    pushIconWowUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );
    zoomIconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.2, 0.7)),
    );

    pushIconSadUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );
    zoomIconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.1, 0.6)),
    );

    pushIconAngryUp = Tween(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
    zoomIconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: Interval(0.0, 0.5)),
    );
  }
}
