part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isFollowUser;
  final bool showMyRoute;
  final Map<String, Polyline> polylines; 
  
  const MapState({
    this.isMapInitialized = false, 
    this.isFollowUser     = true,
    this.showMyRoute      = true,
    Map<String, Polyline>? polylines,
  }) : polylines = polylines ?? const {};
  
  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowUser    : isFollowUser   ?? this.isFollowUser, 
    polylines       : polylines      ?? this.polylines,
    showMyRoute     : showMyRoute      ?? this.showMyRoute,
  );


  @override
  List<Object> get props => [ isMapInitialized, isFollowUser, polylines, showMyRoute ];
}