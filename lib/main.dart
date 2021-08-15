import 'package:crimemapping/Screens/profile_settings_screen.dart';
import 'package:crimemapping/Screens/Welcome_screen.dart';
import 'package:crimemapping/Screens/login_screen.dart';
import 'package:crimemapping/Screens/signup_screen.dart';
import 'package:crimemapping/testingprofile.dart';
// import 'package:crimemapping/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'Screens/home_screen.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData(fontFamily: 'WorkSans'),
      // theme: ThemeData.dark(fontFamily: 'Roboto Regular').copyWith(fontFamily: 'Roboto Regular'),
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'WorkSans',
            ),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'WorkSans',
            ),
        accentTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'WorkSans',
            ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'WorkSans',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreenSawo.id: (context) => HomeScreenSawo(),
        HomeScreen.id: (context) => HomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
    );
  }
}
