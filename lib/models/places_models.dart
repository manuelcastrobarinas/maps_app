// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromMap(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

class PlacesResponse {
    PlacesResponse({
      required  this.type,
      required  this.features,
      required  this.attribution,
    });

    final String? type;
    final List<Feature> features;
    final String? attribution;

    factory PlacesResponse.fromJson(String str) => PlacesResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PlacesResponse.fromMap(Map<String, dynamic> json) => PlacesResponse(
        type: json["type"],
        features: List<Feature>.from(json["features"]!.map((x) => Feature.fromMap(x))),
        attribution: json["attribution"],
    );

    Map<String, dynamic> toMap() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toMap())),
        "attribution": attribution,
    };
}

class Feature {
    Feature({
      required  this.id,
      required  this.type,
      required  this.placeType,
      required  this.properties,
      required  this.textEs,
      required  this.placeNameEs,
      required  this.text,
      required  this.placeName,
      required  this.center,
      required  this.geometry,
      required  this.context,
      required  this.languageEs,
      required  this.language,
    });

    final String? id;
    final String? type;
    final List<String?>? placeType;
    final Properties? properties;
    final String? textEs;
    final String? placeNameEs;
    final String? text;
    final String? placeName;
    final List<double?>? center;
    final Geometry? geometry;
    final List<Context?>? context;
    final String? languageEs;
    final String? language;

    factory Feature.fromJson(String str) => Feature.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: json["place_type"] == null ? [] : List<String?>.from(json["place_type"]!.map((x) => x)),
        properties: Properties.fromMap(json["properties"]),
        textEs: json["text_es"],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        placeName: json["place_name"],
        center: json["center"] == null ? [] : List<double?>.from(json["center"]!.map((x) => x.toDouble())),
        geometry: Geometry.fromMap(json["geometry"]),
        context: json["context"] == null ? [] : List<Context?>.from(json["context"]!.map((x) => Context.fromMap(x))),
        languageEs: json["language_es"],
        language: json["language"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "place_type": placeType == null ? [] : List<dynamic>.from(placeType!.map((x) => x)),
        "properties": properties!.toMap(),
        "text_es": textEs,
        "place_name_es": placeNameEs,
        "text": text,
        "place_name": placeName,
        "center": center == null ? [] : List<dynamic>.from(center!.map((x) => x)),
        "geometry": geometry!.toMap(),
        "context": context == null ? [] : List<dynamic>.from(context!.map((x) => x!.toMap())),
        "language_es": languageEs,
        "language": language,
    };
}

class Context {
    Context({
      required  this.id,
      required  this.textEs,
      required  this.text,
      required  this.wikidata,
      required  this.languageEs,
      required  this.language,
      required  this.shortCode,
    });

    final String? id;
    final String? textEs;
    final String? text;
    final String? wikidata;
    final String? languageEs;
    final String? language;
    final String? shortCode;

    factory Context.fromJson(String str) => Context.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Context.fromMap(Map<String, dynamic> json) => Context(
        id: json["id"],
        textEs: json["text_es"],
        text: json["text"],
        wikidata: json["wikidata"],
        languageEs: json["language_es"],
        language: json["language"],
        shortCode: json["short_code"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "text_es": textEs,
        "text": text,
        "wikidata": wikidata,
        "language_es": languageEs,
        "language": language,
        "short_code": shortCode,
    };
}

class Geometry {
    Geometry({
      required  this.coordinates,
      required  this.type,
    });

    final List<double?>? coordinates;
    final String? type;

    factory Geometry.fromJson(String str) => Geometry.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        coordinates: json["coordinates"] == null ? [] : List<double?>.from(json["coordinates"]!.map((x) => x.toDouble())),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
        "type": type,
    };
}

class Properties {
    Properties({
      required  this.foursquare,
      required  this.landmark,
      required  this.address,
      required  this.category,
      required  this.maki,
      required  this.wikidata,
      required  this.shortCode,
    });

    final String? foursquare;
    final bool? landmark;
    final String? address;
    final String? category;
    final String? maki;
    final String? wikidata;
    final String? shortCode;

    factory Properties.fromJson(String str) => Properties.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        foursquare: json["foursquare"],
        landmark: json["landmark"],
        address: json["address"],
        category: json["category"],
        maki: json["maki"],
        wikidata: json["wikidata"] ,
        shortCode: json["short_code"],
    );

    Map<String, dynamic> toMap() => {
        "foursquare": foursquare,
        "landmark": landmark,
        "address": address,
        "category": category,
        "maki": maki,
        "wikidata": wikidata,
        "short_code": shortCode,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String>? get reverse {
        reverseMap ??= map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
