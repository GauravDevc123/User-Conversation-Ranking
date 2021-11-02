import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialpage/authentication.dart';
import 'package:socialpage/chat.dart';
import 'package:socialpage/conversations.dart';
import 'package:socialpage/homepage.dart';

class NewHomeScreen extends StatefulWidget {
  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  TextEditingController search = new TextEditingController();
  Map<String, dynamic>? userData;
  List<String>? conversations;
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return user1 + "_" + user2;
    } else {
      return user2 + "_" + user1;
    }
  }

  void getConversations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('chatroom').get().then((value) {
      value.docs.forEach((element) {
        conversations!.add(element.id);
      });
    });
  }

  void searchUser() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore
          .collection('users')
          .where("UserName", isGreaterThanOrEqualTo: search.text)
          .get()
          .then((value) {
        setState(() {
          userData = value.docs[0].data();
        });
      });
    } catch (e) {
      print("No user Found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.center,
            child: TextField(
              controller: search,
              decoration: InputDecoration(hintText: "Search Account"),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            onPressed: searchUser,
            child: Text("Search"),
          ),
          SizedBox(
            height: 30,
          ),
          userData != null
              ? ListTile(
                  title: Text(userData!["UserName"]),
                  subtitle: Text(userData!["hometown"]),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    String roomId = chatRoomId(
                        FirebaseAuth.instance.currentUser!.uid,
                        userData!['uid']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Chat(chatRoomId: roomId, userMap: userData)));
                  },
                )
              : Container(),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ConversationsPage()));
            },
            child: Text("View All Conversations"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text("View User Details"),
          ),
          RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
