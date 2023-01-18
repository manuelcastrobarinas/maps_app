part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}


class OnMapInitialEvent extends MapEvent {

  final GoogleMapController controller;

  const OnMapInitialEvent(this.controller);
}


class StopFollowingUserEvent extends MapEvent {}

class StartFollowingUserEvent extends MapEvent {}

class UpdateUserPolylinesEvent extends MapEvent {
  final List<LatLng> userLocations;

  const UpdateUserPolylinesEvent({ required this.userLocations });
}

class OnToggleUserRoute extends MapEvent {}

class OnDisplayPolylinesEvent extends MapEvent { // dispara la polyline
  
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const OnDisplayPolylinesEvent({
    required this.polylines,
    required this.markers,
  });

}