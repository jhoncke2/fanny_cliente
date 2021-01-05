import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/navigation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/utils/size_utils.dart';
import 'package:fanny_cliente/src/widgets/bottom_bar/navigation_menu.dart';
class BottomBarWidget extends StatefulWidget {
  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  BuildContext _context;
  SizeUtils _sizeUtils;
  NavigationBloc _navigationBloc;
  UsuarioBloc _usuarioBloc;
  Color _unselectedItemColor;
  Color _selectedItemColor;
  IconThemeData _unselectedIconTheme;
  IconThemeData _selectedIconTheme;
  
  @override
  Widget build(BuildContext appContext) {
    _initInitialConfiguration(appContext);
    _generarStylesYThemes();
    return BottomNavigationBar(
      iconSize: _sizeUtils.xasisSobreYasis * 0.053,
      selectedItemColor: _selectedItemColor,
      unselectedItemColor: _unselectedItemColor,
      backgroundColor: Colors.blueAccent,
      selectedIconTheme: _selectedIconTheme,
      unselectedIconTheme: _unselectedIconTheme,
      onTap: _onButtonTap,
      currentIndex: _navigationBloc.index,
      items: _createNavigationButtons(),
      showUnselectedLabels: true,
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    _navigationBloc = Provider.navigationBloc(context);
    _usuarioBloc = Provider.usuarioBloc(context);
  }

  void _onButtonTap(int newIndex){
    if(newIndex!=3){
      _navigationBloc.index = newIndex;
      Navigator.of(context).pushNamed(_navigationBloc.routeByIndex);
    }     
    else{
      if(_usuarioBloc.usuario != null){
        final NavigationMenu nM = NavigationMenu(newIndex, _context, _navigationBloc, _usuarioBloc);
        nM.showNavigationMenu();
      }else{
        _navigationBloc.index = newIndex;
        Navigator.of(context).pushNamed(_navigationBloc.routeByIndex);
      }
    }         
    setState(() {
      
    });
  }

  List<BottomNavigationBarItem> _createNavigationButtons(){
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Inicio',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Buscar'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.line_style),
        label: 'Pedidos'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.perm_identity),
        label: 'Cuenta'
      ),
    ];
    return items;
  }

  void _generarStylesYThemes(){
    _unselectedItemColor = Colors.black.withOpacity(0.6);
    _selectedItemColor = Colors.black.withOpacity(0.9);
    _selectedIconTheme = IconThemeData(
      color: Colors.black.withOpacity(0.8),
    );
    _unselectedIconTheme = IconThemeData(
      color: Colors.grey.withOpacity(0.8),
    );
  }
}