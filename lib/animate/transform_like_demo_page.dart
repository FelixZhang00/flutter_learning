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

  // For zoom icon when drag
  AnimationController animControlIconWhenDrag;
  AnimationController animControlIconWhenDragInside;
  AnimationController animControlIconWhenDragOutside;
  AnimationController animControlBoxWhenDragOutside;
  Animation zoomIconChosen, zoomIconNotChosen;
  Animation zoomIconWhenDragOutside;
  Animation zoomIconWhenDragInside;
  Animation zoomBoxWhenDragOutside;
  Animation zoomBoxIcon;

  // For jump icon when release
  AnimationController animControlIconWhenRelease;
  Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  Animation moveLeftIconLikeWhenRelease,
      moveLeftIconLoveWhenRelease,
      moveLeftIconHahaWhenRelease,
      moveLeftIconWowWhenRelease,
      moveLeftIconSadWhenRelease,
      moveLeftIconAngryWhenRelease;

  AudioPlayer _audioPlayer;

  // 0 = nothing, 1 = like, 2 = love, 3 = haha, 4 = wow, 5 = sad, 6 = angry
  int whichIconUserChoose = 0;

  // 0 = nothing, 1 = like, 2 = love, 3 = haha, 4 = wow, 5 = sad, 6 = angry
  int currentIconFocus = 0;

  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    initAnimationBtnLike();

    initAnimationBox();

    initAnimationIconWhenDrag();

    // Icon when drag outside
    initAnimationIconWhenDragOutside();

    // Box when drag outside
    initAnimationBoxWhenDragOutside();

    // Icon when first drag
    initAnimationIconWhenDragInside();

    // Icon when release
    initAnimationIconWhenRelease();
  }

  void initAnimationBtnLike() {
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
  }

  void initAnimationBox() {
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

    //icons
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

    pushIconLikeUp.addListener(() {
      setState(() {});
    });
    zoomIconLike.addListener(() {
      setState(() {});
    });
    pushIconLoveUp.addListener(() {
      setState(() {});
    });
    zoomIconLove.addListener(() {
      setState(() {});
    });
    pushIconHahaUp.addListener(() {
      setState(() {});
    });
    zoomIconHaha.addListener(() {
      setState(() {});
    });
    pushIconWowUp.addListener(() {
      setState(() {});
    });
    zoomIconWow.addListener(() {
      setState(() {});
    });
    pushIconSadUp.addListener(() {
      setState(() {});
    });
    zoomIconSad.addListener(() {
      setState(() {});
    });
    pushIconAngryUp.addListener(() {
      setState(() {});
    });
    zoomIconAngry.addListener(() {
      setState(() {});
    });
  }

  void initAnimationIconWhenDrag() {
    animControlIconWhenDrag =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    zoomIconChosen =
        Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
    zoomIconNotChosen =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon =
        Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    zoomIconWhenDragOutside =
        Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    zoomBoxWhenDragOutside =
        Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    zoomIconWhenDragInside =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  initAnimationIconWhenRelease() {
    animControlIconWhenRelease =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0).animate(CurvedAnimation(
        parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveLeftIconLikeWhenRelease = Tween(begin: 20.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconLoveWhenRelease = Tween(begin: 68.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconHahaWhenRelease = Tween(begin: 116.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconWowWhenRelease = Tween(begin: 164.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconSadWhenRelease = Tween(begin: 212.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconAngryWhenRelease = Tween(begin: 260.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });

    moveLeftIconLikeWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconLoveWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconHahaWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconWowWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconSadWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconAngryWhenRelease.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animBtnShortPressController.dispose();
    _animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd: onHorizontalDragEndBoxIcon,
        onHorizontalDragUpdate: onHorizontalDragUpdateBoxIcon,
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
                buildBtnLike(),

                //icons when jump
                //icon like
                whichIconUserChoose == 1 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          scale: this.zoomIconWhenRelease.value,
                          child: Image.asset(
                            "assets/like.gif",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        margin: EdgeInsets.only(
                            top: processTopPosition(
                                this.moveUpIconWhenRelease.value),
                            left: this.moveLeftIconLikeWhenRelease.value),
                      )
                    : Container(),

                // Icon love
                whichIconUserChoose == 2 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/love.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconLoveWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon haha
                whichIconUserChoose == 3 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/haha.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconHahaWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon Wow
                whichIconUserChoose == 4 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/wow.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconWowWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon sad
                whichIconUserChoose == 5 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/sad.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconSadWhenRelease.value,
                        ),
                      )
                    : Container(),

                // Icon angry
                whichIconUserChoose == 6 && !isDragging
                    ? Container(
                        child: Transform.scale(
                          child: Image.asset(
                            'assets/angry.gif',
                            width: 40.0,
                            height: 40.0,
                          ),
                          scale: this.zoomIconWhenRelease.value,
                        ),
                        margin: EdgeInsets.only(
                          top: processTopPosition(
                              this.moveUpIconWhenRelease.value),
                          left: this.moveLeftIconAngryWhenRelease.value,
                        ),
                      )
                    : Container(),
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
          //icon like
          Transform.scale(
            scale: isDragging
                ? (currentIconFocus == 1
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 1
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconLike.value,
            child: Container(
              margin: EdgeInsets.only(bottom: pushIconLikeUp.value, left: 4),
              width: 40.0,
              height: currentIconFocus == 1 ? 70.0 : 40.0,
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
          ),

          // icon love
          Transform.scale(
            child: Container(
              margin: EdgeInsets.only(bottom: pushIconLoveUp.value, left: 4),
              width: 40.0,
              height: currentIconFocus == 2 ? 70.0 : 40.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 2
                      ? Container(
                          child: Text(
                            'Love',
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
                    'assets/love.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            scale: isDragging
                ? (currentIconFocus == 2
                    ? this.zoomIconChosen.value
                    : (previousIconFocus == 2
                        ? this.zoomIconNotChosen.value
                        : isJustDragInside
                            ? this.zoomIconWhenDragInside.value
                            : 0.8))
                : isDraggingOutside
                    ? this.zoomIconWhenDragOutside.value
                    : this.zoomIconLove.value,
          ),

          // icon haha
          Transform.scale(
            child: Container(
              margin: EdgeInsets.only(bottom: pushIconHahaUp.value, left: 4),
              width: 40.0,
              height: currentIconFocus == 3 ? 70.0 : 40.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 3
                      ? Container(
                          child: Text(
                            'Haha',
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
                    'assets/haha.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            scale: isDragging
                ? (currentIconFocus == 3
                ? this.zoomIconChosen.value
                : (previousIconFocus == 3
                ? this.zoomIconNotChosen.value
                : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconHaha.value,
          ),

          // icon wow
          Transform.scale(
            child: Container(
              margin: EdgeInsets.only(bottom: pushIconWowUp.value, left: 4),
              width: 40.0,
              height: currentIconFocus == 4 ? 70.0 : 40.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 4
                      ? Container(
                          child: Text(
                            'Wow',
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
                    'assets/wow.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            scale: isDragging
                ? (currentIconFocus == 4
                ? this.zoomIconChosen.value
                : (previousIconFocus == 4
                ? this.zoomIconNotChosen.value
                : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconWow.value,
          ),

          // icon sad
          Transform.scale(
            child: Container(
              margin: EdgeInsets.only(bottom: pushIconSadUp.value, left: 4),
              width: 40.0,
              height: currentIconFocus == 5 ? 70.0 : 40.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 5
                      ? Container(
                          child: Text(
                            'Sad',
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
                    'assets/sad.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            scale: isDragging
                ? (currentIconFocus == 5
                ? this.zoomIconChosen.value
                : (previousIconFocus == 5
                ? this.zoomIconNotChosen.value
                : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconSad.value,
          ),

          // icon angry
          Transform.scale(
            child: Container(
              margin: EdgeInsets.only(bottom: pushIconAngryUp.value, left: 4),
              width: 40.0,
              height: currentIconFocus == 6 ? 70.0 : 40.0,
              child: Column(
                children: <Widget>[
                  currentIconFocus == 6
                      ? Container(
                          child: Text(
                            'Angry',
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
                    'assets/angry.gif',
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            scale: isDragging
                ? (currentIconFocus == 6
                ? this.zoomIconChosen.value
                : (previousIconFocus == 6
                ? this.zoomIconNotChosen.value
                : isJustDragInside ? this.zoomIconWhenDragInside.value : 0.8))
                : isDraggingOutside ? this.zoomIconWhenDragOutside.value : this.zoomIconAngry.value,
          ),
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
    if (!_isLongPress && _isLike) {
      return 'assets/ic_like_fill.png';
    } else if (!isDragging) {
      switch (whichIconUserChoose) {
        case 1:
          return 'assets/ic_like_fill.png';
        case 2:
          return 'assets/love2.png';
        case 3:
          return 'assets/haha2.png';
        case 4:
          return 'assets/wow2.png';
        case 5:
          return 'assets/sad2.png';
        case 6:
          return 'assets/angry2.png';
        default:
          return 'assets/ic_like.png';
      }
    } else {
      return 'assets/ic_like.png';
    }
  }

  Color getColorBorderBtn() {
    if ((!_isLongPress && _isLike)) {
      return Color(0xff3b5998);
    } else if (!isDragging) {
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

    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  void showBow() {
    print("showBow");

    playSound('box_up.mp3');
    _isLongPress = true;

    _animControlBtnLongPress.forward();

    setForwardValue();
    animControlBox.forward();
  }

  //when user end dragging
  void onHorizontalDragEndBoxIcon(DragEndDetails details) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    onTapUpBtn(null);
  }

  //when user moves their fingers
  void onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    // return if the drag is drag without press button
    if (!_isLongPress) return;

    // the margin top the box is 150
    // and plus the height of toolbar and the status bar
    // so the range we check is about 200 -> 500

    if (dragUpdateDetail.globalPosition.dy >= 200 &&
        dragUpdateDetail.globalPosition.dy <= 500) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      if (dragUpdateDetail.globalPosition.dx >= 20 &&
          dragUpdateDetail.globalPosition.dx < 83) {
        if (currentIconFocus != 1) {
          handleWhenDragBetweenIcon(1);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 83 &&
          dragUpdateDetail.globalPosition.dx < 126) {
        if (currentIconFocus != 2) {
          handleWhenDragBetweenIcon(2);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 126 &&
          dragUpdateDetail.globalPosition.dx < 180) {
        if (currentIconFocus != 3) {
          handleWhenDragBetweenIcon(3);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 180 &&
          dragUpdateDetail.globalPosition.dx < 233) {
        if (currentIconFocus != 4) {
          handleWhenDragBetweenIcon(4);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 233 &&
          dragUpdateDetail.globalPosition.dx < 286) {
        if (currentIconFocus != 5) {
          handleWhenDragBetweenIcon(5);
        }
      } else if (dragUpdateDetail.globalPosition.dx >= 286 &&
          dragUpdateDetail.globalPosition.dx < 340) {
        if (currentIconFocus != 6) {
          handleWhenDragBetweenIcon(6);
        }
      }
    } else {
      whichIconUserChoose = 0;
      previousIconFocus = 0;
      currentIconFocus = 0;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void handleWhenDragBetweenIcon(int currentIcon) {
    playSound('icon_focus.mp3');
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
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

  double processTopPosition(double value) {
    if (value >= 120.0) {
      return value - 80.0;
    } else {
      return 160.0 - value;
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
