import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_app/blocs/blocs.dart';
import 'package:rutas_app/ui/custom_snackbar.dart';
import 'package:rutas_app/views/views.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
  late GpsBloc gpsBloc = BlocProvider.of<GpsBloc>(context);

  @override
  void initState() {
    if (!gpsBloc.state.isGpsEnabled) return;
    super.initState();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    super.dispose();
    locationBloc.stopFollowingUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ButtonToggleUserRoute(),
              ButtonLocation(),
              ButtonFollow()
            ]),
        body:
            BlocBuilder<LocationBloc, LocationState>(builder: (context, stateLocation) {
          if (stateLocation.lastKnownLocation == null) return const Center(child: Text('espere porfavor...'));
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {

              Map<String, Polyline> polylines = Map.from( state.polylines );

              if ( !state.showMyRoute ) {
                polylines.removeWhere((key, value) => key == 'MyRoute');
              }

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    MapView(
                      initialLocation: stateLocation.lastKnownLocation!,
                      polylines: polylines.values.toSet(),
                    )
                  ]
                ),
              );
            },
          );
        }));
  }
}

class ButtonLocation extends StatelessWidget {
  const ButtonLocation({super.key});
  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.red[400],
        child: IconButton(
          icon: const Icon(Icons.my_location_rounded, color: Colors.white),
          onPressed: () {
            final userLocation = locationBloc.state.lastKnownLocation;

            if (userLocation != null) return mapBloc.moveCamera(userLocation);

            final snack = CustomSnackbar(
                message: 'no hay informacion del usuario disponible aun');
            ScaffoldMessenger.of(context).showSnackBar(snack);
          },
        ),
      ),
    );
  }
}

class ButtonFollow extends StatelessWidget {
  const ButtonFollow({super.key});
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.red[400],
        child: BlocBuilder<MapBloc, MapState> (
          builder: (context, state) {
            return  IconButton(
              icon: Icon(  state.isFollowUser 
                ? Icons.directions_run_rounded 
                : Icons.hail_rounded, color: Colors.white
              ),
              onPressed: () {
                mapBloc.add( StartFollowingUserEvent());
              },
            );
          },
        )
      )
    ); 
  }
}

class ButtonToggleUserRoute extends StatelessWidget {
  const ButtonToggleUserRoute({super.key});
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.red[400],
        child: IconButton(
          icon: const Icon( Icons.more_horiz_rounded),
          onPressed: () {
            mapBloc.add( OnToggleUserRoute() );
          },
        ),
      )
    ); 
  }
}


