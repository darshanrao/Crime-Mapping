import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimemapping/Model/heatmap_class.dart';
import 'package:crimemapping/Model/police_data_model.dart';
import 'package:crimemapping/Model/report_class.dart';
import 'package:crimemapping/Model/userclass.dart';
import 'package:crimemapping/Screens/Welcome_screen.dart';
import 'package:crimemapping/Screens/profile_settings_screen.dart';
import 'package:crimemapping/services/caseLocation.dart';
import 'package:crimemapping/services/authentication.dart';
import 'package:crimemapping/services/service_police.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import '../palette.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'Home_Screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String liveAddress;
  DateTime currentPhoneDate = DateTime.now();
  BitmapDescriptor customIcon1;
  final _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser;
  UserProfile currentUser = UserProfile();
  List<Feature> _policeMap = List<Feature>();
  final Set<Heatmap> _heatmaps = {};
  final Set<Marker> _markers = {};
  LatLng testLocation = LatLng(9.0820, 8.6750);
  String _mapStyle;
  bool mapToggle;
  bool locationToggle;
  GoogleMapController myController;
  Report report = Report();
  var currentLocation;

  _HomeScreenState();
  @override
  void initState() {
    super.initState();
    getHeatMapLatLng();
    getCurrentUser();
    setCustomMarker();
    getUserProfile().then((value) {
      setState(() {
        currentUser = value;
      });
      if (currentUser.name == null) {
        _showMyDialogProfileIncomplete('Your Profile is Incomplete');
      }
    });
    mapToggle = true;
    locationToggle = true;
    ServicesPoliceMap.getPoliceMap().then((value) {
      setState(() {
        _policeMap = value;
        mapToggle = false;
      });
    });

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        print('This is my location');
        print(currentLocation);
        locationToggle = false;
      });
    });
  }

  Future<void> setCustomMarker() async {
    customIcon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/badge_5.png');
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getAddress() async {
    print('Address');
    LatLng locat = LatLng(currentLocation.latitude, currentLocation.longitude);
    print(locat);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    print(placemarks);
    for (var place in placemarks) {
      final name = place.name;
      final subLocality = place.subLocality;
      final localityName = place.locality;
      final postalCode = place.postalCode;
      final String address = "$name, $subLocality, $localityName, $postalCode";
      print(address);
      return address;
    }
  }

  void getReportInfo() {
    setState(() {
      String stringdt;
      report.homeAddress = currentUser.homeAddress; //'
      report.name = currentUser.name; //'
      report.phoneNo = currentUser.phoneNo; //'
      report.gender = currentUser.gender == 1 ? "Male" : "Female"; //'
      report.email = currentUser.email; //'
      report.datetime = DateTime.now();
      report.emerPhoneNo = currentUser.emerPhoneNo; //'
      report.location =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      stringdt = DateTime.now().toString();
      stringdt = stringdt[2] +
          stringdt[3] +
          stringdt[5] +
          stringdt[6] +
          stringdt[8] +
          stringdt[9] +
          stringdt[11] +
          stringdt[12] +
          stringdt[14] +
          stringdt[15] +
          stringdt[17] +
          stringdt[18];
      report.caseId = int.parse(stringdt);
      report.photoUrl = currentUser.photoUrl;
    });
  }

  int flag = 0;
  @override
  Widget build(BuildContext context) {
    addMarkers();
    // print(count);
    addHeatmap();
    if (report.locDesc == null) {
      getAddress().then((value) {
        setState(() {
          print('Done addressing');
          report.locDesc = value;
          print(report.locDesc);
        });
      });
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      // floatingActionButton: FloatingActionButton(
      //   child: Text('M'),
      //   onPressed: () {
      //     setState(() {
      //       addMarkers();
      //     });
      //   },
      // ),
      body: SafeArea(
        child: Stack(children: [
          locationToggle
              ? SpinKitDoubleBounce(
                  color: kPrimaryColor,
                  size: 50,
                )
              : Scaffold(
                  floatingActionButton: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Color(0xFFFC76A1))),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => showBottomSheet(),
                      );
                      // controller.open();
                    },
                    // myController == null
                    //     ? null
                    //     : () => myController
                    //             .animateCamera(CameraUpdate.newCameraPosition(
                    //           CameraPosition(
                    //               target: LatLng(42.3601, -71.0589),
                    //               zoom: 16.0,
                    //               tilt: 30),
                    //         )),

                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'REPORT AN ISSUE',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFC76A1)),
                      ),
                    ),
                    // icon: const Icon(Icons.dangerous),
                    backgroundColor: Color(0xFF1D1D27),
                  ),
                  bottomNavigationBar: BottomAppBar(),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  body: Container(
                      child: GoogleMap(
                    zoomGesturesEnabled: true,
                    // tiltGesturesEnabled: false,
                    minMaxZoomPreference: MinMaxZoomPreference(12, 17),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    heatmaps: _heatmaps,
                    onMapCreated: (controller) {
                      controller.setMapStyle(_mapStyle);
                      setState(() {
                        myController = controller;
                        myController.setMapStyle(_mapStyle);
                      });
                    },
                    markers: _markers,
                    compassEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        zoom: 15.0),
                  )),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: kSecondaryColor,
                  width: 1,
                ),
                color: kButtonBackground,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mapToggle && locationToggle
                        ? Text(
                            'Laoding.',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFC76A1),
                                fontWeight: FontWeight.bold),
                          )
                        : RichText(
                            text: TextSpan(
                                text: '  Law',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Plus.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFFC76A1),
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                    FloatingActionButton(
                      backgroundColor: kButtonBackground,
                      onPressed: () {
                        _showMyDialog();
                      },
                      child: CircleAvatar(
                        backgroundImage: currentUser.photoUrl == null
                            ? NetworkImage('https://i.imgur.com/oO6KOxx.png')
                            : NetworkImage(currentUser.photoUrl),
                        backgroundColor: kBackGroundColor,
                        radius: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Profile',
          ),
          content: SingleChildScrollView(
              child: Column(
            children: [
              CircleAvatar(
                backgroundImage: currentUser.photoUrl == null
                    ? NetworkImage('https://i.imgur.com/oO6KOxx.png')
                    : NetworkImage(currentUser.photoUrl),
                radius: 50,
                backgroundColor: kBackGroundColor,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${currentUser.name}',
                  style: TextStyle(color: kSecondaryColor, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${currentUser.email}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${currentUser.phoneNo}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${currentUser.homeAddress}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              FlatButton(
                  onPressed: () => signOutUser().whenComplete(() =>
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                          (route) => false)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Logout',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Icon(
                        Icons.logout,
                        size: 24,
                      ),
                    ],
                  ))
            ],
          )),
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

  Future<void> _showMyDialogReport() async {
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
                'Issue Reported',
                style: TextStyle(color: kSecondaryColor, fontSize: 24),
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

  void addHeatmap() {
    setState(() {
      // for (var report in reportmap) {
      //   LatLng point =
      //       LatLng(report.location.latitude, report.location.longitude);
      _heatmaps.add(Heatmap(
          heatmapId: HeatmapId('report.id'),
          points: _createPoints(),
          radius: 50,
          visible: true,
          gradient: HeatmapGradient(
              colors: <Color>[Colors.green, Colors.yellow, Colors.red],
              startPoints: <double>[0.2, 0.6, 0.8])));
    });
  }

  int count = 0;
  _createPoints() {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    //Can create multiple points here
    int i = 0;
    for (var report in reportmap) {
      // print(report.location.longitude);
      LatLng point =
          LatLng(report.location.latitude, report.location.longitude);
      points.add(_createWeightedLatLng(point.latitude, point.longitude, 100));
      // points.add(_createWeightedLatLng(19.1639456 + (i), 72.95256810 + (i), 1));
      i++;

      // points.add(WeightedLatLng(point: report.location, intensity: 1));
    }
    print(i);

    points.add(_createWeightedLatLng(19.1639456, 72.95256810, 1));
    points.add(_createWeightedLatLng(19.1639456 - 0.0001, 72.95256810, 1));

    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  addMarkers() {
    for (var police in _policeMap) {
      LatLng point = LatLng(
          police.geometry.coordinates[1], police.geometry.coordinates[0]);
      setState(() {
        _markers.add(
          Marker(
            icon: customIcon1,
            position: LatLng(point.latitude, point.longitude),
            markerId: MarkerId(police.properties.name.toString()),
            infoWindow: InfoWindow(
                title: police.properties.name,
                snippet: police.properties.city
                    .toString()
                    .replaceAll('City.', 'City: ')),
            onTap: myController == null
                ? null
                : () =>
                    myController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(point.latitude, point.longitude),
                          zoom: 16.0,
                          tilt: 45),
                    )),
          ),
        );
      });
    }
  }

  addLocation() {
    setState(() {
      _markers.add(
        Marker(
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          markerId: MarkerId('Your Location'),
          infoWindow: InfoWindow(
            title: 'Your Location',
          ),
          onTap: () {},
        ),
      );
    });
  }

  String dropdownValue = 'Other';
  Widget showBottomSheet() {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Text(
                    'Report An Issue',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select Category',
                    style: TextStyle(color: kPrimaryColor, fontSize: 20),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFFFC76A1)),
                    underline: Container(
                      height: 2,
                      color: Color(0xFFC933EB),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        report.crimeType = dropdownValue;
                      });
                    },
                    items: <String>[
                      'Vandalism',
                      'Theft',
                      'Suicide',
                      'Corruption',
                      'Terrorism',
                      'Murder',
                      'Narcotics',
                      'Domestic abuse',
                      'Assault',
                      'Other'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Description',
                    style: TextStyle(color: kPrimaryColor, fontSize: 20),
                  ),
                ),
              ),
              Container(
                height: 150,
                width: double.infinity,
                child: TextField(
                  onChanged: (value) {
                    report.description = value;
                  },
                  decoration: InputDecoration(
                    hintText: '(Optional)',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kSecondaryColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 5, //Normal textInputField will be displayed
                  maxLines: 5, // when user presses enter it will adapt to it
                ),
              ),
              FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color(0xFFFC76A1))),
                onPressed: () {
                  getReportInfo();
                  sendToDatabase(report.caseId, report.location.latitude,
                      report.location.longitude);
                  print(report.description);
                  print(report.name);
                  print(report.gender);
                  print(report.crimeType);
                  print(report.caseId);
                  print(report.datetime);
                  print(report.phoneNo);
                  print(report.emerPhoneNo);
                  print(report.location);
                  print(report.email);
                  print(report.homeAddress);
                  print(report.photoUrl);
                  print(report.locDesc);
                  if (passError() == 0) {
                    _firestore.collection('report').add({
                      'photoUrl': report.photoUrl == null
                          ? 'https://i.imgur.com/oO6KOxx.png'
                          : report.photoUrl,
                      'datetimeNo': report.caseId,
                      'caseid': report.caseId.toString(),
                      'crimeType': report.crimeType,
                      'datetime': report.datetime,
                      'description': report.description == null
                          ? 'Description not Specfied by the User'
                          : report.description,
                      'email': report.email,
                      'emerPhoneNo': report.emerPhoneNo,
                      'gender': report.gender,
                      'homeaddress': report.homeAddress,
                      'location': GeoPoint(
                          report.location.latitude, report.location.longitude),
                      'name': report.name,
                      'phoneNo': report.phoneNo,
                      'locDesc': report.locDesc,
                    });
                    Navigator.pop(context);
                    _showMyDialogReport();
                  } else {
                    _showMyDialogReportErr(getMessage(passError()));
                  }
                },
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'REPORT',
                    style: TextStyle(fontSize: 16, color: Color(0xFFFC76A1)),
                  ),
                ),
                backgroundColor: Color(0xFF1D1D27),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int passError() {
    int passError;
    if (report.crimeType == null) {
      passError = 1;
    } else {
      passError = 0;
    }
    return passError;
  }

  String getMessage(int errorNo) {
    String errorText;
    switch (errorNo) {
      case 1:
        errorText = 'Select Crime Type';
        break;
    }
    return errorText;
  }

  Future<void> _showMyDialogReportErr(String input) async {
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

  Future<void> _showMyDialogProfileIncomplete(String input) async {
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
                Navigator.pushNamed(context, ProfileScreen.id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<UserProfile> getUserProfile() async {
    UserProfile user = UserProfile();
    final usersinfo = await _firestore.collection('user').get();
    for (var userinfo in usersinfo.docs) {
      if (userinfo.data()['email'] == loggedInUser.email) {
        // print(userinfo.data());
        user.photoUrl = userinfo['photoUrl'];
        user.name = userinfo['name'];
        user.email = userinfo['email'];
        user.phoneNo = userinfo['phoneNo'];
        user.emerPhoneNo = userinfo['emerPhoneNo'];
        user.homeAddress = userinfo['homeAddress'];
        user.gender = userinfo['gender'];
      }
    }
    return user;
  }

  final Set<HeatMapReport> reportmap = {};
  getHeatMapLatLng() async {
    final reportsinfo = await _firestore.collection('report').get();
    for (var reportinfo in reportsinfo.docs) {
      // print(reportinfo.data()['caseid']);
      setState(() {
        reportmap.add(HeatMapReport(
            location: LatLng(reportinfo.data()['location'].latitude,
                reportinfo.data()['location'].longitude),
            id: reportinfo.data()['caseid']));
      });
    }
  }
}
