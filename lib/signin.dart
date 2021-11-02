// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialpage/authentication.dart';

class SignInpage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                RaisedButton(
                    child: Text("Sign In"),
                    onPressed: () {
                      context.read<AuthenticationService>().signIn(
                          emailController.text.trim(),
                          passwordController.text.trim());
                    }),
                SizedBox(height: 10),
                RaisedButton(
                    child: Text("Sign Up with Phone"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                children: [
                                  TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      labelText: "Enter Phone Number",
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      final provider =
                                          Provider.of<AuthenticationService>(
                                                  context,
                                                  listen: false)
                                              .phoneAuth(
                                                  phoneController.text.trim());
                                    },
                                    child: Text("Send OTP")),
                              ],
                            );
                          });
                    }),
                SizedBox(height: 10),
                RaisedButton(
                    child: Text("Sign In with Google"),
                    onPressed: () {
                      final provider = Provider.of<AuthenticationService>(
                              context,
                              listen: false)
                          .googleLogin();
                    }),
                SizedBox(height: 10),
                RaisedButton(
                    child: Text("Sign In as Guest"),
                    onPressed: () {
                      final provider = Provider.of<AuthenticationService>(
                              context,
                              listen: false)
                          .signInAnonymously();
                    }),
                SizedBox(height: 10),
                RaisedButton(
                    child: Text("Sign In with Facebook"),
                    onPressed: () {
                      final provider = Provider.of<AuthenticationService>(
                              context,
                              listen: false)
                          .signInwithFacebook();
                    }),
                SizedBox(height: 40),
                Text(
                  'Or Register',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: signupEmailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: signupPasswordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
                Text(
                  'You will receive a email for verification.' +
                      '\n'
                          'Verify email and sign in.',
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                RaisedButton(
                    child: Text("Sign Up"),
                    onPressed: () {
                      context.read<AuthenticationService>().signUp(
                          signupEmailController.text.trim(),
                          signupPasswordController.text.trim());
                    }),
              ])
            ],
          ),
        ));
  }
}
