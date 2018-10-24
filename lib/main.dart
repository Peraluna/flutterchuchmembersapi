import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';

import './api/UserApi.dart';
import './api/UserModel.dart';

import './MainMenuScreen.dart';
import './globals/global.dart';
import './globals/SharedPrefsHelperStatic.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'globals/functions.dart';
import './globals/SharedPrefScreen.dart';

// import './api/DomainApi.dart';
// import './api/DomainModel.dart';
//final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void main() => runApp(new MyApp());
final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Scaffold without appbar
  //final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: SafeArea(
        child: Scaffold(key: scaffoldKey, body: MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Animation<double> animationScaleDown;
  Animation<double> animationTextSizeDown;
  Animation<double> animationFadeIn;
  Animation<double> animationFadeInInput;
  Animation<double> animationMoveUp;
  Animation<double> animationRotate;
  AnimationController controllerScaler;
  AnimationController controllerRotator;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  var logoHeight = 300.0;
  var logoWidth = 300.0;

  var progressDialog;
  bool isProgressDialog = false;

  String serverAddress = "";
  UserApi userApi = new UserApi();

  @override
  void initState() {
    super.initState();

    initAnimationControllers();
    controllerScaler.forward();
    controllerScaler.addListener(() {
      setState(() {
        logoHeight = 300.0;
        logoWidth = 300.0;
      });
    });
    controllerRotator.addListener(() {
      setState(() {
        logoHeight = 300.0;
        logoWidth = 300.0;
      });
    });
    serverAddress = "Reading...";
    initPrefs();
    initUserApi();
    loadDomains();
  }

  initUserApi() async {
    await userApi.init();
  }

  initPrefs() async {
    await SharedPrefsHelperStatic.init();
  }

  @override
  void dispose() {
    controllerScaler.dispose();
    controllerRotator.dispose();

    super.dispose();
  }

  bool prefExist = false;
  getPrefs() async {
    setState(() {
      serverAddress = SharedPrefsHelperStatic.getString(PREFKEY_DOMAINURL) ??
          "Please Set Preferences...to continue";
      if (Functions.isEmpty(serverAddress)) {
        prefExist = false;
      } else {
        prefExist = true;
      }
    });
  }

  UserModel loginUser;
  getSignIn(String email, String password) async {
    setState(() {
      isProgressDialog = true;
      controllerRotator.repeat();
    });

    await userApi.login(email, password).then((UserModel user) {
      isProgressDialog = false;
      setState(() {
        controllerRotator.stop();
      });
      try {
        loginUser = user;
        SharedPrefsHelperStatic.setString(PREFKEY_TOKEN, user.token);
        _showSnackBar(context, user);
        showMainMenuScreen();
        //  showMyDialog(
        //     'Successfully signed in. User Name : ${loginUser.userName}, ');
        // showMainMenu();
      } catch (error) {
        showMyDialog("Error : $error");
      }
    }, onError: (error) {
      setState(() {
        controllerRotator.stop();
      });
      showMyDialog("Error : $error");
    });

    // await firebaseAuth
    //     .signInWithEmailAndPassword(email: user, password: pass)
    //     .then((FirebaseUser user) {
    //   print('****${user.isEmailVerified}');

    //   showMyDialog('Successfully signed in');
    // }).catchError((e) => showMyDialog('$e'));
  }

  _showSnackBar(BuildContext context, UserModel item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text(
        "Login berhasil ${item.userName} memiliki ${item.userLevel} level",
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.blue,
    );
    Scaffold.of(context).showSnackBar(objSnackbar);
  }

  showMainMenu() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainMenuScreen()));
  }

  // @override
  // void setState(VoidCallback fn) {
  //   super.setState(fn);
  // }
  Widget get widgetBackground {
    return new Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            const Color(0xFF860000),
            const Color(0xFFbf360c),
            const Color(0xFF860000)
          ], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
    );
  }

  Widget get widgetLogo {
    return new Opacity(
      opacity: animationFadeIn.value,
      child: new Container(
          alignment: Alignment(0.0, animationMoveUp.value),
          child: new Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0,
            children: <Widget>[
              new Container(
                child: new Image.asset(
                  'assets/logo.png',
                  height: animationScaleDown.value,
                  width: animationScaleDown.value,
                ),
                alignment: Alignment(0.0, animationMoveUp.value),
              ),
              new Container(
                child: Text(
                  'Anggota Bekerja',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: animationTextSizeDown.value,
                      fontFamily: 'samarn'),
                ),
                alignment: Alignment(0.0, animationMoveUp.value),
              )
            ],
          )),
    );
  }

  Widget get widgetEmail {
    return new Center(
      child: new Container(
        width: 320.0,
        height: 60.0,
        alignment: Alignment.center,
        child: TextField(
          controller: usernameController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
          decoration: InputDecoration(
            hintText: 'Username',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(4.0),
            border: new Border.all(
              color: Colors.white,
              width: 1.0,
            )),
      ),
    );
  }

  Widget get widgetPassword {
    return new Center(
      child: new Container(
        width: 320.0,
        height: 60.0,
        margin: new EdgeInsets.only(top: 150.0),
        child: TextField(
          controller: passController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          obscureText: true,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(4.0),
            border: new Border.all(
              color: Colors.white,
              width: 1.0,
            )),
      ),
    );
  }

  Widget get widgetSubmitButton {
    return new Center(
      child: new GestureDetector(
          onTap: () {
            submit();
          },
          child: new Container(
            // width: 320.0,
            // height: 60.0,
            width: 320.0,
            height: 30.0,
            alignment: Alignment.center,
            margin: new EdgeInsets.only(top: 350.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
            ),
            child: new Text(
              "Masuk",
              style: new TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          )),
    );
  }

  Widget get widgetProgress {
    return new Container(
        alignment: Alignment.center,
        color: new Color.fromARGB(150, 0, 0, 0),
        child: new Stack(alignment: Alignment.center, children: <Widget>[
          new Transform(
              alignment: FractionalOffset.center,
              transform: new Matrix4.rotationZ(-animationRotate.value / 360),
              child: new Image.asset(
                'assets/rotator.png',
                height: 150.0,
                width: 150.0,
              )),
          new Container(
              margin: const EdgeInsets.only(top: 250.0),
              child: Text(
                'Sedang cek user...',
                style: TextStyle(
                    color: Colors.white, fontSize: 30.0, fontFamily: 'samarn'),
              ))
        ]));
  }

  Widget get widgetPref {
    return Center(
        child: GestureDetector(
            onTap: () {
              // restartAnim();
              showPreferencesScreen();
            },
            child: Container(
                width: 320.0,
                height: 60.0,
                alignment: Alignment.center,
                margin: new EdgeInsets.only(top: 440.0),
                child: Text(
                  "Preferences",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ))));
  }

  showPreferencesScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SharedPrefScreen()));
  }

  showMainMenuScreen() {
    Functions.delay(1000).then((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainMenuScreen( title: "Main Menu",)));
    });
  }

  String _domainName = '';
  String _domainUrl = '';

  loadDomains() async {
    await SharedPrefsHelperStatic.init().then((_) {
      _domainName = SharedPrefsHelperStatic.getString(PREFKEY_DOMAINNAME);
      _domainUrl = SharedPrefsHelperStatic.getString(PREFKEY_DOMAINURL);
    });
  }

  Widget get widgetDomain {
    return Center(
        child: GestureDetector(
            onTap: () {
              // restartAnim();
              showPreferencesScreen();
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                alignment: Alignment.center,
                margin: new EdgeInsets.only(top: 300.0),
                child: Text(
                  "$_domainName ($_domainUrl)",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ))));
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    // Scaffold.of(context).showSnackBar( new SnackBar(backgroundColor: color, content: new Text(message)));
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        type: MaterialType.transparency,
        child: new Container(
            child: Stack(children: <Widget>[
          widgetBackground,
          widgetLogo,
          new Opacity(
              opacity: animationFadeInInput.value,
              child: new Stack(children: <Widget>[
                widgetEmail,
                widgetPassword,
                widgetDomain,
                widgetSubmitButton,
                !isProgressDialog ? new Container() : widgetProgress,
                widgetPref,
              ])),
        ]
                // This trailing comma makes auto-formatting nicer for build methods.
                )));
  }

  void submit() {
    print(usernameController.text);
    if (passController.text.isNotEmpty && usernameController.text.isNotEmpty) {
      getSignIn(usernameController.text, passController.text);
      // getSignInMock(usernameController.text, passController.text);
    } else {
      showMyDialog('Harap isi email dan password');
    }
  }

  void restartAnim() {
    setState(() {});
    controllerScaler.reverse().then((T) => controllerScaler.forward());
  }

  getSignInMock(String user, String pass) async {
    print(pass);
    setState(() {
      isProgressDialog = true;
      // controller4.forward();
      controllerRotator.repeat();
    });
    await Functions.delay(3000).then((_) {
      controllerRotator.stop();
      showMyDialog('Successfully signed in');
    });
    // Future.delayed(const Duration(milliseconds: 3000), () {}).then((_) {
    //   controllerRotator.stop();
    //   showMyDialog('Successfully signed in');
    // });
    // await firebaseAuth
    //     .signInWithEmailAndPassword(email: user, password: pass)
    //     .then((FirebaseUser user) {
    //   print('****${user.isEmailVerified}');

    //   showMyDialog('Successfully signed in');
    // }).catchError((e) => showMyDialog('$e'));
  }

  void showMyDialog(String msg) {
    setState(() {
      isProgressDialog = false;
    });

    var alert = new AlertDialog(
      content: new Stack(
        children: <Widget>[
          new Text(
            'Message',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
          new Container(
              margin: new EdgeInsets.only(top: 40.0),
              child: new Text(
                '$msg',
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.bold),
              )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text(
              'OK',
              style: TextStyle(color: const Color(0xFF860000)),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void initAnimationControllers() {
    controllerScaler = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    animationFadeIn = new Tween(begin: 0.0, end: 1.0).animate(controllerScaler);
    animationMoveUp =
        new Tween(begin: 0.0, end: -0.8).animate(controllerScaler);
    animationScaleDown =
        new Tween(begin: 300.0, end: 180.0).animate(controllerScaler);
    animationTextSizeDown =
        new Tween(begin: 50.0, end: 30.0).animate(controllerScaler);
    animationFadeInInput =
        new Tween(begin: 0.0, end: 1.0).animate(controllerScaler);
    // controller2 = new AnimationController(
    //     duration: const Duration(milliseconds: 1000), vsync: this);
    // animationMoveUp = new Tween(begin: 0.0, end: -0.8).animate(controller2);
    // animationScaleDown =
    //     new Tween(begin: 300.0, end: 180.0).animate(controller2);
    // animationTextSizeDown =
    //     new Tween(begin: 70.0, end: 40.0).animate(controller2);

    // controller3 = new AnimationController(
    //     duration: const Duration(milliseconds: 500), vsync: this);
    // animationFadeInInput = new Tween(begin: 0.0, end: 1.0).animate(controller3);

    controllerRotator = new AnimationController(
        duration: new Duration(milliseconds: 700), vsync: this);
    animationRotate =
        new Tween(begin: 0.0, end: 360.0).animate(controllerRotator);

    /*progressDialog = new AlertDialog(
      content: new Container(
        color: Colors.red,
        child: new Image.asset(
          'images/ring_design.png',
          height: 100.0,
          width: 100.0,
        ),
      ),
    );*/
  }
}
