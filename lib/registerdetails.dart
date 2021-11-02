import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterDetails extends StatelessWidget {
  final String uid;
  RegisterDetails(this.uid);
  TextEditingController usernameController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();
  TextEditingController hometownController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Username",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: bioController,
            decoration: InputDecoration(
              labelText: "bio",
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1, //Normal textInputField will be displayed
            maxLines: 5,
          ),
          SizedBox(height: 10),
          TextField(
            controller: hometownController,
            decoration: InputDecoration(
              labelText: "hometown",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: ageController,
            decoration: InputDecoration(
              labelText: "Age",
            ),
          ),
          SizedBox(height: 10),
          RaisedButton(
              child: Text("Register Details"),
              onPressed: () async {
                await userCollection.doc(uid).set({
                  'uid': uid,
                  'UserName': usernameController.text,
                  'hometown': hometownController.text,
                  'age': ageController.text,
                  'registration time': DateTime.now(),
                  'bio': bioController.text,
                });
              }),
        ]),
      ),
    );
  }
}
