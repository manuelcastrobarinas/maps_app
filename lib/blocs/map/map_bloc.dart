import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_app/blocs/blocs.dart';
import 'package:rutas_app/themes/themes.dart';
import 'package:flutter/material.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController?
      _mapController; //controller que permite el acceso al manejo de elementos en el mapa

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    
    on<OnMapInitialEvent>(_onInitMap);   

    on<StartFollowingUserEvent>(_onStartFollowingUser);
    on<StopFollowingUserEvent>((event, emit)  => emit( state.copyWith(isFollowUser: false) ));
    
    on<UpdateUserPolylinesEvent>( _onPolylineNewPoint );
    on<OnToggleUserRoute>((event, emit) => emit(state.copyWith( showMyRoute: !state.showMyRoute )) );
    
    locationBloc.stream.listen((locationState) {

      if ( locationState.lastKnownLocation != null ) {
        add(UpdateUserPolylinesEvent( userLocations: locationState.myLocationHistory ));
      }

      if (!state.isFollowUser) return;
      if (locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });
  }

  void _onStartFollowingUser(StartFollowingUserEvent  event, Emitter<MapState> emit) {  // evento para ejecutar acciones cuando  se inicie a seguir al usuario
    emit( state.copyWith(isFollowUser: true));
    if(locationBloc.state.lastKnownLocation == null) return ; 
      moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onInitMap(OnMapInitialEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(
        jsonEncode(uberMapTheme)); //creacion de temas personales del mapa

    emit(state.copyWith(isMapInitialized: true));
  }

  void moveCamera(LatLng newLocation) { // seguimiento de la camara a la posicion del usuario
    final cameraUptade = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUptade);
  }

  void _onPolylineNewPoint(UpdateUserPolylinesEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
      polylineId: const PolylineId('MyRoute'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap:   Cap.roundCap,
      points: event.userLocations
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['MyRoute'] = myRoute;

    emit(state.copyWith(polylines: currentPolylines));
  }
}
