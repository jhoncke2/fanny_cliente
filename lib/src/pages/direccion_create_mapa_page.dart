import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/widgets/maps/child_google_maps_widget.dart';
class DireccionCreateMapaPage extends StatefulWidget {
  static final route = 'direccion_create_mapa';
  @override
  _DireccionCreateMapaPageState createState() => _DireccionCreateMapaPageState();
}

class _DireccionCreateMapaPageState extends State<DireccionCreateMapaPage> {
  Map<String, dynamic> _routeSettings;
  TipoDireccion _tipoDireccion;
  LugarModel _lugar;
  bool _ubicacionCambio = false;
  int _circleRadio = 100;

  Key _googleMapsKey;

  @override
  void initState() {
    // TODO: implement initState
    _googleMapsKey = new UniqueKey();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UsuarioBloc usuarioBloc = Provider.usuarioBloc(context);
    LugaresBloc lugaresBloc = Provider.lugaresBloc(context);
    String token = usuarioBloc.token;
    _routeSettings = ModalRoute.of(context).settings.arguments;
    _tipoDireccion = _routeSettings['tipo_direccion'];
    if(_lugar == null)
      _lugar = _routeSettings['direccion'];
    if(_tipoDireccion == TipoDireccion.TIENDA){
      _lugar.rango = _circleRadio;
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _crearElementos(context, size),
      floatingActionButton: _crearBotonSubmit(context, size, lugaresBloc, token),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _crearElementos(BuildContext context, Size size){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.062,
          ),
          /*
          HeaderWidget(),
          SizedBox(
            height: size.height * 0.015,
          ),
          */
          _crearTitulo(context, size),
          SizedBox(
            height: size.height * 0.035,
          ),
          _crearMapa(),
          SizedBox(
            height: size.height * 0.015,
          ),
          (
            (_routeSettings['tipo_direccion'] == TipoDireccion.TIENDA)?
            _crearInputRadio(size)
            :Container()
          )
          
        ],
      ),
    );
  }

  Widget _crearTitulo(BuildContext context, Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon( 
            Icons.place,
            color: Colors.black.withOpacity(0.8),
            size: size.width * 0.065,
          ),
        SizedBox(
          width: size.width * 0.03,
        ),
        Text(
          'Verifica tu dirección',
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: size.width * 0.055,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  Widget _crearMapa(){
    return ChildGoogleMapsWidget(
      key: _googleMapsKey,
      screenHeightPercent: 0.7,
      screenWidthPercent: 0.6,
      direccion: _lugar,
      tipoDireccion: _tipoDireccion,
      rango: double.parse(_circleRadio.toString()),
    );
  }

  Widget _crearMapaOld(Size size){
    return Container(
      width: size.width,
      height: size.height * 0.6,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 2.0,
            spreadRadius: size.width * 0.005,
            offset: Offset(
              1.0,
              size.height * 0.001
            )
          )
        ]
      ),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _lugar.latLng,
          zoom: 14.5,
        ),
        //circles: null,
        //no sé para qué sirve y/o qué cambia
        //myLocationEnabled: true,
      ),
    );
  }

  Widget _crearInputRadio(Size size){
    return Row(
      children: <Widget>[
        Text(
          'Radio de cobertura:',
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: size.width * 0.045
          ),
        ),
        SizedBox(
          width: size.width * 0.03,
        ),
        Container(
          padding: EdgeInsets.only(
            top:size.height * 0.002
          ),
          width: size.width *  0.45,
          height: size.height * 0.05,
          child: TextField(       
            style: TextStyle(
              color: Colors.black
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: size.height * 0.0025,
                horizontal: size.width * 0.025
              ),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.25),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.001,
                  color: Colors.green.withOpacity(0.9),
                ),
                borderRadius: BorderRadius.circular(
                  size.width * 0.1
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  size.width * 0.1
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  size.width * 0.1
                ),
              )
            ),
            onChanged: (String newValue){
              print('new Value: $newValue');
              _circleRadio = int.parse( newValue );
              _lugar.rango = _circleRadio;
              setState(() {
                
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _crearBotonSubmit(BuildContext context, Size size, LugaresBloc lugaresBloc, String token){
    return FlatButton(   
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.04),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.045,
        vertical: size.height * 0.002
      ),
      color: Colors.grey.withOpacity(0.62),
      child: Text(
        'Confirmar',
        style: TextStyle(
          fontSize: size.width * 0.05,
          color: Colors.black.withOpacity(0.8)
        ),
      ),
      onPressed: (){
        _guardarDatos(context, lugaresBloc, token);
      },
    );
  }

  


  void _guardarDatos(BuildContext context, LugaresBloc lugaresBloc, String token)async{
    if(_ubicacionCambio){
      Map<String, dynamic> response = await lugaresBloc.latLong(_lugar.id, token, _lugar.latitud, _lugar.longitud);
      if(response['status'] == 'ok')
        Navigator.of(context).pushReplacementNamed(HomePage.route);
    }else{
      Navigator.of(context).pushReplacementNamed(HomePage.route);
    }     
  }

}