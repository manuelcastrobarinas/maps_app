import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  
  GoogleMapController? _mapController; //controller que permite el acceso al manejo de elementos en el mapa
  
  MapBloc() : super(const MapState()) {
    
    
    on<OnMapInitialEvent>(_onInitMap);
  }


  void _onInitMap(OnMapInitialEvent event, Emitter<MapState> emit ){

    _mapController = event.controller;
    _mapController!.setMapStyle( jsonEncode( uberMapTheme )); //creacion de temas personales del mapa
    
    emit( state.copyWith( isMapInitialized: true ));
  }

  void moveCamera(LatLng newLocation) { // seguimiento de la camara a la posicion del usuario
    final cameraUptade = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUptade);
  }

}
