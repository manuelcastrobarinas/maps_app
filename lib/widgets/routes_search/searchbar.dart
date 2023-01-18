import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutas_app/blocs/blocs.dart';
import 'package:rutas_app/blocs/search/search_bloc.dart';
import 'package:rutas_app/delegates/search_destination_delegate.dart';

import '../../models/search_result.dart';

//WIDGET QUE MANEJA LA BARRA DE BUSQUEDA

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>( // si el estado del marcador manual esta en true, ocultamos la barra de busqueda
      builder: (context, state) {
        return state.displayManualMarker 
        ? const SizedBox()
        : const _SearchBarBody();
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody();

  void onSearchResults( BuildContext context, SearchResultModel result ) async {
    
    final searchBloc   = BlocProvider.of<SearchBloc>(context); //en el tenemos la instruccion para obtener la informacion de donde me encuentro a donde voy
    final mapBloc      = BlocProvider.of<MapBloc>(context);    // tiene el poder de dibujar las polylines
    final locationBloc = BlocProvider.of<LocationBloc>(context);


    if (result.manual) {  //EVALUAMOS SI EL RESULTADO DE LA BUSQUEDA EXIGE PONER UN MARCADOR MANUAL EN EL MODELO
      searchBloc.add( OnActivateManualMarkerEvent() );
      return ;
    } 

    if ( result.position != null ) { // EVALUAMOS SI EL RESULTADO DE LA BUSQUEDA OBTIENE COORDENADAS DE POSISION EN EL MODELO
      final destination = await searchBloc.getCoordenatesStartToEnd(locationBloc.state.lastKnownLocation!, result.position! ); //obtener las cordenadas
      await mapBloc.drawRoutePolyline(destination); //dibujar la polyline
    }
  
  
  }

  @override
  Widget build(BuildContext context) {


    
    return SafeArea(
    //TODO: EVALUAR QUITAR ESTE PRIMER CONTAINER
      child: Container(
        margin:  const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: 45,
        child: GestureDetector(
          onTap : () async {
           final result = await showSearch(context: context, delegate: SearchDestinationDelegate());
           if (result == null ) return ;
            print(result);
            onSearchResults(context, result);
          },
          child: FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 15 ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5)
                  )
                ]
              ),
              child: const Text('¿A donde quieres ir ?', style: TextStyle( color: Colors.black87, fontWeight: FontWeight.bold )),
            ),
          ),
        ),
      ),
    );
  }
}