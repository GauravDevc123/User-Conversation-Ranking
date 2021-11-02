import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialpage/conversations_rating.dart';

class ConversationsPage extends StatefulWidget {
  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('chatroom').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs
                        .map((e) => ListTile(
                              title: Text(e['recent_message']),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConversationRating(
                                              chatRoomId: e.id,
                                            )));
                              },
                            ))
                        .toList(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
