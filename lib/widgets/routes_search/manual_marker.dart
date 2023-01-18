import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutas_app/blocs/blocs.dart';
import 'package:rutas_app/helpers/show_loading_message.dart';

import '../../blocs/search/search_bloc.dart';


class ManualMarkerComponent extends StatelessWidget {
  const ManualMarkerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) { //si el estado del marcador manual esta en true desplegamos el marcador manual
        return state.displayManualMarker 
          ? const _ManualMarkerBody()
          : const SizedBox();
      },
    );
  }
}


class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody();

  @override
  Widget build(BuildContext context) {
    
    final searchBloc    = BlocProvider.of<SearchBloc>(context); //para enviar las coordenadas
    final locationBloc  = BlocProvider.of<LocationBloc>(context);
    final mapBloc       = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [

          Positioned(
            top : 40,
            left: 20,
            child: FadeInLeft(
              delay: const Duration(milliseconds: 400),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,),
                  onPressed: () {
                    final searchBloc = BlocProvider.of<SearchBloc>(context);
                    searchBloc.add( OnDeactivateManualMarkerEvent() );
                  }, 
                ),
              ),
            ) 
          ),

          Center(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: BounceInDown(
                from: 100,
                child: const Icon(Icons.location_history_rounded, size: 50)
              ),
            )
          ),

          Positioned(
            bottom: 10,
            right : 40,
            left  : 40,
            child: FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: MaterialButton(
                color: Colors.black,
                elevation: 5,
                minWidth: MediaQuery.of(context).size.width,
                height: 35,
                shape: const StadiumBorder(),
                onPressed: () async {

                  final start = locationBloc.state.lastKnownLocation;
                  if (start == null) return ;
                  
                  final end   = mapBloc.mapCenter;
                  if( end == null ) return ; 

                  showLoadingMessage(context);

                  final destination = await searchBloc.getCoordenatesStartToEnd(start, end);
                  await mapBloc.drawRoutePolyline(destination);
                  
                  searchBloc.add(OnDeactivateManualMarkerEvent());
                  Navigator.pop(context);
                },
                child: const Text('Confirmar destino', style: TextStyle(color: Colors.white))
              ),
            ),
          )
        ],
      ),
    );
  }
}