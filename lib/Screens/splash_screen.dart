import 'dart:async';

import 'package:crimemapping/Screens/home_screen.dart';
import 'package:crimemapping/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'Splash_Screen';
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool userToggle;
  @override
  void initState() {
    super.initState();
    getCurrentUser().then((value) {
      setState(() {
        userToggle = value;
      });
    });
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    userToggle ? HomeScreen() : WelcomeScreen())));
  }

  Future<bool> getCurrentUser() async {
    bool value;
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        value = true;
      } else {
        value = false;
      }
    } catch (e) {
      print(e);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackGroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(
                'images/SpotCrime-02.png',
              ),
              width: 150,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SpinKitWave(
              color: kSecondaryColor,
              size: 50,
            ),
          )
        ],
      ),
    );
  }
}
