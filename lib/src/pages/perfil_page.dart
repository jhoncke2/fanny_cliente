import 'dart:io';
import 'package:fanny_cliente/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/size_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/tienda_bloc.dart';
import 'package:fanny_cliente/src/models/horarios_model.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:fanny_cliente/src/widgets/header/header_widget.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/utils/data_prueba/datos_tienda_prueba.dart' as datosTiendaPrueba;
import 'package:fanny_cliente/src/utils/generic_utils.dart' as utils;
class PerfilPage extends StatefulWidget{
  static final route = 'perfil';
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  BuildContext context;
  Size size;
  String token;
  UsuarioBloc usuarioBloc;
  LugaresBloc lugaresBloc;
  TiendaBloc tiendaBloc;
  SizeBloc sizeBloc;

  //en creación de tienda
  File _avatar;
  String _nombre;
  //fin de en creación de tienda

  GoogleMapController _mapController;
  List<String> _listviewHoraItems = [];
  bool recienIniciado;

  
  @override
  void initState() {
    super.initState();
    recienIniciado = true;
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    usuarioBloc = Provider.usuarioBloc(context);
    token = usuarioBloc.token;
    lugaresBloc = Provider.lugaresBloc(context);
    tiendaBloc = Provider.tiendaBloc(context);
    sizeBloc = Provider.sizeBloc(context);
    if(sizeBloc.size == null){
      sizeBloc.initBloc(size);
    }
    if(recienIniciado){
      tiendaBloc.cargarTienda(token);
      recienIniciado = false;
    }
    
    //lugaresBloc.cargarLugares(usuarioBloc.token);
    
    if(_listviewHoraItems.length == 0)
      _generarStringItemsHoras(size);
    return Scaffold(
      body: _crearElementos(context, size, usuarioBloc, lugaresBloc, tiendaBloc, token),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(BuildContext context, Size size, UsuarioBloc usuarioBloc, LugaresBloc lugaresBloc, TiendaBloc tiendaBloc, String token){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sizeBloc.horizontalScaffoldPadding),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: sizeBloc.topScaffoldPadding,
            ),
            HeaderWidget(),
            StreamBuilder(

              stream: tiendaBloc.tiendaStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){

                  List<Widget> listViewItems = [];
                  _agregarItemsCliente(context, size, usuarioBloc, tiendaBloc, listViewItems);
                  if(snapshot.data != null && snapshot.data.id != null)          
                    _agregarItemsTienda( listViewItems, snapshot.data.direccion);
                  else if(tiendaBloc.enCreacion)
                    _agregarItemsTienda( listViewItems, tiendaBloc.direccionTienda);
                  listViewItems.add(
                    Center(
                      child: _crearBotonSubmit(),
                    )
                  );
                  return Container(
                    padding: EdgeInsets.all(0),
                    height: sizeBloc.normalMainListviewContainerHeight,
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical:sizeBloc.normalListviewVerticalPadding),
                      children: listViewItems,
                    ),
                  );
                }else{
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _agregarItemsCliente(BuildContext context, Size size, UsuarioBloc usuarioBloc, TiendaBloc tiendaBloc, List<Widget> items){
    items.add(
      _crearTitulo(size)
    );
    items.add(
      SizedBox(
        height: sizeBloc.normalSizedBoxHeigh,
      )
    );
    items.add(

      _crearAvatar(context, size, usuarioBloc, usuarioBloc.usuario.avatar),
    );
    items.add(
      SizedBox(
        height: sizeBloc.normalSizedBoxHeigh,
      )
    );
    items.add(
      _crearEspacioDato(size, 'Nombre', usuarioBloc.usuario.name)
    );
    items.add(
      SizedBox(
        height: sizeBloc.normalSizedBoxHeigh,
      )
    );
    items.add(
      _crearEspacioDato(size, 'Correo', usuarioBloc.usuario.email)
    );
    items.add(
      SizedBox(
        height: sizeBloc.normalSizedBoxHeigh,
      )
    );
    items.add(
      _crearEspacioDato(size, 'Celular', usuarioBloc.usuario.phone)
    );
    items.add(
      SizedBox(
        height: sizeBloc.xasisSobreYasis * 0.039,
      )
    );
  }

  void _agregarItemsTienda(List<Widget> items, LugarModel direccionTienda){      
    items.add(
      _crearMapa(size, direccionTienda),
    );
    items.add(
      SizedBox(
        height: size.height * 0.035
      ),
    );
    items.add(
      _crearCampoHorario(size, tiendaBloc),
    );
    items.add(
      SizedBox(
        height: size.height * 0.02
      ),
    );
    items.add(
      _crearAdjuntarImagen(size, tiendaBloc, 'copia de cédula')
    );
    items.add(
      SizedBox(
        height: size.height * 0.01
      ),
    );
    items.add(
      Text(
        'Solicitar pago',
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontSize: size.width * 0.044
        ),
      ),
    );
    items.add(
      _crearSolicitarPago(size, tiendaBloc),
    );
    items.add(
      SizedBox(
        height: size.height * 0.025,
      )
    ); 
  }

  Widget _crearTitulo(Size size){
    return Center(
      child: Text(
        'Perfil',
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontWeight: FontWeight.bold,
          fontSize: sizeBloc.titleSize
        ),
      ),
    );
  }

  Widget _crearAvatar(BuildContext context, Size size, UsuarioBloc usuarioBloc, String avatarUrl){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:size.width * 0.22),
      width: size.width * 0.25,
      child: FlatButton(
        color: Colors.redAccent.withOpacity(0.0),
        child: ClipOval(
          child: FadeInImage(
            width: size.width * 0.45,
            height: size.height * 0.175,
            fit: BoxFit.fill,
            image: (_avatar == null)? ( (avatarUrl == null)? AssetImage('assets/placeholder_images/user_icon.png') : NetworkImage(avatarUrl)) : FileImage(_avatar),
            placeholder: AssetImage('assets/placeholder_images/user_icon.png'),
          ),
        ),
        onPressed: (){
          subirFotoAvatar(context, size);
        },
      ),
    );
  }

  void subirFotoAvatar(BuildContext context, Size size)async{
    Map<String, File> imagenMap = {};
    await utils.tomarFotoDialog(context, size, imagenMap);
    _avatar = imagenMap['imagen'];
    setState(() {
          
    });  
  }
  
  Widget _crearEspacioDato(Size size, String nombreDato, String dato){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nombreDato,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: sizeBloc.subtitleSize,
            fontWeight: FontWeight.normal
          ),
        ),
        SizedBox(
          height: sizeBloc.littleSizedBoxHeigh,
        ),
        Container(
          width: sizeBloc.veryWideTextFormFieldSize[0],
          height: sizeBloc.veryWideTextFormFieldSize[1],
          child: TextFormField(
            style: TextStyle(
              color: Colors.black,
              fontSize: sizeBloc.normalTextSize
            ),
            initialValue: dato,
            enabled: (nombreDato == 'Nombre')? true : false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: sizeBloc.xasisSobreYasis * 0.019,
                vertical: sizeBloc.xasisSobreYasis * 0.0038
                
              ),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.25),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.001,
                  color: Colors.green.withOpacity(0.9),
                ),
                  borderRadius: BorderRadius.circular(
                  sizeBloc.xasisSobreYasis * 0.08
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  sizeBloc.xasisSobreYasis * 0.08
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  sizeBloc.xasisSobreYasis * 0.08
                ),
              )
            ),
            onChanged: (String newValue){
              if(nombreDato == 'Nombre'){
                _nombre = newValue;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _crearMapa(Size size, LugarModel lugarTienda){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Cobertura de entrega de producto',
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: sizeBloc.subtitleSize
          ),
        ),
        SizedBox(
          height: sizeBloc.normalSizedBoxHeigh,
        ),
        Container(
          //width: size.width * 0.75,
          height: sizeBloc.xasisSobreYasis * 0.65,
          child: GoogleMap(
            scrollGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: lugarTienda.latLng,
              zoom: 15.0
            ),
            markers: {
              Marker(
                markerId: MarkerId('0'),
                position: lugarTienda.latLng,

              )
            },
            circles: {
              Circle(
                circleId: CircleId('0'),
                radius: lugarTienda.rango.toDouble(),
                center: lugarTienda.latLng,
                fillColor: Colors.blueAccent.withOpacity(0.35),
                strokeColor: Colors.blueAccent.withOpacity(0.5),
                strokeWidth: 1
              )
            },
            onMapCreated: (GoogleMapController newController){
              _mapController = newController;
            },
          ),
        ),
      ],
    );
  }

  Widget _crearCampoHorario(Size size, TiendaBloc tiendaBloc){
    List<Widget> horariosDiasItems = [];
    horariosDiasItems.add(
      Text(
        'Horario de venta',
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontSize: sizeBloc.subtitleSize
        ),
      )
    );
    for(int i = 0; i < 8; i++){
      horariosDiasItems.add(
        _crearHorarioDia(i)
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: horariosDiasItems,
    );
  }

  Widget _crearHorarioDia(int diaIndex){
    HorarioModel horarioTienda = tiendaBloc.horarioTienda?? tiendaBloc.tienda.horario;
    String horaInicio;
    String horaFin;
    String dia;
    switch(diaIndex){
      case 0:
        horaInicio = horarioTienda.lunesInicio;
        horaFin = horarioTienda.lunesFinal;
        dia = 'lunes';
        break;
      case 1:
        horaInicio = horarioTienda.martesInicio;
        horaFin = horarioTienda.martesFinal;
        dia = 'martes';
        break;
      case 2:
        horaInicio = horarioTienda.miercolesInicio;
        horaFin = horarioTienda.miercolesFinal;
        dia = 'miércoles';
        break;
      case 3:
        horaInicio = horarioTienda.juevesInicio;
        horaFin = horarioTienda.juevesFinal;
        dia = 'jueves';
        break;
      case 4:
        horaInicio = horarioTienda.viernesInicio;
        horaFin = horarioTienda.viernesFinal;
        dia = 'viernes';
        break;
      case 5:
        horaInicio = horarioTienda.sabadoInicio;
        horaFin = horarioTienda.sabadoFinal;
        dia = 'sábado';
        break;
      case 6:
        horaInicio = horarioTienda.domingoInicio;
        horaFin = horarioTienda.domingoFinal;
        dia = 'domingo';
        break;
      case 7:
        horaInicio = horarioTienda.festivosInicio;
        horaFin = horarioTienda.festivosFinal;
        dia = 'festivos';
        break;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: sizeBloc.xasisSobreYasis * 0.0105),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: sizeBloc.xasisSobreYasis * 0.19,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ((horaInicio == null || horaFin == null)?
                  Container(
                    width: sizeBloc.selectableCircleRadius * 0.9,
                    height: sizeBloc.selectableCircleRadius * 0.9,
                    margin: EdgeInsets.only(right: sizeBloc.xasisSobreYasis * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: Colors.black.withOpacity(0.9)
                      )
                    ),
                  )
                  : Icon(
                    Icons.check_circle_outline,
                    color: Color.fromRGBO(192, 214, 81, 1),
                    size: size.width * 0.068,
                  )
                ),
                
                SizedBox(
                  width: size.width * 0.01,
                ),
                Text(
                  dia,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: size.width * 0.038
                  ),
                ),
              ],
            ),
          ),  
          SizedBox(
            width: size.width * 0.001,
          ),
          Text(
            ' de ',
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: size.width * 0.038
            ),
          ),
          _crearPopUpHora(size, tiendaBloc, horarioTienda, diaIndex, 'hora_inicio', horaInicio),
          Text(
            ' a ',
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: size.width * 0.038
            ),
          ),
          _crearPopUpHora(size, tiendaBloc, horarioTienda, diaIndex, 'hora_fin', horaFin),
        ],
      ),
    );
  }

  /**
   * *params:
   *    * tipoHora: <"hora_inicio" | "hora_fin">
   *      
   */
  Widget _crearPopUpHora(Size size, TiendaBloc tiendaBloc, HorarioModel horarioTienda, int diaIndex, String tipoHora, String hora){
    List<PopupMenuEntry<int>> popUpItems = [
      PopupMenuItem<int>(
        value: 0,
        height: size.height * 0.08,
        child: _crearListViewHora(size, tiendaBloc, horarioTienda, diaIndex, tipoHora),
        enabled: false,
      )
    ];
    return PopupMenuButton<int>(
      onSelected: (int newValue){
        setState(() {
          
        });
      },
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      itemBuilder: (BuildContext context){
        return popUpItems;
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.02)
      ),
      offset: Offset(
        -sizeBloc.xasisSobreYasis * 0.0045,
        sizeBloc.xasisSobreYasis * -0.0045,
      ),
      child: Container(
        width: size.width * 0.255,
        height: size.height * 0.032,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width * 0.04),
          color: Colors.grey.withOpacity(0.2)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: size.width * 0.02
            ),
            ((hora != null)?
            Text( 
             hora,
              style: TextStyle(
                fontSize: size.width * 0.029,
                color: Colors.black.withOpacity(0.8)
              ),
            )
            :SizedBox(width: size.width * 0.05)
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.withOpacity(0.9),
              size: size.width * 0.075,
            ),
          ],
        ),
      ),
    );
  }

  /*
   * *params:
   *    * tipoHora: <"hora_inicio" | "hora_fin">
   *      
   */
  Widget _crearListViewHora(Size size, TiendaBloc tiendaBloc, HorarioModel horarioTienda, int diaIndex, String tipoHora){
    
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeRight: true,
      removeLeft: true,
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        height: size.height * 0.075,
        width: size.width * 0.19,
        child: ListView(
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          children: _listviewHoraItems.map((String hora){
            return Container(
              height: size.height * 0.029,
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal:0, vertical: size.height * 0.004),
                child: Text(
                  hora,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: size.width * 0.032
                  ),
                ),
                onPressed: ((tiendaBloc.enCreacion)? 
                ()=>_guardarHorariosPorIndex(tiendaBloc, horarioTienda, diaIndex, hora, tipoHora)
                :null),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _guardarHorariosPorIndex(TiendaBloc tiendaBloc, HorarioModel horarioTienda, int index, String hora, String tipoHora){
    switch(index){
      case 0:
        if(tipoHora == 'hora_inicio')
          horarioTienda.lunesInicio = hora  ;
        else
          horarioTienda.lunesFinal = hora ;
        break;
      case 1:
        if(tipoHora == 'hora_inicio')
          horarioTienda.martesInicio = hora ;
        else
          horarioTienda.martesFinal = hora  ;
        break;
      case 2:
        if(tipoHora == 'hora_inicio')
          horarioTienda.miercolesInicio = hora  ;
        else
          horarioTienda.miercolesFinal = hora ;
        break;
      case 3:
        if(tipoHora == 'hora_inicio')
          horarioTienda.juevesInicio = hora ;
        else
          horarioTienda.juevesFinal = hora  ;
        break;
      case 4:
        if(tipoHora == 'hora_inicio')
          horarioTienda.viernesInicio = hora  ;
        else
          horarioTienda.viernesFinal = hora ;
        break;
      case 5:
        if(tipoHora == 'hora_inicio')
          horarioTienda.sabadoInicio = hora ;
        else
          horarioTienda.sabadoFinal = hora  ;
        break;
      case 6:
        if(tipoHora == 'hora_inicio')
          horarioTienda.domingoInicio = hora  ;
        else
          horarioTienda.domingoFinal = hora ;
        break;
      case 7:
        if(tipoHora == 'hora_inicio')
          horarioTienda.festivosInicio = hora ;
        else
          horarioTienda.festivosFinal = hora  ;
        break;
    }
    setState(() {
      Navigator.of(context).pop();
    });
  }

  Widget _crearSolicitarPago(Size size, TiendaBloc tiendaBloc){
    return Container(
      width: size.width * 0.45,
      padding: EdgeInsets.only(left: size.width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _crearInputTienda(size, tiendaBloc, 'banco'),
          SizedBox(
            height: size.height * 0.015,
          ),
          _crearInputTienda(size, tiendaBloc, 'tipo de cuenta'),
          SizedBox(
            height: size.height * 0.015,
          ),
          _crearInputTienda(size, tiendaBloc, 'Número de cuenta'),
          SizedBox(
            height: size.height * 0.015,
          ),
          _crearAdjuntarImagen(size, tiendaBloc, 'certificación bancaria')
        ],
      ),
    );
  }

  Widget _crearInputTienda(Size size, TiendaBloc tiendaBloc, String tipoInput){
    List<String> elementosPopUp;
    Widget input;
    switch(tipoInput){
      case 'banco':
        elementosPopUp = datosTiendaPrueba.bancos;
        input = _crearPopUp(elementosPopUp, tipoInput);
        break;
      case 'tipo de cuenta':
        elementosPopUp = datosTiendaPrueba.tiposDeCuenta;
        input = _crearPopUp(elementosPopUp, tipoInput);
        break;
      case 'Número de cuenta':
        input = _crearInputNumeroDeCuenta(size, tiendaBloc);
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          tipoInput,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: sizeBloc.normalTextSize
          ),
        ),
        input,
      ],
    );
  }


  Widget _crearPopUp(List<String> elementos, String tipoPopUp){
    final elementoElegido = (tipoPopUp == 'banco')? 
    tiendaBloc.tienda.banco
    : tiendaBloc.tienda.tipoDeCuenta;
    List<PopupMenuEntry<String>> popupItems = [];
    elementos.forEach((String elemento){
      popupItems.add(
        PopupMenuItem(
          value: elemento,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: sizeBloc.selectableCircleRadius,
                height: sizeBloc.selectableCircleRadius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: ((elemento != elementoElegido)? 
                    Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(0.9)
                    )
                    :null
                  ),
                  color: (elemento == elementoElegido)? Color.fromRGBO(192, 214, 81, 1) : Colors.white,
                ),
              ),
              SizedBox(
                width: sizeBloc.normalSizedBoxHeigh * 1.2,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: sizeBloc.xasisSobreYasis  * 0.34),
                child: Text(
                  elemento,
                  style: TextStyle(
                    fontSize: sizeBloc.normalTextSize,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      );
    });
    return PopupMenuButton<String>(
      enabled: (tiendaBloc.enCreacion),
      onSelected: (String selected){
        if(tipoPopUp == 'banco')
          tiendaBloc.tienda.banco = selected;
        else
          tiendaBloc.tienda.tipoDeCuenta = selected;
        setState(() {

        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sizeBloc.xasisSobreYasis * 0.048)
      ),
      offset: Offset(
        -sizeBloc.xasisSobreYasis * 0.03,
        sizeBloc.xasisSobreYasis * 0.29,
      ),
      padding: EdgeInsets.all(0.0),
      child: Container(
        width: sizeBloc.xasisSobreYasis * 0.31,
        height: sizeBloc.xasisSobreYasis * 0.058,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizeBloc.xasisSobreYasis * 0.03),
          color: Colors.grey.withOpacity(0.2)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: sizeBloc.normalSizedBoxHeigh
            ),
            ((elementoElegido != null)?
            Text( 
             elementoElegido,
              style: TextStyle(
                fontSize: sizeBloc.normalTextSize,
                color: Colors.black.withOpacity(0.8)
              ),
            )
            :SizedBox(width: sizeBloc.xasisSobreYasis * 0.06)
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.withOpacity(0.65),
              size: sizeBloc.largeIconSize,
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context){
        return popupItems;
      },
    ); 
  }

  Widget _crearInputNumeroDeCuenta(Size size, TiendaBloc tiendaBloc){
    return Container(
      width: sizeBloc.xasisSobreYasis * 0.31,
      height: sizeBloc.xasisSobreYasis * 0.058,
      child: TextFormField(
        style: TextStyle(
          color: Colors.black
        ),
        enabled: (tiendaBloc.enCreacion),
        initialValue: tiendaBloc.tienda.numeroDeCuenta??'',
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
          tiendaBloc.tienda.numeroDeCuenta = newValue;
          if(newValue != '')
            tiendaBloc.tienda.tipoDePago = 'pago_electronico';
          setState(() {
            
          });
        },
      ),
    );
  }

  /**
   * *params:
   *  *tipoImagen: <"copia de cédula" | "certificación bancaria">
   */
  Widget _crearAdjuntarImagen(Size size, TiendaBloc tiendaBloc, String tipoImagen){
    Function onPressedFunction;
    if(tiendaBloc.enCreacion)
      onPressedFunction = (){
        switch(tipoImagen){
          case 'copia de cédula':
            if(tiendaBloc.ccDelantera == null)
              _adjuntarFoto('cedula_delantera');
            else
              _adjuntarFoto('cedula_trasera');
            break;
          case 'certificación bancaria':
            _adjuntarFoto('certificacion_bancaria');
            break;
        }
      };
    
    return Row(
      children: <Widget>[
        Text(
          'Adjuntar $tipoImagen',
          style: TextStyle(
            fontSize: sizeBloc.normalTextSize,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        SizedBox(
          width: size.width * 0.025,
        ),
        IconButton(
          icon: Icon(
            Icons.insert_drive_file,
            color: Colors.grey.withOpacity(0.8),
            size: sizeBloc.largeIconSize,
          ),
          onPressed: onPressedFunction
        )
      ],
    );
  }

  void _adjuntarFoto(String tipoFoto)async{
    try{
      Map<String, File> imagenMap = {};
      await utils.tomarFotoDialog(context, size, imagenMap);
      if(imagenMap['imagen'] != null){
        switch(tipoFoto){
          case 'cedula_delantera':
            tiendaBloc.ccDelantera = imagenMap['imagen'];
            break;
          case 'cedula_trasera':
            tiendaBloc.ccAtras = imagenMap['imagen'];
            break;
          case 'certificacion_bancaria':
            tiendaBloc.certificacionBancaria = imagenMap['imagen'];
            break;
        }
        print(tiendaBloc);
      }
    }catch(err){
      print(err);
    }
  }


  Widget _crearBotonSubmit(){
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sizeBloc.submitButtonBorderRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: sizeBloc.submitButtonPadding[0],
        vertical: sizeBloc.submitButtonPadding[1]
      ),
      color: Colors.grey.withOpacity(0.62),
      child: Text(
        'Aceptar',
        style: TextStyle(
          fontSize: sizeBloc.flatButtonTextSize,
          color: Colors.black.withOpacity(0.8)
        ),
      ),
      onPressed: (){
        _guardarDatos();
      },
    );
  }

  void _guardarDatos()async{
    if(tiendaBloc.enCreacion){
      _crearTienda();
    }
    else{
      if(_nombre != null || _avatar != null)
        _actualizarNombreYAvatar(usuarioBloc, token);
    }
  }

  void _crearTienda()async{
    Map<String, dynamic> direccionResponse = await lugaresBloc.crearLugar( tiendaBloc.direccionTienda , token);
    if(direccionResponse['status'] == 'ok'){
      tiendaBloc.direccionTienda = direccionResponse['content'];
      tiendaBloc.tienda.direccionId = direccionResponse['content'].id;
      Map<String, dynamic> horarioResponse = await tiendaBloc.crearHorario(token);

      if(horarioResponse['status'] == 'ok'){
        tiendaBloc.tienda.horarioId = horarioResponse['content']['id'];
        Map<String, dynamic> tiendaResponse = await tiendaBloc.crearTienda(token);
        
        if(tiendaResponse['status'] == 'ok')
        {
          Provider.navigationBloc(context).reiniciarIndex();
          await usuarioBloc.cargarUsuario(token);
          await lugaresBloc.cargarLugares(token);
          Navigator.of(context).pushReplacementNamed(HomePage.route);
        }
      }
      
    }
  }

  void _actualizarNombreYAvatar(UsuarioBloc usuarioBloc, String token)async{
    Map<String, dynamic> response = await usuarioBloc.cambiarNombreYAvatar(token, usuarioBloc.usuario.id, (_nombre??usuarioBloc.usuario.name), _avatar);
    if(response['status'] == 'ok'){
      usuarioBloc.cargarUsuario(usuarioBloc.token);
      setState(() {
        
      });
    }
  }

  void _generarStringItemsHoras(Size size){
    for(int i = 0; i < 24; i++){
      String horaString = ((i == 0)? '$i$i  :  00'
      : (i==12)? '$i  :  00' 
      : (i < 10)? '0${i%12}  :  00'
      : '${i%12}  :  00');
      horaString += ((i<12)? ' Am' : ' Pm');
      _listviewHoraItems.add(
          horaString
      );
    }
  }
}