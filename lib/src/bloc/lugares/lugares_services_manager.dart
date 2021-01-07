import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanny_cliente/src/bloc/assertions_for_blocs/lugares_services_manager_assertions.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/services/lugares_service.dart';
import 'package:fanny_cliente/src/utils/shared_preferences.dart';


class LugaresServicesManager{

  //******** Diseño Singleton
  static final LugaresServicesManager _lSManager = LugaresServicesManager._internal();
  LugaresServicesManager._internal();

  factory LugaresServicesManager({
    @required BuildContext appContext
  }){
    _initInitialElements(appContext);
    return _lSManager;
  }

  static void _initInitialElements(BuildContext appContext){
    if(_lSManager._appContext == null){
      _lSManager.._appContext = appContext
      .._userBloc = BlocProvider.of<UserBloc>(appContext)
      .._lugaresBloc = BlocProvider.of<LugaresBloc>(appContext)
      .._asserter = LugaresServicesManagerAssertions(lugaresBloc: _lSManager._lugaresBloc);
    }
  }

  factory LugaresServicesManager.forTesting({
    @required BuildContext appContext,
    @required UserBloc userBloc, 
    @required LugaresBloc lugaresBloc
  }){
    _initInitialTestingElements(appContext, userBloc, lugaresBloc);
    return _lSManager;
  }

  static void _initInitialTestingElements(BuildContext appContext, UserBloc userBloc, LugaresBloc lugaresBloc){
    if(_lSManager._appContext == null){
      _lSManager.._appContext = appContext
      .._userBloc = userBloc
      .._lugaresBloc = lugaresBloc
      .._asserter = LugaresServicesManagerAssertions(lugaresBloc: _lSManager._lugaresBloc);
    }
  }
  // ************** fin de diseño Singleton

  LugaresServicesManagerAssertions _asserter;
  BuildContext _appContext;
  LugaresBloc _lugaresBloc;
  UserBloc _userBloc;

  Future<void> createLugar(LugarModel newLugar)async{
    final Map<String, String> headers = _createAuthorizationTokenHeaders();
    final Map<String, dynamic> body = newLugar.toJson();
    final Map<String, dynamic> response = await lugaresService.crearLugar(headers, body);
    await loadLugares();
    _asserter.assertsCreateLugar(response);
  }

  Future<void> loadLugares()async{
    final Map<String, String> headers = _createAuthorizationTokenHeaders();
    final Map<String, dynamic> lugaresResponse = await lugaresService.cargarLugares(headers);
    final List<Map<String, dynamic>> lugaresMap = lugaresResponse['direcciones'].cast<Map<String, dynamic>>();
    final List<LugarModel> lugares = LugaresModel.fromJsonList(lugaresMap).lugares;
    final SetLugares setLugaresEvent = SetLugares(lugares: lugares);
    _lugaresBloc.add(setLugaresEvent);
    _asserter.assertsLoadLugares();
  }

  Future<void> validateCurrentNewCacheLugar()async{
    final LugarModel currentNewLugarInCache = sharedPreferencesUtils.getLugarTemporalInicial();
    if(currentNewLugarInCache == null)
      return;
    final List<LugarModel> lugares = _lugaresBloc.state.lugares;
    bool thereIsOneWithTheSameAddress = false;
    for(int i = 0; i < lugares.length; i++){
      final LugarModel lugar = lugares[i];
      if(lugar.direccion == currentNewLugarInCache.direccion){
        thereIsOneWithTheSameAddress = true;
        if(!lugar.elegido)
          await elegirLugar(lugar);
        if(!_defineIfPositionsAreAtTheSameTown(currentNewLugarInCache.latLng, lugar.latLng)){
          await changeLatLng(lugar.id, currentNewLugarInCache.latitud, currentNewLugarInCache.longitud);
        }
        break;
      }
    }
    if(!thereIsOneWithTheSameAddress){
      await createLugar(currentNewLugarInCache);
    }
    sharedPreferencesUtils.deleteDireccionTemporalInicial();
    await loadLugares();
  }

  /**
   * Algoritmo propio hecho probando con googlemaps.
   *  Se observó el decimal más lejano que comenzaba a cambiar cuando se cambiaba la ubicación de una casa a otra
   *  (diferente para latitud y para longitud).
   *  Se toman esos decimales de ambas latitudes y de ambas longitudes y se calcula la distancia de pitágoras 
   *  (c^2 = sqrt(a^2 + b^2)).
   */
  bool _defineIfPositionsAreAtTheSameTown(LatLng p1, LatLng p2){
    final int latP1Rep =_createLatRepresentationNumber(p1.latitude);;
    final int latP2Rep = _createLatRepresentationNumber(p2.latitude);
    final int lonP1Rep = _createLonRepresentationNumber(p1.longitude);
    final int lonP2Rep = _createLonRepresentationNumber(p2.longitude);
    final double distance = sqrt((latP1Rep - latP2Rep)^2 + (lonP1Rep - lonP2Rep)^2);
    return distance < 1;
  }

  int _createLatRepresentationNumber(double latitude){
    String currentNumber;
    currentNumber = latitude.toStringAsFixed(5);
    currentNumber = currentNumber.split('.')[1];
    currentNumber = currentNumber.substring(3,4);
    return int.parse(currentNumber);
  }

  int _createLonRepresentationNumber(double longitude){
    String currentNumber;
    currentNumber = longitude.toStringAsFixed(4);
    currentNumber = currentNumber.split('.')[1];
    currentNumber = currentNumber.substring(2,3);
    return int.parse(currentNumber);
  }

  Future<void> elegirLugar(LugarModel lugar)async{
    try{
      final Map<String, String> headers = _createAuthorizationTokenHeaders();
      final int lugarId = lugar.id;
      final Map<String, dynamic> response = await lugaresService.elegirLugar(lugarId, headers);
      await loadLugares();
      _asserter.assertElegirLugar(response, lugar.id);
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  }

  Future<void> changeLatLng(int lugarId, double latitudeToChange, double longitudeToChange)async{
    try{
      final Map<String, String> headers = _createAuthorizationTokenHeaders();
      final Map<String, dynamic> body = {
        'latitud': latitudeToChange,
        'longitud': longitudeToChange
      };
      final Map<String, dynamic> response = await lugaresService.changeLatLongOfLugar(lugarId, headers, body);
      await loadLugares();
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  }

  void validarSiHayDirecciones(){
    final List<LugarModel> lugares = _lugaresBloc.state.lugares;
    if(lugares == null || lugares.length == 0)
      Navigator.of(_appContext).pushReplacementNamed(DireccionCreatePage.route, arguments: TipoDireccion.CLIENTE_NUEVO); 
  }

  Map<String, String> _createAuthorizationTokenHeaders(){
    final String authorizationToken = _userBloc.state.authorizationToken;
    return {
      'Authorization':'Bearer $authorizationToken'
    };
  }
}