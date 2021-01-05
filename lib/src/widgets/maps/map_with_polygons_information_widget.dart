import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/utils/size_utils.dart';
import 'package:fanny_cliente/src/utils/data_prueba/tienda_polygons.dart' as testingPolygons;
// ignore: must_be_immutable
class MapWithPolygonsInformationWidget extends StatelessWidget {

  LugarModel _currentPosition;
  BuildContext _context;
  SizeUtils _sizeUtils;
  //TODO: Quitar esta línea cuando haya hecho migración al nuevo formato de bloc
  Marker _positionMarker;
  Set<Polygon> _polygons;

  @override
  Widget build(BuildContext appContext) {
    _initInitialConfiguration(appContext);
    return Container(
      child: _crearMap(),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    if(_sizeUtils.xasisSobreYasis == null){
      final Size screenSize = MediaQuery.of(_context).size;
      _sizeUtils.initUtil(screenSize);
    }
    //TODO: Quitar estas líneas cuando haya hecho migración al nuevo formato de bloc
    final LugaresBloc lugaresBloc = Provider.lugaresBloc(appContext);
    _currentPosition = lugaresBloc.actualElegido;
  }  

  Widget _crearMap(){
    _createPositionMarker();
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.65,
      child: GoogleMap(
        markers: {_positionMarker},
        polygons: testingPolygons.tiendaPolygons,
        initialCameraPosition: CameraPosition(
          target: _currentPosition.latLng,
          zoom: 14.5
        ),
      ),
    );
  }

  void _createPositionMarker(){
    _positionMarker = Marker(
      markerId: MarkerId('0'),
      position: LatLng(
        _currentPosition.latitud,
        _currentPosition.longitud
      ),
      infoWindow: InfoWindow(
        title: _currentPosition.direccion
      ),
      draggable: true,
      onDragEnd: (LatLng newPosition){
        _currentPosition.latitud = newPosition.latitude;
        _currentPosition.longitud = newPosition.longitude;
      }
    );
  }
}