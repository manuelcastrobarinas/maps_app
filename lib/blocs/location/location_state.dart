part of 'location_bloc.dart';

class LocationState extends Equatable {

  final bool followingUser;
  final LatLng? lastKnownLocation;      //ultimo geolocation conocida
  final List<LatLng> myLocationHistory; //histirial de las ultimas ubicaciones

  const LocationState({
      this.followingUser = false,
      this.lastKnownLocation,
      myLocationHistory,
  }) : myLocationHistory = myLocationHistory ?? const [];
  

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnownLocation,
    List<LatLng>? myLocationHistory,
  }) => LocationState(
    followingUser     :  followingUser     ?? this.followingUser,
    lastKnownLocation :  lastKnownLocation ?? this.lastKnownLocation,
    myLocationHistory :  myLocationHistory ?? this.myLocationHistory, 
  );


  @override
  List<Object?> get props => [ followingUser, lastKnownLocation , myLocationHistory ];
}
