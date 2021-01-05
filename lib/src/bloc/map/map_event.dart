part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class UpdatePosition extends MapEvent{
  final LatLng newPosition;

  UpdatePosition({
    @required this.newPosition
  });
}

class UpdatePositionFromStringDirection extends MapEvent{
  final String direction;

  UpdatePositionFromStringDirection({
    @required this.direction
  });
}
