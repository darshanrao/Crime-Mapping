// To parse this JSON data, do
//
//     final police = policeFromJson(jsonString);

import 'dart:convert';

Police policeFromJson(String str) => Police.fromJson(json.decode(str));

String policeToJson(Police data) => json.encode(data.toJson());

class Police {
  Police({
    this.type,
    this.features,
  });

  String type;
  List<Feature> features;

  factory Police.fromJson(Map<String, dynamic> json) => Police(
        type: json["type"],
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
      };
}

class Feature {
  Feature({
    this.type,
    this.properties,
    this.geometry,
  });

  FeatureType type;
  Properties properties;
  Geometry geometry;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: featureTypeValues.map[json["type"]],
        properties: Properties.fromJson(json["properties"]),
        geometry: Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "type": featureTypeValues.reverse[type],
        "properties": properties.toJson(),
        "geometry": geometry.toJson(),
      };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  GeometryType type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: geometryTypeValues.map[json["type"]],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": geometryTypeValues.reverse[type],
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

enum GeometryType { POINT }

final geometryTypeValues = EnumValues({"Point": GeometryType.POINT});

class Properties {
  Properties({
    this.name,
    this.phone,
    this.zone,
    this.city,
  });

  String name;
  String phone;
  String zone;
  City city;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        name: json["name"],
        phone: json["phone"],
        zone: json["zone"],
        city: cityValues.map[json["city"]],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "zone": zone,
        "city": cityValues.reverse[city],
      };
}

enum City { NAVI_MUMBAI, MUMBAI, THANE }

final cityValues = EnumValues({
  "Mumbai": City.MUMBAI,
  "Navi Mumbai": City.NAVI_MUMBAI,
  "Thane": City.THANE
});

enum FeatureType { FEATURE }

final featureTypeValues = EnumValues({"Feature": FeatureType.FEATURE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
