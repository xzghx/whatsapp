import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/components/DrawerLayout.dart';
import 'package:whatsapp/pages/calls_screen.dart';
import 'package:whatsapp/pages/chat_screen.dart';
import 'package:whatsapp/pages/products_screen.dart';

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyHomeState();
  }
}

class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController myTabController;

  String _currentAppBar = "mainAppBar";
  Map<String, SliverAppBar> appBarList;

  @override
  void dispose() {
    //I'm Not Sure to Dispose or not
  myTabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myTabController =
        new TabController(initialIndex: 1, length: 4, vsync: this);
    myTabController.addListener(() {
      if (myTabController.index == 0) {
        myTabController.index = myTabController.previousIndex;
        Navigator.pushNamed(context, '/camera');
      }
    });

    SliverAppBar mainAppBar = new SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 10,
      title: new Text("واتساپ"),
      actions: <Widget>[
        new GestureDetector(
          child: new Icon(
            Icons.search,
          ),
          onTap: () {
            setState(() {
              _currentAppBar = "searchAppBar";
            });
          },
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
        new PopupMenuButton<String>(onSelected: (String choice) async {
          if (choice == "newGroup") {
            print("new group pressed");
          } else if (choice == "setting") {
            print("setting pressed");
          } else if (choice == "logout") {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.remove('user.apiToken');
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }, itemBuilder: (context) {
          return [
            new PopupMenuItem(
                value: "newGroup",
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[new Text("گروه جدید")],
                )),
            new PopupMenuItem(
                value: "setting",
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[new Text("تنظیمات")],
                )),
            new PopupMenuItem(
                value: "logout",
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[new Text("خروج از حساب")],
                )),
          ];
        })
      ],
      bottom: TabBar(
          controller: myTabController,
          indicatorColor: Colors.yellow,
          tabs: <Widget>[
            new Tab(
              icon: Icon(Icons.camera_alt),
            ),
            new Tab(
              text: "چت ها",
            ),
            new Tab(
              text: "محصولات",
            ),
            new Tab(
              text: "تماس ها",
            ),
          ]),
    );
    SliverAppBar searchedAppBar = new SliverAppBar(
      elevation: 10,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: new Color(0xff075E54),
          ),
          onTap: () {
            setState(() {
              _currentAppBar = "mainAppBar";
            });
          },
        ),
      ),
      pinned: true,
      title: new TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "جستوجو...",
            fillColor: Colors.white70),
      ),
    );
    appBarList = {"mainAppBar": mainAppBar, "searchAppBar": searchedAppBar};
  }

  Future<bool> _onWillPop() {
    return showDialog(
            context: context,
            builder: (context) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: new Text("خروج از اپلیکیشن"),
                  content: new Text(
                      "با انتخاب گزینه ی بله از اپلیکیشن خارج خواهید شد"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text(
                        "بله",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreenAccent),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "خیر",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                    )
                  ],
                ),
              );
            }) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          drawer: buildDrawer(context),
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[appBarList[_currentAppBar]];
              },
              body: _currentAppBar == "mainAppBar"
                  ? TabBarView(controller: myTabController, children: <Widget>[
                      Container(),
                      new ChatScreen(),
                      new ProductsScreen(),
                      new CallsScreen(),
                    ])
                  : new Container(
                      child: new Center(
                        child: new Text("SearchResult"),
                      ),
                    )),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/new_chat");
            },
            child: new Icon(
              Icons.comment,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
          ),
        ),
        onWillPop: _onWillPop);
  }
}
