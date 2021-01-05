part of 'polygons_bloc.dart';

@immutable
abstract class PolygonsEvent {}

class AddPolygons extends PolygonsEvent{
  final Set<Polygon> polygons;
  AddPolygons({
    @required this.polygons
  });
}

class DefineIfWeAreOnAnyPolygon extends PolygonsEvent{
  final LatLng position;
  DefineIfWeAreOnAnyPolygon({
    @required this.position
  });
}
