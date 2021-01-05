import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:fanny_cliente/src/utils/google_services.dart' as googleServices;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  MapState _currentNewState;

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    switch(event.runtimeType){
      case UpdatePosition:
        _updatePosition(event as UpdatePosition);
        yield _currentNewState;
      break;
      case UpdatePositionFromStringDirection:
        await _updatePositionFromStringDirection(event as UpdatePositionFromStringDirection);
        yield _currentNewState;
      break;
    }
  }

  void _updatePosition(UpdatePosition event){
    final LatLng newPosition = event.newPosition;
    _currentNewState = state.copyWith(currentPosition: newPosition);
  }

  Future<void> _updatePositionFromStringDirection(UpdatePositionFromStringDirection event)async{
    final String stringDirection = event.direction;
    final LatLng newPosition = await googleServices.getUbicacionFromDireccionString(stringDirection);
    _currentNewState = state.copyWith(currentPosition: newPosition);
  }
}
