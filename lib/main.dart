import 'package:flutter/material.dart';
import 'package:whatsapp/MyHome.dart';
import 'package:whatsapp/pages/LoginScreen.dart';
import 'package:whatsapp/pages/camera_screen.dart';
import 'package:whatsapp/pages/new_chat_screen.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'whatsApp',
      theme: ThemeData(
          fontFamily: "Vazir",
          primaryColor: new Color(0xff075e54),
          accentColor: new Color(0xff25d366),
          secondaryHeaderColor: Colors.purple),

//      home: new Directionality(
//          textDirection: TextDirection.rtl, child: MyHome()),
      routes: {
        // "/" means home
        //if you define the first( initial page) here
        //so declaring home:.... for scaffold is not needed.
//        "/": (context) => new Directionality(
//            textDirection: TextDirection.rtl, child: new SplashScreen()),
//        "/": (context) => new Directionality(
//            textDirection: TextDirection.rtl, child: new MapScreen()),
//        "/": (context) => new Directionality(
//            textDirection: TextDirection.rtl, child: new MapLocationScreen()),
        "/": (context) => new Directionality(
            textDirection: TextDirection.rtl, child: MyHome()),
        "/home": (context) => new Directionality(
            textDirection: TextDirection.rtl, child: MyHome()),
        "/camera": (context) => CameraScreen(),
        "/login": (context) => new Directionality(
            textDirection: TextDirection.rtl, child: LoginScreen()),
        "/new_chat": (context) => new NewChatScreen(),
      },
    );
  }
}
