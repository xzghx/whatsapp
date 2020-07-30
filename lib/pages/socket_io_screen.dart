import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp/models/chat_model.dart';

class SocketIoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SocketIoScreenState();
}

class SocketIoScreenState extends State<SocketIoScreen> {
  TextEditingController _textEditingController = new TextEditingController();

  List<ChatModel> _messages = dummyData;

  int _userId = Random().nextInt(1000);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("چت"),
        ),
        body: Stack(
          children: <Widget>[
            //background
            Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //List of Chats
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]),

                                color: _userId == _messages[index].id
                                    ? Colors.greenAccent
                                    : Colors.white70),
                            margin: EdgeInsets.all(10),
                            child: Text(_messages[index].message),
                          );
                        }),
                  ),
                ),
                //bottom typing area
                Container(
                  decoration: BoxDecoration(color: Colors.white70),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          String msg = _textEditingController.text;
                          setState(() {
                            _messages
                                .add(new ChatModel(id: _userId, message: msg));
                            _textEditingController.clear();
                          });
                        },
                        icon: Icon(Icons.send),
                        color: Colors.purple,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "تایپ کنید..."),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        color: Colors.amber,
                        icon: Icon(Icons.insert_emoticon),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}
