part of 'map_bloc.dart';

@immutable
class MapState {
  final LatLng currentPosition;
  final bool withMarker;
  final bool draggableMarker;
  
  MapState({
    LatLng currentPosition,
    bool withMarker,
    bool draggableMarker
  }):
    this.currentPosition = currentPosition??null,
    this.withMarker = withMarker??true,
    this.draggableMarker = draggableMarker??true
    ;

  MapState copyWith({
    LatLng currentPosition,
    bool withMarker,
    bool draggableMarker
  }) => MapState(
    currentPosition: currentPosition??this.currentPosition,
    withMarker: withMarker??this.withMarker,
    draggableMarker: draggableMarker??this.draggableMarker
  );
}

