import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:rutas_app/models/places_models.dart';
import 'package:rutas_app/models/traffic_interceptors.dart';
import 'package:rutas_app/services/interceptors/places_interceptor.dart';
import 'interceptors/traffic_interceptors.dart';



class TrafficService {
  
  final Dio _dioTraffic; //vamos a almacenar rutas de trafico,
  final Dio _dioPlaces;  //

  final String _baseTrafficUrl  = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl   = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  TrafficService() 
    : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() ), //añadimos la instancia de trafficInterceptor cuando se crea la instancia de dio en el trafic
      _dioPlaces  = Dio()..interceptors.add( PlacesInterceptor() );  //añadimos la instancia de trafficInterceptor cuando se crea la instancia de dio en los places


  Future<TrafficResponse> getCoordenatesStartToEnd( LatLng start, LatLng end ) async { // esta es la peticion para obtener la distancia de punto de inicio y punto final de una ruta
    
    final coordenatesString = '${ start.longitude },${ start.latitude };${ end.longitude },${ end.latitude }';
    final url = '$_baseTrafficUrl/driving/$coordenatesString';

    final res = await _dioTraffic.get(url);
    final data = TrafficResponse.fromMap(res.data);
    
    return  data;
  }


  Future<List<Feature>> getResultsByQuery( LatLng proximity, String query ) async {
    if( query.isEmpty ) return [];

    final url = '$_basePlacesUrl/$query.json';
    
    final resp = await _dioPlaces.get( url,queryParameters: {
      'proximity': '${proximity.longitude},${proximity.latitude}',
      'limit'    : 5
    });

    final placesResponse = PlacesResponse.fromMap( resp.data );

    return placesResponse.features; //Lugares => Features
  }


  Future<Feature> getInformationByCoors(  LatLng coors ) async {

     final url = '$_basePlacesUrl/${coors.longitude},${coors.latitude}.json';
     final res = await _dioPlaces.get( url, queryParameters: {
        'limit' : 1,
     });

     final placesResponse = PlacesResponse.fromMap( res.data );
     return placesResponse.features[0];
  }
}