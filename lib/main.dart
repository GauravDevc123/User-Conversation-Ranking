import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:socialpage/authentication.dart';
import 'package:socialpage/homepage.dart';
import 'package:socialpage/new_home_screen.dart';
import 'package:socialpage/registerdetails.dart';
import 'package:socialpage/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance, context),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      // Future<bool> flag = getListOfDocuments(firebaseUser.uid);
      // print("User ID: " + firebaseUser.uid);
      // print(flag);
      // if (flag == true) {
      return NewHomeScreen();
      // } else {
      //   return RegisterDetails(firebaseUser.uid);
      // }
    }
    return SignInpage();
  }

  Future<bool> getListOfDocuments(String uid) async {
    bool flag = false;
    List<String> list = [];
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((snaphot) => {
              snaphot.docs.forEach((doc) {
                list.add(doc.id);
              })
            });
    print(list);
    for (var item in list) {
      if (uid == item) {
        flag = true;
        break;
      }
    }
    return flag;
  }
}
