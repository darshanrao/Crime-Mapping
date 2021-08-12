import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestingProfile extends StatefulWidget {
  static String id = 'Testing Profile';
  @override
  _TestingProfileState createState() => _TestingProfileState();
}

class _TestingProfileState extends State<TestingProfile> {
  File sampleImage;
  String photoUrl;
  void initState() {
    super.initState();
    getUrl().then((value) {
      photoUrl = value;
      print(photoUrl);
    });
  }

  Future getImage() async {
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      print(tempImage.path);
      sampleImage = File(tempImage.path);
    });
    print('done image picking');
    // await uploadImage(profileImage);
  }

  Future<String> getUrl() async {
    return await FirebaseStorage.instance
        .ref()
        .child('Test')
        .child('test1234.jpg')
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(photoUrl);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: [
          sampleImage == null
              ? Text('Select An Image')
              : Image.file(
                  sampleImage,
                  height: 300,
                  width: 300,
                ),
          RaisedButton(
            elevation: 7,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () async {
              getImage().whenComplete(() {
                final Reference firebaseStorageRef = FirebaseStorage.instance
                    .ref()
                    .child('Test')
                    .child('test123.jpg');
                UploadTask task = firebaseStorageRef.putFile(sampleImage);
              });
            },
          ),
          RaisedButton(
            elevation: 7,
            child: Text('getUrl'),
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () async {
              photoUrl = await FirebaseStorage.instance
                  .ref()
                  .child('Test')
                  .child('test123.jpg')
                  .getDownloadURL();
            },
          )
        ],
      ),
    );
  }
}
