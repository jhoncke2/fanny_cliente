import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/size_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/pages/direccion_create_mapa_page.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'package:fanny_cliente/src/utils/google_services_old.dart' as googleServices;
import 'package:fanny_cliente/src/utils/data_prueba/componentes_lugares.dart' as componentesLugares;
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TipoDireccion {
  CLIENTE_NUEVO,
  CLIENTE,
  TIENDA,
  DESLOGGEADO
}

class DireccionCreatePage extends StatefulWidget {
  static final route = 'direccion_create';

  @override
  _DireccionCreatePageState createState() => _DireccionCreatePageState();
}

class _DireccionCreatePageState extends State<DireccionCreatePage> {
  BuildContext context;
  Size size;
  SizeBloc sizeBloc;
  UsuarioBloc usuarioBloc;
  String token;
  LugaresBloc lugaresBloc;

  LugarModel lugar = LugarModel();
  bool _cuentaRecienCreada = false;
  TipoDireccion _tipoDireccion;
  String _ciudadValue;
  String _viaPrincipalValue;
  String _numeroViaPrincipalValue;
  String _numeroViaSecundariaValue;
  String _numeroCasaValue;
  String _observacionesValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _observacionesValue = '';
    
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    sizeBloc = Provider.sizeBloc(context);
    if(sizeBloc.xasisSobreYasis == null)
      sizeBloc.initBloc(MediaQuery.of(context).size);
    size = MediaQuery.of(context).size;
    usuarioBloc = Provider.usuarioBloc(context);
    token = usuarioBloc.token;
    lugaresBloc = Provider.lugaresBloc(context);
    _tipoDireccion = ModalRoute.of(context).settings.arguments;
    if(_tipoDireccion == TipoDireccion.CLIENTE_NUEVO){
      _tipoDireccion = TipoDireccion.CLIENTE;
      _cuentaRecienCreada = true;
    }else if(_tipoDireccion == TipoDireccion.DESLOGGEADO){
      
    }
    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
          height: size.height,
          width: size.width,
          child: ListView(        
            children: [
              SizedBox(
                height: size.height * 0.045,
              ),
              _crearTitulo(size),
              SizedBox(
                height: size.height * 0.08,
              ),
              _crearInputCiudad(size),
              SizedBox(
                height: size.height * 0.01,
              ),
              _crearInputsViaPrincipal(size),
              SizedBox(
                height: size.height * 0.01,
              ),
              _crearInputsViaSecundariaYCasa(size),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                'Observaciones:',
                style: TextStyle(
                  fontSize: sizeBloc.subtitleSize,
                  color: Colors.black.withOpacity(0.8)
                ),
              ),
              SizedBox(
                height: sizeBloc.normalSizedBoxHeigh,
              ), 
              _crearInputComponenteDireccion(size, 'observaciones'),
            ]
          ),
        ),
      ),
      floatingActionButton: _crearBotonCrear(size, lugaresBloc, token),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _crearTitulo(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: sizeBloc.normalIconSize,
            color: Colors.black.withOpacity(0.6),
          ),
          onPressed: (){
            if(_cuentaRecienCreada){
              _backNavigatorRecienCreada();
            }
            else
              Navigator.pop(context);
          },
        ),
        Text(
          (
            (_tipoDireccion == TipoDireccion.CLIENTE)? 
              'Nueva dirección' : 
              (_tipoDireccion == TipoDireccion.DESLOGGEADO)? 
                'Escribe tu dirección':
                'Dirección de tienda'
          ),
          style: TextStyle(
            fontSize: sizeBloc.littleTitleSize,
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(
          width: size.width * 0.02,
        )
      ],
    );
  }

  void _backNavigatorRecienCreada()async{
    await usuarioBloc.logOut(token);
    Navigator.pushReplacementNamed(context, HomePage.route);
  }

  Widget _crearInputCiudad(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Ciudad',
          style: TextStyle(
            fontSize: sizeBloc.subtitleSize * 0.9,
            color: Colors.black.withOpacity(0.8)
          ),
        ),
        SizedBox(
          width: sizeBloc.normalSizedBoxHeigh * 0.5,
        ),
        _crearPopupMenuItem(size, 'ciudad', componentesLugares.ciudades),
      ],
    );
  }

  Widget _crearInputsViaPrincipal(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _crearPopupMenuItem(size, 'via_principal', componentesLugares.tipos_vias),
        SizedBox(
          width: sizeBloc.normalSizedBoxHeigh,
        ),
        _crearInputComponenteDireccion(size, 'via_principal'),
      ],
    );
  }

  Widget _crearInputsViaSecundariaYCasa(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: sizeBloc.normalSizedBoxHeigh,
        ),
        Text(
          '#',
          style: TextStyle(
            fontSize: sizeBloc.xasisSobreYasis * 0.033,
            color: Colors.black.withOpacity(0.8)
          ),
        ),
        SizedBox(
          width: size.width * 0.025,
        ),
        _crearInputComponenteDireccion(size, 'via_secundaria'),
        SizedBox(
          width: size.width * 0.02,
        ),
        Text(
          '-',
          style: TextStyle(
            fontSize: size.width * 0.06,
            color: Colors.black.withOpacity(0.8)
          ),
        ),
        SizedBox(
          width: size.width * 0.02,
        ),
        _crearInputComponenteDireccion(size, 'casa'),
      ],
    );
  }

  /**
   * params:
   *  * tipoPopUp:
   *    * ciudad
   *    * via_principal 
   */
  Widget _crearPopupMenuItem(Size size, String tipoPopUp, List<String> elementos){
    String value = (tipoPopUp == 'ciudad')? _ciudadValue : _viaPrincipalValue;
    List<PopupMenuItem<String>> popupItems = elementos.map((String elementoActual){
      return PopupMenuItem(
          value: elementoActual,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: sizeBloc.xasisSobreYasis * 0.052,
                height: sizeBloc.xasisSobreYasis * 0.045,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: ((value != elementoActual)? 
                    Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(0.9)
                    )
                    :null
                    ),
                  color: (value == elementoActual)? Color.fromRGBO(192, 214, 81, 1) : Colors.white,
                ),
              ),
              SizedBox(
                width: size.width * 0.025,
              ),
              Text(
                elementoActual, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: size.width * 0.045
                ),
              ),
              
            ],
          ),
        );
    }).toList();
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05)
      ),
      offset: Offset(
        size.width * 0.1,
        size.height * 0.1,
      ),
      //initialValue: 'Bogotá',
      onSelected: (String newValue){
        if(tipoPopUp=='ciudad')
          _ciudadValue = newValue;
        else
          _viaPrincipalValue = newValue;
        setState(() {
          
        });
      },
      child: Container(
        width: (tipoPopUp == 'ciudad')? size.width * 0.58 : size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width * 0.04),
          color: Colors.grey.withOpacity(0.2)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: size.width * 0.02
            ),
            ((value != null)?
            Text(
              value,
              style: TextStyle(
                fontSize: size.width * 0.045,
                color: Colors.black.withOpacity(0.8)
              ),
            )
            :(tipoPopUp == 'via_principal')?
              Text('via principal')
            :Container()
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.withOpacity(0.65),
              size: size.width * 0.085,
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context){
        return popupItems;
      },
    );
  }

  Widget _crearInputComponenteDireccion(Size size, String tipoComponente){
    return Container(
      padding: EdgeInsets.only(
        top:size.height * 0.002
      ),
      width: size.width * ((tipoComponente == 'observaciones')? 0.7: 0.25),
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
        onTap: (){

        },
        onChanged: (String newValue){
          switch(tipoComponente){
            case 'via_principal':
              _numeroViaPrincipalValue = newValue;
            break;
            case 'via_secundaria':
              _numeroViaSecundariaValue = newValue;
            break;
            case 'casa':
              _numeroCasaValue = newValue;
            break;
            case 'observaciones':
              _observacionesValue = newValue;
            break;
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> _crearComponentes(){
    List<Map<String, dynamic>> componentes = [];
    //Lo quité. Estar pendiente.
    //widget.lugar.elegido = false;
    var componente;
    for(int i = 0; i < 5; i++){
      switch(i){
        case 0:
          componente = {
            'nombre':'pais',
            'valor':'Colombia'
          };
          break;
        case 1:
          componente = {
            'nombre':'ciudad',
            'valor':_ciudadValue
          };
          break;
        case 2:
          componente = {
            'nombre':'via_principal',
            'valor':  '$_viaPrincipalValue $_numeroViaPrincipalValue'
          };
          break;
        case 3:
          componente = {
            'nombre':'via_secundaria',
            'valor':_numeroViaSecundariaValue
          };
          break;
        case 4:
          componente = {
            'nombre':'numero_casa',
            'valor':_numeroCasaValue
          };
          break;
      }
      if(componente['valor'] == null)
        return null;
      componentes.add(componente);
    }
    return componentes;
  }

  Widget _crearBotonCrear(Size size, LugaresBloc lugaresBloc, String token){
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
        'Continuar',
        style: TextStyle(
          fontSize: size.width * 0.05,
          color: Colors.black.withOpacity(0.8)
        ),
      ),
      onPressed: (){
        _guardarDatos(lugaresBloc, token);
      },
    );
  }

  void _guardarDatos(LugaresBloc lugaresBloc, String token)async{
    //googleServices.getUbicacionConComponentesDireccion(componentes)
    List<Map<String, dynamic>> componentesLugar = _crearComponentes();
    if(componentesLugar == null)
      return;
    LatLng posicion = await googleServices.getUbicacionConComponentesDireccion(componentesLugar);
    //String direccion = await googleServices.getDireccionByLatLng(posicion);
    String direccion = _concatenarDireccion();
    _instanciarDatosDeLugar(posicion, direccion);
    LugarModel lugarArguments = lugar;
    if(_tipoDireccion == TipoDireccion.CLIENTE){
      Map<String, dynamic> response = await lugaresBloc.crearLugar(lugar, token);
      if(response['status'] == 'ok'){
        lugarArguments = response['content'];
        if(_cuentaRecienCreada)
          await Provider.usuarioBloc(context).cargarUsuario(token);
        await lugaresBloc.cargarLugares(token);
      }
    }
    
    Navigator.of(context).pushReplacementNamed(
      DireccionCreateMapaPage.route, 
      arguments: {
        'tipo_direccion':_tipoDireccion,
        'direccion':lugarArguments
      }
    ); 
  }

  void _instanciarDatosDeLugar(LatLng posicion, String direccion){
    lugar.latitud = posicion.latitude;
    lugar.longitud = posicion.longitude;
    lugar.direccion = direccion;
    lugar.ciudad = _ciudadValue;
    lugar.observaciones = _observacionesValue;
    lugar.tipo = (_tipoDireccion == TipoDireccion.CLIENTE)? 'cliente' : 'tienda';
  }

  String _concatenarDireccion(){
    return '$_viaPrincipalValue $_numeroViaPrincipalValue # $_numeroViaSecundariaValue - $_numeroCasaValue, $_ciudadValue';
  }
}