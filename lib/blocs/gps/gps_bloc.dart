import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  
  StreamSubscription? gpsServiceSubscription;
  
  GpsBloc() : super( const GpsState( isGpsEnabled: false, isGpsPermissionGranted: false )) {
    
    on<GpsAndPermissionsEvent>((event, emit) => emit( state.copyWith(
        isGpsEnabled: event.isGpsEnabled,
        isGpsPermissionGranted: event.isGpsPermissionGranted
      )
    ));
    
    _init();
  }

  //ANDROID CONFIGURATION
  Future<void> _init() async { // se ejecuta al inicialiar la app
   

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted()
    ]);
     
    add( GpsAndPermissionsEvent(
      isGpsEnabled: gpsInitStatus[0],
      isGpsPermissionGranted: gpsInitStatus[1],
    ));
  }
 
  Future<bool> _checkGpsStatus() async { //lISTENER QUE ESTA PENDIENTE DEL CAMBIO DEL GPS
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = ( event.index == 1 ) ? true : false; //este stream funciona devolviendo  1 o 0 por ello esta evaluacion
      print('service status $isEnabled'); 
      add( GpsAndPermissionsEvent(
        isGpsEnabled: isEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted,
      ));
    });
    return isEnable;
  }


  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

     switch (status) {    
      case PermissionStatus.granted:
         add(GpsAndPermissionsEvent(isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true));
        break;

       case PermissionStatus.denied:
       case PermissionStatus.restricted:
       case PermissionStatus.limited:
       case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionsEvent(isGpsEnabled: state.isGpsEnabled , isGpsPermissionGranted: false ));
        openAppSettings();
     }
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }


  @override
  Future<void> close() { //LIMPIAR LISTENER DEL STREAM PARA EVITAR FUGA DE MEMORIA
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}