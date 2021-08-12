import 'package:crimemapping/Screens/signup_screen.dart';
import 'package:crimemapping/Widgets/button_tile.dart';
import 'package:crimemapping/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../palette.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool passwordBool = true;
  @override
  void initState() {
    // TODO: implement initState
    passwordBool = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 0.35 * height,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: kGradientColor)),
              ),
              Container(
                color: kBackGroundColor,
                height: 0.65 * height,
                width: double.infinity,
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 8),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value;
                            },
                            cursorColor: kPrimaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Email Address',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: passwordBool,
                            cursorColor: kPrimaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Password',
                              suffixIcon: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    passwordBool = passwordBool ? false : true;
                                  });
                                },
                                icon: passwordBool
                                    ? Icon(
                                        CupertinoIcons.eye_slash_fill,
                                        size: 16,
                                        color: kPrimaryColor,
                                      )
                                    : Icon(
                                        CupertinoIcons.eye_fill,
                                        size: 16,
                                        color: kPrimaryColor,
                                      ),
                                label: SizedBox(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: ButtonTile(
                            onPress: () async {
                              if (passError() == 0) {
                                try {
                                  final UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (userCredential.user != null) {
                                    print(userCredential.user);
                                    Navigator.pushNamed(context, HomeScreen.id);
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    _showMyDialogLogin(getMessage(4));
                                  } else if (e.code == 'wrong-password') {
                                    _showMyDialogLogin(getMessage(5));
                                  } else if (e.code == 'invalid-email') {
                                    _showMyDialogLogin(getMessage(6));
                                  }
                                }
                              } else {
                                _showMyDialogLogin(getMessage(passError()));
                              }
                            },
                            text: 'Login',
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 24),
                        //   child: Center(
                        //       child: Text(
                        //     'Forgot Password?',
                        //     style: TextStyle(
                        //       color: kTextColor,
                        //     ),
                        //   )),
                        // ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, SignUpScreen.id);
                                },
                                child: Text(
                                  'Sign up !',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }

  int passError() {
    int passError;
    if (email == null && password == null) {
      passError = 1;
    } else if (email == null && password != null) {
      passError = 2;
    } else if (password == null && email != null) {
      passError = 3;
    } else {
      passError = 0;
    }
    return passError;
  }

  String getMessage(int errorNo) {
    String errorText;
    switch (errorNo) {
      case 1:
        errorText = 'Enter Credentials';
        break;
      case 2:
        errorText = 'Enter Email';
        break;
      case 3:
        errorText = 'Enter password';
        break;
      case 4:
        errorText = 'User Not Found';
        break;
      case 5:
        errorText = 'Wrong Password';
        break;
      case 6:
        errorText = 'Invalid Email';
        break;
    }
    return errorText;
  }

  Future<void> _showMyDialogLogin(String input) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                input,
                style: TextStyle(color: kSecondaryColor, fontSize: 16),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: kSecondaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
