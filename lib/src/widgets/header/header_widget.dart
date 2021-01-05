import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
import 'package:fanny_cliente/src/widgets/header/lugares_popup.dart';
import 'package:flutter/material.dart';
class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  BuildContext context; 
  Size size;
  UsuarioBloc usuarioBloc;
  String authorizationToken;
  LugaresBloc lugaresBloc;
  SharedPreferencesBloc sharedPreferencesBloc;
  PedidosBloc pedidosBloc;
  bool _widgetBuilded;
  bool _direccionTemporalInicialExiste;
  
  @override
  void initState() { 
    _direccionTemporalInicialExiste = false;
    _widgetBuilded = false;
    print('state inited');
    super.initState(); 
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    sharedPreferencesBloc = Provider.sharedPreferencesBloc(context);
    lugaresBloc = Provider.lugaresBloc(context);
    usuarioBloc = Provider.usuarioBloc(context);
    authorizationToken = usuarioBloc.token;
    pedidosBloc = Provider.pedidosBloc(context);
    if(!_widgetBuilded){
      _initDatos();
      _widgetBuilded = true;
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _crearComponenteDirecciones(size, lugaresBloc, authorizationToken),
          _crearComponentesLogo()
        ],
      ),
    );
  }

  Widget _crearComponenteDirecciones(Size size, LugaresBloc lugaresBloc, String token){
    return StreamBuilder(
      stream: lugaresBloc.lugaresStream,
      builder: (BuildContext context, AsyncSnapshot<List<LugarModel>> snapshot){
        if(snapshot.hasData){
          return LugaresPopUp(
            authorizationToken: token,
            snapshot: snapshot,
            direccionTemporalInicialExiste: _direccionTemporalInicialExiste,
          );
        }
        else
          return Container();
      },
    );
  }

  Future<void> _initDatos()async{
    await _verificarDirecciones();
    if(!pedidosBloc.pedidosAnterioresCargados)
      pedidosBloc.cargarPedidosAnterioresPorClienteOTienda(usuarioBloc.token, 'cliente', null);
  }

  Future<void> _verificarDirecciones()async{
    await _initSharedPreferences();
    if(usuarioBloc.usuario != null && usuarioBloc.usuario.phoneVerify){
      await _validarSiExistenDirecciones();
    }else if(sharedPreferencesBloc.getDireccionTemporalInicial() != null){
      _agregarDireccionInicialDePreferences();
    }
  }

  Future<void> _initSharedPreferences()async{
    if(sharedPreferencesBloc.sharedPreferences == null)
      await sharedPreferencesBloc.initSharedPreferences();
  }

  Future<void> _validarSiExistenDirecciones()async{
    Map<String, dynamic> lugaresResponse = await lugaresBloc.cargarLugares(usuarioBloc.token);
    if(lugaresResponse['status'] == 'no_direcciones')
      Navigator.of(context).pushReplacementNamed(DireccionCreatePage.route, arguments: 'cliente_nuevo');
  }

  void _agregarDireccionInicialDePreferences(){
    final LugarModel direccionTemporalInicial = sharedPreferencesBloc.getDireccionTemporalInicial();
    lugaresBloc.addDireccionInicialActual(direccionTemporalInicial);
    _direccionTemporalInicialExiste = true;
  }

  Widget _crearComponentesLogo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _crearLineaSeparadoraDeLogo(),
        _crearLogo()
      ],
    );
  }

  Widget _crearLineaSeparadoraDeLogo(){
    return Container(
      width: size.width * 0.0005,
      height: size.height * 0.045,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.grey.withOpacity(0.65),
            width: 1
          )
        )
      ),
    );
  }

  Widget _crearLogo(){
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.055),
      child: Image.asset(
        'assets/iconos/logo_fanny_simple.jpeg',
        fit: BoxFit.fill,
        width: size.width * 0.085,
        height: size.height * 0.085,
      ),
    );
  }
}