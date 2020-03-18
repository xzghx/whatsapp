import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/models/chat_model.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatModel data;

  ChatDetailScreen({this.data});

  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            title: new Row(
              children: <Widget>[
                new GestureDetector(
                  child: new Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
                ),
                new Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                new CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                ),
                new Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                new Text(data.name)
              ],
            ),
          ),
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(data.name),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: () {
                      return Navigator.pop(context, " چت ${this.data.name}");
                    },
                    child: new Text("بازگشت"),
                  ),
                  new SizedBox(
                    width: 10,
                  ),
                  new RaisedButton(
                    onPressed: () {},
                    child: new Text("صفحه ی بعدی"),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
