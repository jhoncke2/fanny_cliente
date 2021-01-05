import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LugaresPopUp extends StatefulWidget {
  final String _authorizationToken;
  final AsyncSnapshot<List<LugarModel>> _snapshot;
  final bool _direccionTemporalInicialExiste;

  LugaresPopUp({
    @required String authorizationToken,
    @required AsyncSnapshot<List<LugarModel>> snapshot,
    @required bool direccionTemporalInicialExiste
    
  })
  : this._authorizationToken = authorizationToken,
    this._snapshot = snapshot,
    this._direccionTemporalInicialExiste = direccionTemporalInicialExiste
    ;
  
  @override
  LugaresPopUpState createState() => LugaresPopUpState();
}

class LugaresPopUpState extends State<LugaresPopUp> {
  
  Size size;
  LugaresBloc lugaresBloc;
  List<PopupMenuEntry<int>> _popupItems;
  LugarModel _lugarElegido;

  @override
  Widget build(BuildContext context) {
    _initContextElements(context);
    _instanciarPopupItems();
    _agregarBotonDeNUevaDireccion();
    return PopupMenuButton<int>(
      onSelected: (int index)=>_onPopUpSelected(index),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.048)
      ),
      offset: Offset(
        -size.width * 0.04,
        size.height * 0.155,
      ),
      padding: EdgeInsets.all(0.0),
      child: _crearPopUpChild(),
      itemBuilder: (BuildContext context){
        return _popupItems;
      },
    );
  }

  void _initContextElements(BuildContext context){
    size = MediaQuery.of(context).size;
    lugaresBloc = Provider.lugaresBloc(context);
  }

  void _instanciarPopupItems(){
    _popupItems = [];
    List<LugarModel> lugares = widget._snapshot.data;
    for(int i = 0; i < widget._snapshot.data.length; i++){
      LugarModel lugar = lugares[i];
      if(lugar.elegido)
      _lugarElegido = lugar;
      _popupItems.add(
        PopupMenuItem(
          value: i,
          child: _crearItemsDePopUpItem(lugar)
        )
      );
    }
  }

  void _agregarBotonDeNUevaDireccion(){
    if(!widget._direccionTemporalInicialExiste){
      _popupItems.add(
        PopupMenuItem( 
          enabled: false,
          value: 0,
          child: _crearPupUpBotonDeNuevaDireccionChild()
        )
      );
    }
  }

  Widget _crearPupUpBotonDeNuevaDireccionChild(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:size.height * 0.015),
      child: Center(
        child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.04)),
          child: Text('otra dirección'),
          color: Colors.grey.withOpacity(0.8),
          onPressed: (){
            Navigator.pushNamed(context, DireccionCreatePage.route, arguments: TipoDireccion.CLIENTE);
          },
        ),
      ),
    );
  }

  _crearItemsDePopUpItem(LugarModel lugar){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _crearCirculoDeSeleccion(lugar.elegido),
        SizedBox(
          width: size.width * 0.025,
        ),
        _crearNombreDireccion(lugar.direccion)
      ],
    );
  }

  void _onPopUpSelected(int index)async{
    LugarModel elegido = widget._snapshot.data[index];
    await lugaresBloc.elegirLugar(elegido.id, widget._authorizationToken);
    final PolygonsBloc polygonsBloc = BlocProvider.of<PolygonsBloc>(context);
    polygonsBloc.add(DefineIfWeAreOnAnyPolygon(position: lugaresBloc.actualElegido.latLng));
    setState(() {

    });
  }

  Widget _crearCirculoDeSeleccion(bool elegido){
    return Container(
      width: size.width * 0.095,
      height: size.height * 0.03,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: ((!elegido)? 
          Border.all(
            width: 1,
            color: Colors.black.withOpacity(0.9)
          )
          :null
          ),
        color: (elegido)? Theme.of(context).secondaryHeaderColor : Colors.white,
      ),
    );
  }

  Widget _crearNombreDireccion(String nombreDireccion){
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width  * 0.45),
      child: Text(
        nombreDireccion,
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }


  Widget _crearPopUpChild(){
    return Row(
      children: <Widget>[
        Icon(
          Icons.place,
          color: Colors.grey.withOpacity(0.8),
          size: size.width * 0.06,
        ),
        SizedBox(
          width: size.width * 0.02
        ),
        _crearDireccionName(),
        SizedBox(
          width: size.width * 0.005,
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Colors.grey.withOpacity(0.65),
          size: size.width * 0.085,
        ),
      ],
    );
  }

  Widget _crearDireccionName(){
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width  * 0.45),
      child: Text(
        _lugarElegido.direccion,
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}