part of 'gps_bloc.dart';

class GpsState extends Equatable {
  
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;

  bool get isAllGranted => isGpsEnabled && isGpsPermissionGranted;
  
  const GpsState({
   required this.isGpsEnabled,
   required this.isGpsPermissionGranted
  });
  
 // se hace una copia de GpsEstate con el fin de poder adquirir los valores que ya tenia por si alguno no cambia
  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
  }) => GpsState(
    isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled, // si gpsEnabled cambio use isGpsEnable si no utilice el valor que tenia
    isGpsPermissionGranted: isGpsPermissionGranted ?? this.isGpsPermissionGranted,
  );

  @override
  List<Object> get props => [ isGpsEnabled, isGpsPermissionGranted ]; // permite que equatable determine si estas propiedades han cambiado su estado 

  @override
  String toString() => '{ isGpsEnabled:  $isGpsEnabled  | isGpsPermissionGranted: $isGpsPermissionGranted}';

}



