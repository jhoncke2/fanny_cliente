import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:fanny_cliente/src/pages/register_page.dart';
import 'package:fanny_cliente/src/utils/size_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/utils/data_prueba/tienda_polygons.dart' as testingPolygons;

// ignore: must_be_immutable
class InitValidationPage extends StatelessWidget {
  static final String route = 'init_validation';
  BuildContext _context;
  SizeUtils _sizeUtils;
  UsuarioBloc _usuarioBloc;
  SharedPreferencesBloc _sharedPreferencesBloc;
  LugaresBloc _lugaresBloc;
  PolygonsBloc _polygonsBloc;

  @override
  Widget build(BuildContext appContext) {
    _initBlocs(appContext);
    WidgetsBinding.instance.addPostFrameCallback((_){
      _validarLogin();
    });
    Size size = MediaQuery.of(_context).size;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(_context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size.width * 0.035)
          ),
          height: size.height * 0.7,
          width: size.width * 0.8,
        ),
      ),
    );
  }

  void _initBlocs(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    final Size screenSize = MediaQuery.of(appContext).size;
    _sizeUtils.initUtil(screenSize);
    _usuarioBloc = Provider.usuarioBloc(appContext);
    _sharedPreferencesBloc = Provider.sharedPreferencesBloc(appContext);
    _lugaresBloc = Provider.lugaresBloc(appContext);

    _polygonsBloc = BlocProvider.of<PolygonsBloc>(appContext);
  }

  void _validarLogin()async{
    if(_sharedPreferencesBloc.sharedPreferences == null){
      await _sharedPreferencesBloc.initSharedPreferences();
    }
    //_sharedPreferencesBloc.deleteDireccionTemporalInicial();
    if(!_usuarioBloc.isLogged){
      Map<String, dynamic> loginCredentials = _sharedPreferencesBloc.getActualLoginCredentials();
      if(['facebook', 'google'].contains( loginCredentials['tipo'] ) ){
        if(loginCredentials['email'] != null){
          _autoExternalLogin(loginCredentials['email']);
        }
      }else if(loginCredentials['tipo'] == 'normal'){
        if(loginCredentials['email'] != null && loginCredentials['password'] != null){
          _autoNormalLogin(loginCredentials['email'], loginCredentials['password']);
        }
      }else{
        if(_sharedPreferencesBloc.getDireccionTemporalInicial() == null)
          Navigator.of(_context).pushReplacementNamed(DireccionCreatePage.route);
      }
    }
  }

  void _autoNormalLogin(String email, String password)async{
    Map<String, dynamic> loginResponse = await _usuarioBloc.login(email, password);
    if(loginResponse['status'] == UsuarioBloc.INVALID_CREDENTIALS_MESSAGE){
      Navigator.of(_context).pushReplacementNamed(DireccionCreatePage.route);      
    }else{
      final String authorizationToken = loginResponse['token'];
      await _lugaresBloc.cargarLugares(authorizationToken);
      _doExtraInitialConfiguration(_lugaresBloc.actualElegido.latLng);
      Provider.navigationBloc(_context).reiniciarIndex();
      Navigator.of(_context).pushReplacementNamed(HomePage.route);      
    }
  }

  void _autoExternalLogin(String email)async{
    Map<String, dynamic> loginResponse = await _usuarioBloc.validarEmail(email);
    if(loginResponse['status'] == UsuarioBloc.INVALID_CREDENTIALS_MESSAGE){
        Navigator.of(_context).pushReplacementNamed(RegisterPage.route, arguments: TipoDireccion.DESLOGGEADO);
    }else{
      final String authorizationToken = loginResponse['token'];
      await _lugaresBloc.cargarLugares(authorizationToken);
      _doExtraInitialConfiguration(_lugaresBloc.actualElegido.latLng);
      Navigator.of(_context).pushReplacementNamed(HomePage.route);
    }
  }

  void _doExtraInitialConfiguration(LatLng position){
    final Set<Polygon> polygons = testingPolygons.tiendaPolygons;
    _polygonsBloc.add(AddPolygons(polygons: polygons));
    _polygonsBloc.add(DefineIfWeAreOnAnyPolygon(position: position));
  }
}