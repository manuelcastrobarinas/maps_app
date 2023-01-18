import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_app/blocs/blocs.dart';

//TODO: HACER CONFIGURACION MAPAS IOS
class MapView extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapView({
    super.key, 
    required this.initialLocation, 
    required this.polylines,
    required this.markers
  });

  @override
  Widget build(BuildContext context) {
    
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final CameraPosition initialCameraPosition = CameraPosition(target: initialLocation, zoom: 15);

    final dimension = MediaQuery.of(context).size;
    
    return SizedBox(
      width: dimension.width,
      height: dimension.height * 0.5,
      child: Listener( // cuando yo me mueva por el mapa dejar de mover al usuario
        onPointerMove: (pointerMoveEvent) => mapBloc.add( StopFollowingUserEvent()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          polylines: polylines,     //rutas del mapa
          onMapCreated: (controller) => mapBloc.add(OnMapInitialEvent(controller)),
          onCameraMove: ( position ) => mapBloc.mapCenter = position.target, //esto se dispara cada que la camara se mueve, y obtine las cordenadas de ese lugar que se van a guardar en el map center del MapBloc
          markers: markers, //marcadores del mapa
        ),
      ),
    );
  }
}
