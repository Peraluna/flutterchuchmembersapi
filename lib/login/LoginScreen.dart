import 'package:flutter/material.dart';
import './LandingScreen.dart';



class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.buttonAnimationController, this.user, this.pass})
  : shrinkButtonAnimation = new Tween(
    begin: 320.0,
    end: 70.0 ).animate(CurvedAnimation(
      parent: buttonAnimationController,
      curve: Interval(
        0.0, 0.150
      )
    ),
    
    ),
    zoomAnimation = new Tween(
      begin: 70.0,
      end: 900.0
      ).animate(
        CurvedAnimation(
          parent: buttonAnimationController, 
          curve: Interval(
            0.550, 
            0.999, 
            curve: Curves.bounceInOut,)
          )),
    super(key: key);

  final AnimationController buttonAnimationController;
  final Animation shrinkButtonAnimation;
  final Animation zoomAnimation;
  final String user;
  final String pass;

  Widget _buildAnimation(BuildContext context, Widget child ){
  return Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: 
        zoomAnimation.value <=300 ?
        new Container(
            alignment: FractionalOffset.center,
            width: shrinkButtonAnimation.value,
            height: 60.0,
            decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: BorderRadius.all(const Radius.circular(30.0))),
            child: shrinkButtonAnimation.value > 75 ? 
                  Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3),
                  )
                  : CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
            )
            : user=='idr' ?
            Container(
              
              width: zoomAnimation.value,
              height: zoomAnimation.value,
              decoration: BoxDecoration(
                shape: zoomAnimation.value < 600 ? BoxShape.circle : BoxShape.rectangle,
                color: Colors.red[700],
              )
              )
              : new Container(
            alignment: FractionalOffset.center,
            width: shrinkButtonAnimation.value,
            height: 60.0,
            decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: BorderRadius.all(const Radius.circular(30.0))),
            child: shrinkButtonAnimation.value > 75 ? 
                  Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3),
                  )
                  : CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
            )
            );
}
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    widget.buttonAnimationController.addListener(() {
      if(widget.zoomAnimation.isCompleted) {
        if (widget.user == 'idr') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context)=> new LandingScreen()
              )
          );
        }
      }
    });
    return new AnimatedBuilder(
      builder: widget._buildAnimation,
      animation: widget.buttonAnimationController,
    );
  }
}