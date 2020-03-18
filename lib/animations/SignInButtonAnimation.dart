import 'package:flutter/material.dart';

class SignInButtonAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> buttonSqueezing; //فشرده شدن دکمه reduce width
  final Animation<double> buttonZoomOut; //increase width and height

  SignInButtonAnimation({@required this.controller})
      : buttonSqueezing = Tween(
                //change button width from initial value(230) to 280 to 60
                begin: 280.0,
                end: 60.0)
            .animate(new CurvedAnimation(
                parent: controller, curve: new Interval(0.0, 0.150))),
        buttonZoomOut = Tween(begin: 70.0, end: 1000.0).animate(
            new CurvedAnimation(
                parent: controller,
                curve: new Interval(0.550, 0.999, curve: Curves.bounceOut)));

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: controller, builder: _animationBuilder);
  }

  Widget _animationBuilder(BuildContext context, Widget child) {
    return buttonZoomOut.value <= 300
        //if <300 show button else show shape(first show circle then show squre)
        ? new Container(
            width: buttonZoomOut.value == 70
                ? buttonSqueezing.value
                : buttonZoomOut.value,
            height: buttonZoomOut.value == 70 ? 60 : buttonZoomOut.value,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                color: Color(0xff8980d4),
                border: Border.all(width: 3, color: Color(0xffeaceea)),
                borderRadius: buttonZoomOut.value <= 400
                    ? BorderRadius.all(Radius.circular(30))
                    : BorderRadius.all(Radius.circular(0))),
            child: buttonSqueezing.value > 75
                ? new Text(
                    "ورود",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  )
                : buttonZoomOut.value < 200
                    ? new CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : null)
        : new Container(
            width: buttonZoomOut.value,
            height: buttonZoomOut.value,
            decoration: BoxDecoration(
                color: Color(0xff8980d4),
                shape: buttonZoomOut.value <= 500
                    ? BoxShape.circle
                    : BoxShape.rectangle),
          );
  }
}