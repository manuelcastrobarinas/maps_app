import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_app/blocs/blocs.dart';

//TODO: HACER CONFIGURACION MAPAS IOS
class MapView extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;

  const MapView({
    super.key, 
    required this.initialLocation, 
    required this.polylines
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
          polylines: polylines,
          onMapCreated: (controller) => mapBloc.add(OnMapInitialEvent(controller)),
          //TODO: Markers
          //TODO: Polylines
        ),
      ),
    );
  }
}
