import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
//ignore: must_be_immutable
class ChildGoogleMapsWidget extends StatefulWidget {
  double screenHeightPercent;
  double screenWidthPercent;
  LugarModel direccion;
  TipoDireccion tipoDireccion;
  double rango;

  ChildGoogleMapsWidget({
    @required Key key,  
    @required this.screenHeightPercent, 
    @required this.screenWidthPercent,
    @required this.direccion,
    @required this.tipoDireccion,
    this.rango
  }) : super(key: key);

  @override
  _ChildGoogleMapsWidgetState createState() => _ChildGoogleMapsWidgetState();
}

class _ChildGoogleMapsWidgetState extends State<ChildGoogleMapsWidget> {
  GoogleMapController _mapController;
  Set<Circle> _circles;
  @override
  void initState() {
    // TODO: implement initState
    _circles = {};
    if(widget.tipoDireccion == TipoDireccion.TIENDA)
      _initCircles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Provider.sizeBloc(context).xasisSobreYasis * widget.screenWidthPercent,
      height: Provider.sizeBloc(context).xasisSobreYasis * widget.screenHeightPercent,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(
              0.0,
              0.0
            )
          )
        ]
      ),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: widget.direccion.latLng,
          zoom: 14.5,
        ),
        onMapCreated: (GoogleMapController newController){
          _mapController = newController;
        },
        markers: {
          Marker(
            markerId: MarkerId('0'),
            position: LatLng(
              widget.direccion.latitud,
              widget.direccion.longitud
            ),
            infoWindow: InfoWindow(
              title: widget.direccion.direccion
            ),
            draggable: true,
            onDragEnd: (LatLng newPosition){
              widget.direccion.latitud = newPosition.latitude;
              widget.direccion.longitud = newPosition.longitude;
              _initCircles();
              _mapController.moveCamera(
                CameraUpdate.newLatLng(
                  widget.direccion.latLng
                )
              );
            }
          )
        },
        circles: _circles,
        //circles: null,
        //no sé para qué sirve y/o qué cambia
        //myLocationEnabled: true,
      ),
    );
  }

  void _initCircles(){
    _circles = {
      Circle(
        circleId: CircleId('0'),
        center: LatLng(
          widget.direccion.latitud,
          widget.direccion.longitud
        ),
        radius: widget.rango
      )
    };
  }
}