import 'package:flutter/material.dart';
import 'package:whatsapp/pages/map_screen.dart';
import 'package:whatsapp/pages/second_map_screen.dart';

Drawer buildDrawer(BuildContext context) {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        new DrawerHeader(
            padding: EdgeInsets.zero,
            child: new Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: <Color>[
                  const Color(0xffFDC2BA),
                  const Color(0xff71CDD6)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            )),
        new ListTile(
          title: Text(
            "نقشه",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          leading: new Icon(
            Icons.map,
            color: Colors.green,
          ),
          onTap: () {
            //to close drawer
            Navigator.pop(context);
            //open screen
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new MapScreen();
            }));
          },
        ),
        new ListTile(
          title: Text(
            "دنبال کردن مکان",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          leading: new Icon(
            Icons.location_on,
            color: Colors.green,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new MapLocationScreen();
            }));
          },
        ),
      ],
    ),
  );
}
