import 'package:crimemapping/Screens/profile_settings_screen.dart';
import 'package:crimemapping/Widgets/button_tile.dart';
import 'package:crimemapping/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../palette.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static String id = 'Sign Up Screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email;
  String password1;
  String password2;
  bool passwordBool1 = true;
  bool passwordBool2 = true;
  @override
  void initState() {
    // TODO: implement initState
    passwordBool1 = true;
    passwordBool2 = true;
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
                            'Sign Up',
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
                              password1 = value;
                            },
                            obscureText: passwordBool1,
                            cursorColor: kPrimaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Password',
                              suffixIcon: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    passwordBool1 =
                                        passwordBool1 ? false : true;
                                  });
                                },
                                icon: passwordBool1
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
                          child: TextField(
                            onChanged: (value) {
                              password2 = value;
                            },
                            obscureText: passwordBool2,
                            cursorColor: kPrimaryColor,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Password',
                              suffixIcon: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    passwordBool2 =
                                        passwordBool2 ? false : true;
                                  });
                                },
                                icon: passwordBool2
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
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password1,
                                  );
                                  if (userCredential.user != null) {
                                    Navigator.pushNamed(
                                        context, ProfileScreen.id);
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    _showMyDialogSignUp(getMessage(3));
                                  } else if (e.code == 'email-already-in-use') {
                                    _showMyDialogSignUp(getMessage(4));
                                  } else if (e.code == 'invalid-email') {
                                    _showMyDialogSignUp(getMessage(5));
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                _showMyDialogSignUp(getMessage(passError()));
                              }
                            },
                            text: 'Continue',
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
    if (password1 == null || password2 == null || email == null) {
      passError = 1;
    } else if (password1 != password2) {
      passError = 2;
    } else if (password1.length < 6 || password2.length < 6) {
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
        errorText = 'Enter All the Credentials';
        break;
      case 2:
        errorText = 'Passwords do not match';
        break;
      case 3:
        errorText = 'Weak Password';
        break;
      case 4:
        errorText = 'Email Already In Use';
        break;
      case 5:
        errorText = 'Invalid Email';
        break;
    }
    return errorText;
  }

  Future<void> _showMyDialogSignUp(String input) async {
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
