import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResultModel {

  final bool cancel;
  final bool manual;
  final LatLng? position; // determina si recibimos latitud y longitud;
  final String? name;
  final String? description;

  SearchResultModel({
    required this.cancel,
    required this.manual,
    this.position,
    this.name,
    this.description, 
  });

  //TODO: SABER MAS PROPIEDADES COMO, NOMBRE DEL LUGAR, DESTINO, LatIng

}