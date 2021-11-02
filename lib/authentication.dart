import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  BuildContext context;
  final _codeController = TextEditingController();
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  AuthenticationService(this._firebaseAuth, this.context);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Future phoneAuth(String phone) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Provide the CODE SENT'),
                  content: Column(
                    children: [
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () async {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: _codeController.text.trim());
                          await _firebaseAuth.signInWithCredential(credential);
                          Navigator.pop(context);
                        },
                        child: Text("Verify"))
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String test) {});
  }

  Future signInwithFacebook() async {
    try {
      final facebookLoginUser = await FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]);
      if (facebookLoginUser == null) {
        print("No User");
        return;
      }
      final AuthCredential credential =
          FacebookAuthProvider.credential(facebookLoginUser.accessToken!.token);
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  Future<String?> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.emailVerified) {
        return "Signed In";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      credential.user!.sendEmailVerification();
      await _firebaseAuth.signOut();
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    if (_user != null) {
      googleSignIn.disconnect();
    }
    await _firebaseAuth.signOut();
  }
}
