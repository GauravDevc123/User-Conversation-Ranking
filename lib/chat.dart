import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  String chatRoomId;
  Chat({required this.chatRoomId, this.userMap});

  void onMessageSend() async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic>? messages = {
        "sendBy": FirebaseAuth.instance.currentUser!.uid,
        "message": message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);

      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .set({'recent_message': message.text});
      message.clear();
    } else {
      print("enter some text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(userMap!["UserName"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: size.height / 1.25,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('chatroom')
                        .doc(chatRoomId)
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> map =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              return messages(size, map);
                            });
                      } else {
                        return Container();
                      }
                    })),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Container(
                      height: size.height / 12,
                      width: size.width / 1.5,
                      child: TextField(
                        controller: message,
                      ),
                    ),
                    IconButton(onPressed: onMessageSend, icon: Icon(Icons.send))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map["sendBy"] == FirebaseAuth.instance.currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey,
        ),
        child: Text(
          map["message"],
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
