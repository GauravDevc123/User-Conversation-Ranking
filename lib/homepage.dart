import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:socialpage/authentication.dart';
import 'package:socialpage/user_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: collectionReference.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs
                        .map((e) => ListTile(
                              title: Text(e['UserName']),
                              subtitle: Row(
                                children: [
                                  Text("User Ranking:"),
                                  Text(e['average_ranking'])
                                ],
                              ),
                              //trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               UserDetailsPage(e["uid"])));
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
            // RaisedButton(
            //   onPressed: () {
            //     context.read<AuthenticationService>().signOut();
            //   },
            //   child: Text("Sign Out"),
            // )
          ],
        ),
      ),
    );
  }
}
