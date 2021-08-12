import 'dart:io';
import 'dart:math';

import 'package:crimemapping/Model/userclass.dart';
import 'package:crimemapping/Widgets/button_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../palette.dart';
import 'login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'Profile Screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTime currentPhoneDate = DateTime.now();
  String photoImageUrl;

  File profileImage;
  final _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserProfile userProfile = UserProfile();
  User loggedInUser;
  int gender;
  @override
  void initState() {
    getCurrentUser();
    userProfile.gender = 0;
    super.initState();
  }

  Future getImage() async {
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      print(tempImage.path);
      profileImage = File(tempImage.path);
    });
    print('done image picking');
    // await uploadImage(profileImage);
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        userProfile.email = loggedInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: kGradientColor,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: kGradientColor),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.zero,
                  topLeft: Radius.zero),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipOval(
                    child: profileImage == null
                        ? Image.network(
                            'https://i.imgur.com/oO6KOxx.png',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            profileImage,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                  ),
                  ButtonTile(
                    text: 'CHANGE',
                    onPress: () async {
                      getImage().whenComplete(() {
                        final Reference firebaseStorageRef = FirebaseStorage
                            .instance
                            .ref()
                            .child('Profile Images')
                            .child('${loggedInUser.email}')
                            .child('test.jpg');
                        UploadTask task =
                            firebaseStorageRef.putFile(profileImage);
                        _showMyDialogDp();
                      });
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kBackGroundColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 32),
                                child: Text('Personal Information',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              cursorColor: kSecondaryColor,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Full Name',
                              ),
                              onChanged: (value) {
                                userProfile.name = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              cursorColor: kSecondaryColor,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Mobile Number',
                              ),
                              onChanged: (value) {
                                userProfile.phoneNo = int.parse(value);
                              },
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Gender',
                                style:
                                    TextStyle(color: kTextColor, fontSize: 16),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                activeColor: kPrimaryColor,
                                groupValue: userProfile.gender,
                                onChanged: (int val) {
                                  setState(() {
                                    userProfile.gender = val;
                                  });
                                },
                              ),
                              Text(
                                'Male',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              Radio(
                                value: 2,
                                activeColor: kPrimaryColor,
                                groupValue: userProfile.gender,
                                onChanged: (int val) {
                                  setState(() {
                                    userProfile.gender = val;
                                  });
                                },
                              ),
                              Text(
                                'Female',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 32),
                                child: Text('Address',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              cursorColor: kSecondaryColor,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Home Address',
                              ),
                              onChanged: (value) {
                                userProfile.homeAddress = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              cursorColor: kSecondaryColor,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Emergency Contact No',
                              ),
                              onChanged: (value) {
                                userProfile.emerPhoneNo = int.parse(value);
                              },
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: ButtonTile(
                                onPress: () {
                                  // print(userProfile.photoUrl);
                                  print(userProfile.name);
                                  print(userProfile.email);
                                  print(userProfile.phoneNo);
                                  print(userProfile.gender);
                                  print(userProfile.homeAddress);
                                  print(userProfile.emerPhoneNo);
                                  print('FOTU:$photoImageUrl');
                                  if (passError() == 0) {
                                    _firestore.collection('user').add({
                                      'photoUrl': photoImageUrl == null
                                          ? 'https://i.imgur.com/oO6KOxx.png'
                                          : photoImageUrl,
                                      'email': userProfile.email,
                                      'emerPhoneNo': userProfile.emerPhoneNo,
                                      'gender': userProfile.gender,
                                      'homeAddress': userProfile.homeAddress,
                                      'name': userProfile.name,
                                      'phoneNo': userProfile.phoneNo,
                                    });
                                    Navigator.pushNamed(
                                        context, LoginScreen.id);
                                  } else {
                                    _showMyDialogProfile(
                                        getMessage(passError()));
                                  }
                                },
                                text: '           Save           ',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  int passError() {
    int passError;
    if (userProfile.name == null) {
      passError = 1;
    } else if (userProfile.phoneNo == null) {
      passError = 2;
    } else if (userProfile.emerPhoneNo == null) {
      passError = 3;
    } else if (userProfile.homeAddress == null) {
      passError = 4;
    } else if (userProfile.gender == 0) {
      passError = 5;
    } else if (userProfile.phoneNo < 1000000000) {
      passError = 6;
    } else if (userProfile.emerPhoneNo < 1000000000) {
      passError = 7;
    } else {
      passError = 0;
    }
    return passError;
  }

  String getMessage(int errorNo) {
    String errorText;
    switch (errorNo) {
      case 1:
        errorText = 'Enter Name';
        break;
      case 2:
        errorText = 'Enter Your Phone Number';
        break;
      case 3:
        errorText = 'Enter Emergency Phone Number';
        break;
      case 4:
        errorText = 'Enter Home Address';
        break;
      case 5:
        errorText = 'Enter Select Gender';
        break;
      case 6:
        errorText = 'Phone Number should have a least 10 numbers';
        break;
      case 7:
        errorText = 'Emergency Phone Number should have a least 10 numbers';
        break;
    }
    return errorText;
  }

  Future<void> _showMyDialogProfile(String input) async {
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

  Future<void> _showMyDialogDp() async {
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
                'Your Profile Pic Is uploaded',
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
              onPressed: () async {
                photoImageUrl = await FirebaseStorage.instance
                    .ref()
                    .child('Profile Images')
                    .child('${loggedInUser.email}')
                    .child('test.jpg')
                    .getDownloadURL();
                print(photoImageUrl);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
