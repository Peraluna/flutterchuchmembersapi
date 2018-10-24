import 'dart:async';

import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  AnimationController animationControllerScreen;
  Animation animationScreen;

  AnimationController animationControllerCover;
  Animation animationCover;

  AnimationController animationControllerProfile;
  Animation animationProfile;

  AnimationController animationControllerDetail;
  Animation animationDetail;

  AnimationController animationControllerImage;
  Animation animationImage;

  @override
  void initState() {
    super.initState();
    animationControllerScreen =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationScreen =
        Tween(begin: 1.0, end: 0.0).animate(animationControllerScreen);

    animationControllerCover =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationCover = Tween(begin: 0.0, end: 240.0).animate(CurvedAnimation(
        parent: animationControllerCover,
        curve: Interval(
          0.150,
          0.999,
          curve: Curves.bounceInOut,
        )));

    animationControllerProfile =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationProfile = Tween(begin: 0.0, end: 100.0).animate(CurvedAnimation(
        parent: animationControllerProfile,
        curve: Interval(
          0.550,
          0.999,
          curve: Curves.bounceOut,
        )));

    animationControllerDetail =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animationDetail = Tween(begin: 0.0, end: 700.0).animate(CurvedAnimation(
        parent: animationControllerDetail,
        curve: Interval(
          0.150,
          0.999,
          curve: Curves.bounceOut,
        )));

    animationControllerImage =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animationImage = Tween(begin: 0.0, end: 90.0).animate(CurvedAnimation(
        parent: animationControllerImage,
        curve: Interval(
          0.550,
          0.999,
          curve: Curves.bounceOut,
        )));

    animationControllerScreen.forward();
    animationControllerCover.forward();
    animationControllerProfile.forward();
    _delay();
  }

  Future _delay() async {
    await Future.delayed(Duration(milliseconds: 300));
    animationControllerDetail.forward();
    animationControllerImage.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: <Widget>[
          new AnimationScreen(
            animation: animationScreen,
          ),
          new AnimationCover(
            animation: animationCover,
          ),
          new AnimationProfile(
            animation: animationProfile,
          ),
          new AnimationDetail(
            animation: animationDetail,
          ),
          new AnimationImage(
            animation: animationImage,
          ),
        ],
      )),
    );
  }
}

class AnimationScreen extends AnimatedWidget {
  AnimationScreen({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      width: 900.0,
      height: 900.0,
      color: Colors.red[700].withOpacity(animation.value),
    );
  }
}

class AnimationCover extends AnimatedWidget {
  AnimationCover({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      height: animation.value,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/DSCF8546.jpeg"),
              fit: BoxFit.cover)),
    );
  }
}

class AnimationProfile extends AnimatedWidget {
  AnimationProfile({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      height: 480.0,
      child: Center(
        child: Container(
          height: animation.value,
          width: animation.value,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
              image: DecorationImage(
                image: AssetImage('assets/images/DSCF8532c.jpeg'),
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}

class AnimationDetail extends AnimatedWidget {
  AnimationDetail({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
        child: new SizedBox(
            height: animation.value,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 310.0),
                ),
                new Text(
                  "Noldy",
                  style: new TextStyle(fontSize: 24.0),
                ),
                new Text("Tutorial from : www.idrcorner.com",
                    style: new TextStyle(
                        fontSize: 16.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w300)),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Text(
                    "Learning Flutter, maybe hard at the beginning, but will be worthwhile at the end and beyond...",
                    textAlign: TextAlign.center,
                  ),
                ),
                new Divider(
                  color: Colors.black45,
                ),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Column(children: <Widget>[
                        new Text(
                          "1. Nadya",
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Text(
                          "2. Karyn",
                          textAlign: TextAlign.left,
                        ),
                        new Text(
                          "3. Ken",
                          textAlign: TextAlign.left,
                        ),
                        new Text(
                          "4. Jordan",
                          textAlign: TextAlign.left,
                        ),
                      ]),
                      new Column(children: <Widget>[
                        new Text("1. Tatiana"),
                        new Text("2. Ruby"),
                        new Text("3. Julio"),
                        new Text("4. Ray"),
                      ]),
                      new Column(children: <Widget>[
                        new Text("1. Shellin"),
                        new Text("2. Sherafina"),
                        new Text("3. Lionel"),
                        new Text("4. Juliano"),
                      ]),
                    ],
                  ),
                ),
                new Divider(
                  color: Colors.black45,
                ),
              ]),
            )));
  }
}

class AnimationImage extends AnimatedWidget {
  AnimationImage({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 555.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                width: animation.value,
                height: animation.value,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("assets/images/nadya.jpg"),
                        fit: BoxFit.cover)),
              ),
              new Container(
                width: animation.value,
                height: animation.value,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("assets/images/karyn.jpg"),
                        fit: BoxFit.cover)),
              ),
              new Container(
                width: animation.value,
                height: animation.value,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("assets/images/ken.jpg"),
                        fit: BoxFit.cover)),
              ),
              new Container(
                width: animation.value,
                height: animation.value,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("assets/images/jordan.jpg"),
                        fit: BoxFit.cover)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
