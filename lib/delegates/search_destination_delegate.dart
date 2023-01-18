import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rutas_app/blocs/search/search_bloc.dart';
import 'package:rutas_app/models/search_result.dart';

import '../blocs/location/location_bloc.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResultModel> {
  
  SearchDestinationDelegate():super(
    searchFieldLabel: 'Buscar...'
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon( Icons.clear ),
        onPressed: () {
          query = '';
        }, 
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        final result = SearchResultModel(cancel: true, manual: false);
        close( context, result );
      } 
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    final searchBloc  = BlocProvider.of<SearchBloc>(context);
    final proximity   = BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;

    searchBloc.getPlacesByQuery( proximity , query );

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {

        final place = state.places;
        
        return Padding(
          padding: const EdgeInsets.symmetric( vertical: 20 ),
          child: ListView.separated(
            itemCount: place.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text( '${ place[i].text }' ),
                subtitle: Text( '${place[i].placeName } '),
                leading: const Icon(Icons.place_rounded, color: Colors.indigo ),
                onTap: () {

                  final result = SearchResultModel(
                    cancel: false,
                    manual: false,
                    position: LatLng( place[i].center![1]! , place[i].center![0]! ),
                    name: place[i].text,
                    description: place[i].placeName,
                  );
                  
                  print('enviar al lugar $result en el mapa');
                  searchBloc.add( OnSaveHistoryPlacesEvent( history: place[i] ));
                  close(context, result);

                },
              );
            }, 
            separatorBuilder: (_ , i) => const Divider(), 
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final history = BlocProvider.of<SearchBloc>(context).state.history; //nos va a servir para ver el historial de busquedas

  
    return ListView(
      children: [
        ListTile(
          leading : const Icon(Icons.location_on_outlined),
          title   : const Text('Colocar la ubicacion manualmente'),
          onTap   : () {
            final result = SearchResultModel(cancel: false, manual: true );
            close( context, result );
          },
        ),

        ...history.map((place) => ListTile(
            title: Text( '${ place.text }' ),
            subtitle: Text( '${place.placeName } '),
            leading: const Icon(Icons.history  , color: Colors.indigo ),
            onTap: () {

              final result = SearchResultModel(
                cancel: false,
                manual: false,
                position: LatLng( place.center![1]! , place.center![0]! ),
                name: place.text,
                description: place.placeName,
              );
              
              close(context, result);

            },
          )
        ),
      ],
    );
  }
  
}