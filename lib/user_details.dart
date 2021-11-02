import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  final String uid;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  UserDetailsPage(this.uid);
  @override
  Widget build(BuildContext context) {
    var doc = null;
    return Scaffold(
        body: Center(
      child: Column(children: [
        Expanded(
            child: StreamBuilder(
                stream: collectionReference.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Iterable<QueryDocumentSnapshot<Object?>> itr = snapshot
                        .data!.docs
                        .where((element) => element["uid"] == uid);
                    doc = itr.first;
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(doc["UserName"]),
                      SizedBox(
                        height: 60,
                      ),
                      Text(doc["hometown"]),
                      SizedBox(
                        height: 60,
                      ),
                      Text(doc["bio"]),
                      SizedBox(
                        height: 60,
                      ),
                      Text(doc["age"]),
                      SizedBox(
                        height: 60,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Back to User List"),
                      )
                    ],
                  );
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })),
      ]),
    ));
  }
}
