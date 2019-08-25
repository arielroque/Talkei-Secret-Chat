import 'package:chat_online/utils/colors.dart';
import 'package:chat_online/views/chat.dart';
import 'package:chat_online/views/chatCodeDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

void main() async {
  runApp(App());
}

final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

void saveChatID(String id) {
  Firestore.instance.collection('chatsIDs').add({'id': id});
}

void goToChat(BuildContext context) {
  String id = _generateCodeID();
  saveChatID(id);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ChatScreen(id)));
}

String _generateCodeID() {
  String chatID = googleSignIn.currentUser.id +
      DateTime.now().millisecondsSinceEpoch.toString();
  return chatID;
}

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;

  if (user == null) {
    user = await googleSignIn.signInSilently();
  }

  if (user == null) {
    user = await googleSignIn.signIn();
  }

  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;

    await auth.signInWithGoogle(
        idToken: credentials.idToken, accessToken: credentials.accessToken);
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Talkei",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? iosTheme
          : defaultTheme,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

ButtonTheme button(
    BuildContext context, String text, Color color, bool dialog) {
  return ButtonTheme(
    height: 100,
    child: RaisedButton(
      elevation: 5.0,
      onPressed: () {
        dialog == false ? goToChat(context) : ChatCodeDialog(context);
      },
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20.0, color: Colors.white),
      ),
    ),
  );
}

Container buttons(BuildContext context) {
  return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child:
                      button(context, "Create Chat", Colors.purple[300], false))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: button(
                      context, "Enter in a Chat", Colors.pinkAccent[700], true))
            ],
          )
        ],
      ));
}

class _HomeState extends State<Home> {
  _HomeState(){
    _ensureLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Talkei Chat"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 70.0),
              decoration: BoxDecoration(gradient: primaryGradient),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  buttons(context)
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
