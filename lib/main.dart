import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutas_app/blocs/blocs.dart';
import 'package:rutas_app/blocs/search/search_bloc.dart';
import 'package:rutas_app/screens/loading_screen.dart';
import 'package:rutas_app/services/traffic_services.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(create: (context) => MapBloc( locationBloc: BlocProvider.of<LocationBloc>(context) )),
        BlocProvider(create: (context) => SearchBloc( trafficService: TrafficService() )),
      ],
      child: const RoutesApp()
    )
  );
}

class RoutesApp extends StatelessWidget {
  const RoutesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}


//TODO: CONFIGURAR EL PERMISSION_HANDLER PARA IOS