part of 'polygons_bloc.dart';

@immutable
class PolygonsState{
  final bool tiendaPolygonsCargados;
  final Set<Polygon> tiendaPolygons;
  final bool estamosDentroDeAlgunPolygon;

  PolygonsState({
    bool tiendaPolygonsCargados,
    Set<Polygon> tiendaPolygons,
    bool estamosDentroDeAlgunPolygon
  }):
    this.tiendaPolygonsCargados = tiendaPolygonsCargados??false,
    this.tiendaPolygons = tiendaPolygons??null,
    this.estamosDentroDeAlgunPolygon = estamosDentroDeAlgunPolygon??false
    ;

  PolygonsState copyWith({
    bool tiendaPolygonsCargados,
    Set<Polygon> tiendaPolygons,
    bool estamosDentroDeAlgunPolygon
  }) => PolygonsState(
    tiendaPolygonsCargados: tiendaPolygonsCargados??this.tiendaPolygonsCargados,
    tiendaPolygons: tiendaPolygons??this.tiendaPolygons,
    estamosDentroDeAlgunPolygon: estamosDentroDeAlgunPolygon??this.estamosDentroDeAlgunPolygon
  );
}
