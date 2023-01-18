import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_app/blocs/blocs.dart';
import 'package:rutas_app/models/route_destination.dart';
import 'package:rutas_app/themes/themes.dart';
import 'package:flutter/material.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  
  final LocationBloc locationBloc; 
  GoogleMapController? _mapController; //controller que permite el acceso al manejo de elementos en el mapa
  LatLng? mapCenter; // va a guardar las coordenadas que esten en el centro del mapa al elegir la ruta, ( no se puso en el state porque no quiero que se redibujen los cambios )

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    
    on<OnMapInitialEvent>(_onInitMap);   

    on<StartFollowingUserEvent>(_onStartFollowingUser);
    on<StopFollowingUserEvent>((event, emit)  => emit( state.copyWith(isFollowUser: false) ));
    
    on<UpdateUserPolylinesEvent>( _onPolylineNewPoint );
    on<OnToggleUserRoute>((event, emit) => emit(state.copyWith( showMyRoute: !state.showMyRoute )) );
    on<OnDisplayPolylinesEvent>((event, emit) => emit( state.copyWith( polylines: event.polylines, markers: event.markers )));
    
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

  Future drawRoutePolyline( RouteDestination destination ) async {

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    
    final double distanceRoute = kms = kms / 100; //distancia en kilometros del viaje
    final double timeRoute = (destination.duration  / 60).floorToDouble(); //tiempo en minutos del viaje

    final myRoute = Polyline( //creamos la polyline
      polylineId: const PolylineId('route'),
      color: Colors.black,
      points: destination.points, //listado de posiciones de nuestra polyline
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      width: 5,
    );


    final currentPolylines = Map<String,Polyline>.from( state.polylines ); //hacemos una copia de las polylines actuales
    currentPolylines['route'] = myRoute;

    // creacion de markers
    
      //marker inicial
    final startMarker = Marker(
      markerId  : const MarkerId('start'),
      position  : destination.points[0], // le indicamos al marcador que se posicione en el primer punto de nuestra polyline
      infoWindow: InfoWindow(
        title   : 'Inicio',
        snippet : 'distancia: $distanceRoute kms, tiempo estimado $timeRoute minutos',

      )
    );

      //marker final

    final finalMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,   //le indiamos al marcador que se posicione en el ultimo punto de nuestra polyline
       infoWindow: InfoWindow(
        title   : '${destination.endPlace.text }',
        snippet : '${ destination.endPlace.placeName }',

      )
    );

    final currentMarkers = Map<String, Marker>.from( state.markers ); //creacion de copias de los markers
    currentMarkers['start'] = startMarker ; // sobreescribimos el marker que tenga ID start
    currentMarkers['end']   = finalMarker ;



    add(OnDisplayPolylinesEvent(polylines: currentPolylines, markers: currentMarkers ));
  }

  @override 
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
