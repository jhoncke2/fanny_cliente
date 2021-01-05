import 'package:fanny_cliente/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_cliente/src/pages/favoritos_page.dart';
import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
import 'package:fanny_cliente/src/pages/login_page.dart';
import 'package:fanny_cliente/src/pages/perfil_page.dart';
import 'package:fanny_cliente/src/bloc_old/navigation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/tienda_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/utils/size_utils.dart';

class NavigationMenu{
  final int _currentNavigationIndex;

  BuildContext _context;
  NavigationBloc _navigationBloc;
  UsuarioBloc _usuarioBloc;
  SizeUtils _sizeUtils;
  PedidosBloc _pedidosBloc;

  NavigationMenu(int currentNavigationIndex, BuildContext appContext, NavigationBloc navigationBloc, UsuarioBloc usuarioBloc)
  : _currentNavigationIndex = currentNavigationIndex{
    _initInitialConfiguration(appContext, navigationBloc, usuarioBloc);
  }

  void _initInitialConfiguration(BuildContext appContext, NavigationBloc navigationBloc, UsuarioBloc usuarioBloc){
    _context = appContext;
    _navigationBloc = navigationBloc;
    _usuarioBloc = usuarioBloc;
    _pedidosBloc = Provider.pedidosBloc(_context);
    _sizeUtils = SizeUtils();
  }

  void showNavigationMenu()async{
    final double screenWidth = MediaQuery.of(_context).size.width;
    final String authorizationToken = _usuarioBloc.token;
    List<PopupMenuEntry<String>> menuItems = _agregarMenuItems(authorizationToken);
    final String value = await showMenu<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_sizeUtils.xasisSobreYasis * 0.05),
          topRight: Radius.circular(_sizeUtils.xasisSobreYasis * 0.05)
        )
      ),
      context: _context, 
      position: RelativeRect.fromLTRB(
        _sizeUtils.xasisSobreYasis * 0.3, 
        _sizeUtils.xasisSobreYasis * 0.09, 
        screenWidth - 1, 
        _sizeUtils.xasisSobreYasis * 0.855
      ),
      items: menuItems,
    );
    _validateNavigationMenuValue(value);
  }

  void _validateNavigationMenuValue(String value){
    final String authorizationToken = _usuarioBloc.token;
    if(value!=null){
      _navigationBloc.index = _currentNavigationIndex;
    }
    switch(value){
      case 'perfil':
        Navigator.of(_context).pushNamed(PerfilPage.route);
        break;
      case 'favoritos':
        Navigator.of(_context).pushNamed(FavoritosPage.route);
        break;
      case 'salir':
        _logOut(authorizationToken);
        break;
      default:
        break; 
    }
  }

  List<PopupMenuEntry<String>> _agregarMenuItems(String token){
    List<PopupMenuEntry<String>> items = [
      PopupMenuItem<String>(
        enabled: false,
        value: 'imagen',
        child: Container(
          padding: EdgeInsets.only(bottom:_sizeUtils.xasisSobreYasis * 0.035, top: _sizeUtils.xasisSobreYasis * 0.024),
          child: Center(
            child: Image.asset(
              'assets/iconos/logo_fanny_1.png',
              fit: BoxFit.fill,
              width: _sizeUtils.xasisSobreYasis * 0.27,
              height: _sizeUtils.xasisSobreYasis * 0.23,
            ),
          ),
        ),
      ),
      PopupMenuItem<String>(
        value: 'perfil',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(0, 'Perfil', Icons.person),
      ),
      PopupMenuItem<String>(
        value: 'favoritos',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(5, 'Favoritos', Icons.favorite),
      ),
      PopupMenuItem<String>(
        value: 'space',
        height: _sizeUtils.xasisSobreYasis * 0.49,
        enabled: false,
        child: Container(),
      ),
      PopupMenuItem<String>(
        value: 'salir',
        height: _sizeUtils.xasisSobreYasis * 0.075,
        child: _crearChildPopUpMenuItem(7, 'Salir', Icons.open_in_new),
      ),
      
    ];
    return items;
  }
  
  Widget _crearChildPopUpMenuItem(int itemIndex, String nombre, IconData icono){
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.09,
      margin: EdgeInsets.all(0.0),
      decoration: _createMenuItemDecoration(itemIndex),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _createMenuItemText(nombre),
          _createMenuItemIcon(icono)
        ],
      ),
    );
  }

  BoxDecoration _createMenuItemDecoration(int itemIndex){
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(((_usuarioBloc.usuario.hasStore && itemIndex < 7)? 0.45: 0.0)),
          width: 1.35
        )
      )
    );
  }

  Widget _createMenuItemText(String nombre){
    return Text(
      nombre,
      style: TextStyle(
        color: Colors.black.withOpacity(0.55),
        fontSize: _sizeUtils.normalTextSize * 1.1,
        fontFamily: 'OpenSansCondensed',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _createMenuItemIcon(IconData icono){
    return Icon(
      icono,
      size: _sizeUtils.normalIconSize,
      color: Colors.grey.withOpacity(0.85),
    );
  }

  void _logOut(String authoirizationToken)async{
    await _usuarioBloc.logOut(_usuarioBloc.token);
    _navigationBloc.reiniciarIndex();
    Provider.sharedPreferencesBloc(_context).logOut();
    await _pedidosBloc.dispose();
    _pedidosBloc.initStreams();
    Navigator.pushReplacementNamed(_context, LoginPage.route);
  }
}