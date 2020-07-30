import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/animations/SignInButtonAnimation.dart';
import 'package:whatsapp/components/FormContainer.dart';
import 'package:whatsapp/services/AuthService.dart';
import 'package:whatsapp/services/UserService.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController mControllerSignInButton;

  String _password;
  String _email;

  onPasswordSaved(String value) {
    _password = value;
    print(value);
  }

  onEmailSaved(String value) {
    _email = value;
    print(value);
  }

  @override
  void initState() {
    mControllerSignInButton = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    super.initState();
  }

  @override
  void dispose() {
    mControllerSignInButton.dispose();
    super.dispose();
  }

  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    timeDilation = .4;
    var deviceSize = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            const Color(0xfff2bcad),
            const Color(0xff8980d4),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            new Opacity(
              opacity: .1,
              child: new Container(
                width: deviceSize.width,
                height: deviceSize.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/gol.jpg"),
                        repeat: ImageRepeat.repeat)),
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FormContainer(
                  formKey: _formKey,
                  onEmailSaved: onEmailSaved,
                  onPasswordSaved: onPasswordSaved,
                ),
                new FlatButton(
                    onPressed: () {},
                    child: new Text(
                      "تا به حال عضو نشده اید؟ عضویت",
                      style: TextStyle(
                          letterSpacing: 0.5, fontWeight: FontWeight.w400),
                    ))
              ],
            ),
            //we need Gesture Detector to find when user clicks
            //because we are using container as a button
            new GestureDetector(
              onTap: () async {
                print(_formKey.currentState.validate());
                if (_formKey.currentState.validate()) {
                  //calling currentState.save() causes two methods
                  // onEmailSaved and onPasswordSaved for MyTextInputField happen
                  // (which are saving values into local variables here)
                  _formKey.currentState.save();
                  checkUserInServer();
                }
              },
              child: new SignInButtonAnimation(
                  controller: mControllerSignInButton.view),
            )
          ],
        ),
      ),
    );
  }

  //check login
  void checkUserInServer() async {
    await mControllerSignInButton.animateTo(0.150);

    final result = await (new AuthService())
        .checkLogin({"email": _email, "password": _password});

//    print(result);
    if (result["status"] == "success") {
      //result: {status:""  ,data:{id:"" , apiKey:""}}
      //store in shared preference
      storeUserData(result['data']);
     UserService.storeUser(result['data']);
      await mControllerSignInButton.forward();

      Navigator.pushReplacementNamed(context, "/");
    } else {
      mControllerSignInButton.reverse();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("ایمیل یا پسورد نامعتبر است"),
      ));
    }
  }

  //save data in shared preferences
  void storeUserData(Map userData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("user.apiToken", userData['api_token']);
    await pref.setInt("user.userId", userData['user_id']);
  }
}
