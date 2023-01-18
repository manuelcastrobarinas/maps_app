import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:rutas_app/models/places_models.dart';
import 'package:rutas_app/models/route_destination.dart';
import 'package:rutas_app/services/traffic_services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  TrafficService trafficService;

  SearchBloc({
    required this.trafficService
  }) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>((event, emit) => emit( state.copyWith( displayManualMarker: true )));
    on<OnDeactivateManualMarkerEvent>((event, emit) => emit( state.copyWith( displayManualMarker: false)) );
    on<OnNewPlacesFoundEvent>((event, emit) => emit( state.copyWith( places: event.places ) ));
    on<OnSaveHistoryPlacesEvent>((event, emit) => emit( state.copyWith( history: [ event.history , ...state.history ] )));
  }


  Future<RouteDestination> getCoordenatesStartToEnd( LatLng start, LatLng end ) async {

    final trafficResponse = await trafficService.getCoordenatesStartToEnd(start, end); //peticion al endpoint para pedir las cordenadas,

    //Informacion del destino
    final endPlace = await trafficService.getInformationByCoors(end);

    final distance = trafficResponse.routes[0]!.distance; // me permite saber cual es la distancia de un lugar a otro
    final duration = trafficResponse.routes[0]!.duration; // me permite saber cuanto tiempo toma ir de un lugar a otro
    final geometry = trafficResponse.routes[0]!.geometry; // tiene las coordenadas codificadas

    final points = decodePolyline(geometry, accuracyExponent: 6); //decodificamos la polyline
    final latLngList = points.map( (coordenates) => LatLng(coordenates[0].toDouble(), coordenates[1].toDouble())).toList(); //asignamos la polyline en el orden correcto
    
    return RouteDestination(
      points  : latLngList, 
      duration: duration, 
      distance: distance,
      endPlace: endPlace,
    );
  }


  Future getPlacesByQuery( LatLng proximity, String query ) async {
    
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);
    add(OnNewPlacesFoundEvent( places: newPlaces ));
  }
}
