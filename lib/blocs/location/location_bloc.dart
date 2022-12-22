import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
 
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  StreamSubscription<Position>? positionStream;


  LocationBloc() : super( const LocationState()) { 
    
    on<OnStartFollowingUser>((event, emit) => emit( state.copyWith(followingUser: true)));
    
    on<OnStopFollowingUser>( (event, emit) => emit( state.copyWith(followingUser: false)));

    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
        lastKnownLocation: event.newLocation,
        myLocationHistory: [ ...state.myLocationHistory, event.newLocation ]
      ));
    });
  
  }

  Future getCurrentPosition() async { //obtener posicion actual del usuario
    final position = await Geolocator.getCurrentPosition();
    add( OnNewUserLocationEvent( LatLng(position.latitude, position.longitude) ));

    if (kDebugMode) {  
      print('position : $position');
    }
  }

  void startFollowingUser() { //escuchando los cambios del aposicion del usuario
    try {
      add(OnStartFollowingUser());
      print('inicio del seguimiento del usuario');
      positionStream =  Geolocator.getPositionStream().listen((event) {
        final position = event;
        print('siguiendo la posicion del usuario : $position');
        add( OnNewUserLocationEvent( LatLng(position.latitude, position.longitude) ));
      });
    } catch (e) {
      print(e);
    }

  }


  void stopFollowingUser() {
    try {
      positionStream?.cancel();
      add(OnStopFollowingUser());
      print('deteniendo el seguimiento del usuario');
    } catch (e) {
      print(e);
    }
   
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}


//TODO: ARREGLAR EL PROBLEMA DE LAS EXEPCIONES AL ACTIVAR Y DESACTIVAR EL GPS