import 'package:chat_online/views/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCodeDialog {
  String chatID;
  BuildContext context;

  ChatCodeDialog(BuildContext context) {
    this.context = context;
    build(context);
  }

  void _showWarning(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Chat Code"),
          content: new Text(text),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void goToChat(BuildContext context, String id) async {
    bool resp = await isValidChatID(id);
    print(resp);
    if (resp) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatScreen(id)));
    }
  }

  Future<bool> isValidChatID(String id) async {
    bool resp = false;
    var snapshot =
        Firestore.instance.collection("chatsIDs").where('id', isEqualTo: id);
    await snapshot.getDocuments().then((data) {
      if (data.documents.length > 0) {
        resp = true;
      } else {
        _showWarning(context, "Invalid Chat Code");
      }
    });
    return resp;
  }

  Future<String> build(BuildContext context) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Chat Code"),
            content: Container(
              height: 90,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Code"),
                          onChanged: (value) {
                            chatID = value;
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  chatID !=  null
                      ? goToChat(context, chatID)
                      : _showWarning(context, "Please put the Chat Code");
                },
              ),
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
