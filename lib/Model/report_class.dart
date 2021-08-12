import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

class Report {
  String photoUrl;
  int caseId;
  String crimeType;
  DateTime datetime;
  String description;
  String email;
  int emerPhoneNo;
  String gender;
  String homeAddress;
  int phoneNo;
  LatLng location;
  String name;
  String locDesc;
}
