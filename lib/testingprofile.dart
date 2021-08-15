import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sawo/sawo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// class TestingProfile extends StatefulWidget {
//   static String id = 'Testing Profile';
//   @override
//   _TestingProfileState createState() => _TestingProfileState();
// }
//
// class _TestingProfileState extends State<TestingProfile> {
//   File sampleImage;
//   String photoUrl;
//   void initState() {
//     super.initState();
//     getUrl().then((value) {
//       photoUrl = value;
//       print(photoUrl);
//     });
//   }
//
//   Future getImage() async {
//     var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       print(tempImage.path);
//       sampleImage = File(tempImage.path);
//     });
//     print('done image picking');
//     // await uploadImage(profileImage);
//   }
//
//   Future<String> getUrl() async {
//     return await FirebaseStorage.instance
//         .ref()
//         .child('Test')
//         .child('test1234.jpg')
//         .getDownloadURL();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: enableUpload(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print(photoUrl);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget enableUpload() {
//     return Container(
//       child: Column(
//         children: [
//           sampleImage == null
//               ? Text('Select An Image')
//               : Image.file(
//                   sampleImage,
//                   height: 300,
//                   width: 300,
//                 ),
//           RaisedButton(
//             elevation: 7,
//             child: Text('Upload'),
//             textColor: Colors.white,
//             color: Colors.blue,
//             onPressed: () async {
//               getImage().whenComplete(() {
//                 final Reference firebaseStorageRef = FirebaseStorage.instance
//                     .ref()
//                     .child('Test')
//                     .child('test123.jpg');
//                 UploadTask task = firebaseStorageRef.putFile(sampleImage);
//               });
//             },
//           ),
//           RaisedButton(
//             elevation: 7,
//             child: Text('getUrl'),
//             textColor: Colors.white,
//             color: Colors.blue,
//             onPressed: () async {
//               photoUrl = await FirebaseStorage.instance
//                   .ref()
//                   .child('Test')
//                   .child('test123.jpg')
//                   .getDownloadURL();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

class HomeScreenSawo extends StatelessWidget {
  static String id = 'Testing sawo';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sawo login example'),
      ),
      body: Center(child: SelectionButton()),
    );
  }
}

class SelectionButton extends StatefulWidget {
  @override
  _SelectionButtonState createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  // sawo object
  Sawo sawo = Sawo(
    apiKey: "e783964a-f6e3-4ad1-ad3a-1dd739cddbdb",
    secretKey: "61177b80257f957f4ae134bflFqoFsbuHhhWlWIaNI7G5VvV",
  );
  // user payload
  String user = "";
  String email = 'darshan.rao120501@gmail.com';

  void payloadCallback(context, payload) {
    if (payload == null || (payload is String && payload.length == 0)) {
      payload = "Login Failed :(";
    }
    setState(() {
      user = payload;
      print(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("UserData :- $user"),
            ElevatedButton(
              onPressed: () {
                sawo.signIn(
                  context: context,
                  identifierType: 'email',
                  callback: payloadCallback,
                );
              },
              child: Text('Email Login'),
            ),
            ElevatedButton(
              onPressed: () {
                sawo.signIn(
                  context: context,
                  identifierType: 'phone_number_sms',
                  callback: payloadCallback,
                );
              },
              child: Text('Phone Login'),
            ),
          ],
        ),
      ),
    );
  }
}
