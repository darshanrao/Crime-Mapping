import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../palette.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
// final gooleSignIn = GoogleSignIn();

// showErrDialog(BuildContext context, String err) {
//   // to hide the keyboard, if it is still p
//   FocusScope.of(context).requestFocus(new FocusNode());
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("Error"),
//         content: Text(err),
//         actions: <Widget>[
//           OutlineButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("Ok"),
//           ),
//         ],
//       );
//     },
//   );
// }
Future<void> showErrDialog(BuildContext context, String input) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

// Future<bool> googleSignIn() async {
//   GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();
//
//   if (googleSignInAccount != null) {
//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;
//
//     AuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);
//
//     UserCredential result = await auth.signInWithCredential(credential);
//
//     User user = await auth.currentUser;
//     print(user.uid);
//
//     return Future.value(true);
//   }
// }

Future<User> signin(String email, String password, BuildContext context) async {
  try {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: email);
    User user = result.user;
    // return Future.value(true);
    return Future.value(user);
  } catch (e) {
    // simply passing error code as a message
    print(e.code);
    switch (e.code) {
      case 'invalid-email':
        showErrDialog(context, e.code);
        break;
      case 'wrong-password':
        showErrDialog(context, e.code);
        break;
      case 'user-not-found':
        showErrDialog(context, e.code);
        break;
      case 'user-disabled':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
    }
    return Future.value(null);
  }
}

// change to Future<FirebaseUser> for returning a user
Future<User> signUp(String email, String password, BuildContext context) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: email);
    User user = result.user;
    return Future.value(user);
    // return Future.value(true);
  } catch (error) {
    switch (error.code) {
      case 'auth/email-already-in-use':
        showErrDialog(context, "Email Already Exists");
        break;
      case 'auth/invalid-email':
        showErrDialog(context, "Invalid Email Address");
        break;
      case 'auth/weak-password':
        showErrDialog(context, "Please Choose a stronger password");
        break;
    }
    return Future.value(null);
  }
}

// Future<UserCredential> signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final AccessToken result = await FacebookAuth.instance.login();
//
//   // Create a credential from the access token
//   final FacebookAuthCredential facebookAuthCredential =
//       FacebookAuthProvider.credential(result.token);
//
//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance
//       .signInWithCredential(facebookAuthCredential);
// }

Future<void> signOutUser() async {
  User user = await auth.currentUser;
  // print(user.providerData[1].providerId);
  // if (user.providerData[1].providerId == 'google.com') {
  //   await gooleSignIn.disconnect();
  // }
  await auth.signOut();
  // return Future.value(true);
}
