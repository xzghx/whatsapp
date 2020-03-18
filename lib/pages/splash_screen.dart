import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/services/AuthService.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

//  startTimer() {
//    var _duration = new Duration(seconds: 1);
//    return new Timer(_duration, navigateToFirstPage);
//  }

  checkLogin() async {
    //if user's data in not stored in preferences go to login page
    SharedPreferences pref = await SharedPreferences.getInstance();
    String apiToken = pref.getString("user.apiToken");
    navigateToHome();
//    if (apiToken == null) Navigator.pushReplacementNamed(context, "/login");
    //if has connection to internet should check stored user's apiKey in server
    if (await checkInternetConnection()) {
      await AuthService.checkUserApi(apiToken)
          ? navigateToHome()
          : navigateToLogin();
    }
    //doesn't have connection to internet
    else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(minutes: 2),
        content: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("اتصال اینترنت برقرار نیست"),
              new Icon(Icons.wifi)
            ],
          ),
          onTap: () {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            checkLogin();
          },
        ),
      ));
    }
  }

  void navigateToLogin() {
//    Navigator.of(context).pushNamed('/');
//    Navigator.pushNamed(context, '/');
    Navigator.pushReplacementNamed(context, '/login');
//    Navigator.push(context, MaterialPageRoute(builder: (context) => new LoginScreen(),));
  }

  void navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<bool> checkInternetConnection() async {
    ConnectivityResult result = await (new Connectivity().checkConnectivity());

    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
  }

  @override
  void initState() {
    super.initState();
//    startTimer();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: new Color(0xff075e54),
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/whatsapp_icon.png")),
                  ),
                ),
                new Text(
                  "واتساپ",
                  style: TextStyle(
                      fontWeight: FontWeight.w900, fontFamily: "nazaninFamily"),
                ),
              ],
            ),
            new Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: new CircularProgressIndicator(),
              ),
            )
          ],
        ));
  }
}
