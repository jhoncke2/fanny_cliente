import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/utils/polygons_manager.dart' as polygonsManager;

part 'polygons_event.dart';
part 'polygons_state.dart';

class PolygonsBloc extends Bloc<PolygonsEvent, PolygonsState> {
  PolygonsBloc() : super(PolygonsState());

  PolygonsState _currentNewState;

  @override
  Stream<PolygonsState> mapEventToState(
    PolygonsEvent event,
  ) async* {
    switch(event.runtimeType){
      case AddPolygons:
        _addPolygons(event as AddPolygons);
        yield _currentNewState;
      break;
      case DefineIfPositionIsOnAnyPolygon:
        _defineIfWeAreOnAnyPolygon(event as DefineIfPositionIsOnAnyPolygon);
        yield _currentNewState;
      break;
    }
  }

  void _addPolygons(AddPolygons event){
    _currentNewState = state.copyWith(
      tiendaPolygonsCargados: true,
      tiendaPolygons: event.polygons
    );
  }

  void _defineIfWeAreOnAnyPolygon(DefineIfPositionIsOnAnyPolygon event){
    final List<Polygon> polygonsList = state.tiendaPolygons.toList();
    final bool estamosEnAlgunPolygon = polygonsManager.hallarSiPuntoEstaDentroDePolygons(polygonsList, event.position);
    _currentNewState = state.copyWith(estamosDentroDeAlgunPolygon: estamosEnAlgunPolygon);
  }
}
