import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crimemapping/Model/police_data_model.dart';

Future<String> getJson() {
  return rootBundle.loadString('assets/police_map.json');
}

class ServicesPoliceMap {
  static Future<List<Feature>> getPoliceMap() async {
    try {
      var data = json.decode(await getJson());
      var rest = data["features"] as List;
      final List<Feature> policeMap =
          rest.map<Feature>((json) => Feature.fromJson(json)).toList();
      return policeMap;
    } catch (e) {
      return List<Feature>();
    }
  }
}
