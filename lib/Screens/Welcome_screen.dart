import 'package:crimemapping/Screens/signup_screen.dart';
import 'package:crimemapping/Widgets/button_tile.dart';
import 'package:crimemapping/palette.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'Welcome_Screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'images/Welcome.png',
            width: 250,
            height: 250,
          ),
          SizedBox(height: 100),
          ButtonTile(
            text: 'Login',
            onPress: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
          ButtonTile(
            text: 'Sign Up',
            onPress: () {
              Navigator.pushNamed(context, SignUpScreen.id);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Text(
                'Terms of Service & Privacy Policy',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: kSecondaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
