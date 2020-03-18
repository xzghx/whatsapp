import 'package:flutter/material.dart';
import 'package:whatsapp/models/chat_model.dart';
import 'package:whatsapp/pages/chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          return new Column(
            children: <Widget>[
              new GestureDetector(
                onTap: () => openChatDetailScreen(dummyData[index], context),
                child: new ListTile(
                  title: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(dummyData[index].name),
                      Text(dummyData[index].time),
                    ],
                  ),
                  subtitle: Container(
                    child: Text(
                      dummyData[index].message,
                      style: TextStyle(color: Colors.grey),
                    ),
                    padding: EdgeInsets.only(top: 5),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    backgroundImage: NetworkImage(dummyData[index].avatarUrl),
                  ),
                ),
              ),
              new Divider(
                height: 10,
                color: Colors.green,
              ),
            ],
          );
        });
  }

  openChatDetailScreen(ChatModel selectedChat, BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new ChatDetailScreen(data: selectedChat)));




    Scaffold.of(context).showSnackBar(new SnackBar(content: Text(result)));
  }
}
