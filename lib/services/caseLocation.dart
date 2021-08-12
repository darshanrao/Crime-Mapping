import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

//final _firestore = FirebaseFirestore.instance;

Future<void> sendToDatabase(caseId, locationlatitude, locationlongitude) async {
  final caseLocation =
      '\n$caseId' + ',' + '$locationlatitude' + ',' + '$locationlongitude';

  String downloadURL = await firebase_storage.FirebaseStorage.instance
      .ref('caseDatabase/ReportDB.csv')
      .getDownloadURL();

  final http.Response downloadData = await http.get(Uri.parse(downloadURL));

  print(downloadData.body);
  final uploadData = '${downloadData.body}' + '$caseLocation';
  print(uploadData);
  await firebase_storage.FirebaseStorage.instance
      .ref('caseDatabase/ReportDB.csv')
      .putString(uploadData, format: firebase_storage.PutStringFormat.raw);

  // final Reference firebaseStorageRef = FirebaseStorage.instance
  //     .ref('caseDatabase/ReportDB.csv')
  //     .putString(dataUrl, format: firebase_storage.PutStringFormat.dataUrl);
}
