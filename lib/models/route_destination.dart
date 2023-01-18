import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:rutas_app/models/places_models.dart';

class RouteDestination {
  
  final List<LatLng> points; //son los puntos de la ruta
  final double duration;     //el tiempo que se demora el viaje
  final double distance;     //distancia de la ruta
  final Feature endPlace;

  RouteDestination({
    required this.points, 
    required this.duration, 
    required this.distance,
    required this.endPlace
  });
}