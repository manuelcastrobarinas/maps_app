import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutas_app/blocs/blocs.dart';
import 'package:rutas_app/ui/custom_snackbar.dart';
import 'package:rutas_app/views/views.dart';


class MapScreen extends StatefulWidget {
const MapScreen({ Key? key }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
  late GpsBloc      gpsBloc = BlocProvider.of<GpsBloc>(context);

  @override
  void initState() {
    if (!gpsBloc.state.isGpsEnabled) return ;
    super.initState();
    locationBloc.startFollowingUser();
  }


  @override
  void dispose() {
    
    super.dispose();
    locationBloc.stopFollowingUser();

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
     floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
         ButtonLocation(),
      ]
      ),
     body:  BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {

        if( state.lastKnownLocation == null ) return const Center(child: Text('espere porfavor...'));
        return SingleChildScrollView(
          child: Stack(
            children: [
              MapView( initialLocation: state.lastKnownLocation! )
          ]),
        );
     })
    );
  }
}

class ButtonLocation extends StatelessWidget {

  const ButtonLocation({super.key});
  @override
  Widget build(BuildContext context) {
    
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc      = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.red[400],
        child: IconButton(   
          icon: const Icon(Icons.my_location_rounded, color:  Colors.white),
          onPressed: () {
            
            final userLocation = locationBloc.state.lastKnownLocation;

            if (userLocation != null) return mapBloc.moveCamera(userLocation);
              
            final snack = CustomSnackbar(message: 'no hay informacion del usuario disponible aun');
            ScaffoldMessenger.of(context).showSnackBar(snack);  
          },  
        ),
      ),
    );
  }
}