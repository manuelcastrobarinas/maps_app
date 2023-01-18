part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}


class OnActivateManualMarkerEvent extends SearchEvent {}

class OnDeactivateManualMarkerEvent extends SearchEvent {}

class OnNewPlacesFoundEvent extends SearchEvent {
  
  final List<Feature> places;

  const OnNewPlacesFoundEvent({
    required this.places,
  });
}

class OnSaveHistoryPlacesEvent extends SearchEvent {
  final Feature history;

  const OnSaveHistoryPlacesEvent({
    required this.history
  });
  
}