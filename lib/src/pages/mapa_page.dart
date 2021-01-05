import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapaPage extends StatelessWidget {
  static final route = 'mapa';
  
  LugarModel lugar;
  GoogleMapController _mapController;
  Set<Marker> _markers;
  MapaPage(
  ){
    lugar = new LugarModel(
      id: 1001,
      latitud: 4.637479,
      longitud: -74.101,
      elegido: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    UsuarioBloc usuarioBloc = Provider.usuarioBloc(context);
    LugaresBloc lugaresBloc = Provider.lugaresBloc(context);
    Size size = MediaQuery.of(context).size;
    lugar = ModalRoute.of(context).settings.arguments;
    _generarMarkers(usuarioBloc, lugaresBloc);
    //this.lugar = Navigator.
    return Scaffold(
      floatingActionButton: IconButton(
        iconSize: size.width * 0.059,
        icon: Icon(
          Icons.arrow_back,
          color: Colors.blueAccent,
        ),
        //backgroundColor: Colors.white.withOpacity(1.0),
        onPressed: (){
          //Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(HomePage.route);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Stack(
        children: [
          _crearMapa(),
        ],
      ),
    );
  }

  Widget _crearMapa(){
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: lugar.latLng,
        zoom: 14.5,
      ),
      onMapCreated: (GoogleMapController newController){
        _mapController = newController;
      },
      markers: _markers,
      //circles: (_tipoMapa==widget._tiposMapas[1])? _circles : [],
      //circles: null,
      //no sé para qué sirve y/o qué cambia
      //myLocationEnabled: true,
    );
  }


  void _generarMarkers(UsuarioBloc usuarioBloc, LugaresBloc lugaresBloc){
    _markers = {
      Marker(
        markerId: MarkerId(lugar.id.toString()),
        icon: BitmapDescriptor.defaultMarker,
        position: lugar.latLng,
        infoWindow: InfoWindow(
          title: lugar.direccion,
        ),
        draggable: true,
        onDragEnd: (LatLng newPosition){
          lugar.latitud = newPosition.latitude;
          lugar.longitud = newPosition.longitude;
          lugaresBloc.editarLugar(lugar, usuarioBloc.token);
          print('dragged to: $newPosition');
        }
      ),
    };
  }
}