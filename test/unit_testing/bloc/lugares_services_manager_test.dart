import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_services_manager.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/services/user_service.dart';
import 'package:fanny_cliente/src/utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock/build_context.dart';
import 'mock/blocs.dart';

final String _testingGroupDescription = 'Se testearán métodos de lugaresServicesManager, con el authorizationToken de una cuenta logeada';
final String _initLugaresServicesManagerDescription = 'Se inicializará LugaresServicesManager';
final String _loadLugaresDescription = 'Se intentará cargar la lista de lugares';
final String _createLugarDescription = 'Se intentará crear un lugar';
final String _validateCurrentNewCacheLugarDescription = 'Se intentará ejecutar el método validateCurrentNewCacheLugarDescription para un lugar completamente nuevo';
final String _validateCurrentCacheLugarConDireccionYUbicacionYaExistentesDescription = 'Se intentará ejecutar el método validateCurrentNewCacheLugarDescription para un lugar con una dirección y una ubicación que ya exista';
final String _elegirLugarDescription = 'Se intentará elegir un lugar que no esté elegido';
final String _changeLatLngDescription = 'Se intentará cambiar el latLng de un lugar';

final Map<String, dynamic> _loginData = {
  'email':'filledMoon@gmail.com',
  'password':'12345678'
};
final BuildContext _context = MockBuildContext();
final UserBloc _userBloc = MockUserBloc();
final LugaresBloc _lugaresBloc = MockLugaresBloc();
LugaresServicesManager _lSManager;
String _authorizationToken;
List<LugarModel> _lugaresCargados;
LugarModel _currentLugarAElegir;
LugarModel _currentACambiarLatLng;

void main(){
  group(_testingGroupDescription, (){
    _initLugaresServicesManager();
    _testLoadLugares();
    _testCreateLugar();
    _testValidateCurrentNewCacheLugar();
    _testValidateCurrentCacheLugarYaExistente();
    _testValidCurrentCacheLugarYaExistenteConPosicDistinta();
    _testElegirLugar();
    _testChangeLatLng();
  });
}

void _initLugaresServicesManager(){
  /** 
  testWidgets(_initLugaresServicesManagerDescription, (WidgetTester tester)async{
  //  _mCWidget = CurrentTestingWidget();
  //  tester.pumpWidget(_mCWidget);
  // _lSManager = LugaresServicesManager.forTesting(appContext: _mCWidget.appContext, userBloc: _userBloc, lugaresBloc: _lugaresBloc);
  });
  */
  _lSManager = LugaresServicesManager.forTesting(appContext: _context, userBloc: _userBloc, lugaresBloc: _lugaresBloc);
  
}

void _testLoadLugares(){
  try{
    test(_loadLugaresDescription,()async{
      await _executeLoadLugaresValidations();
    });
  }catch(err){
    fail('No deberia haber ocurrido un error: $err');
  }
}

Future<void> _executeLoadLugaresValidations()async{
  
  await _login();
  await _loadLugares();
}

void _testCreateLugar(){
  try{
    test(_createLugarDescription,()async{
      await _executeCreateLugarValidations();
    });
  }catch(err){
    fail('No deberia haber ocurrido un error: $err');
  }
}

Future<void> _executeCreateLugarValidations()async{
  final LugarModel newLugar = LugarModel.fromJsonMap(_crearLugarUnicoFromDate());
  await _lSManager.createLugar(newLugar);
}

void _testValidateCurrentNewCacheLugar(){
  try{
    test(_validateCurrentNewCacheLugarDescription,()async{
        await _executeValidateCurrentNewCacheLugarValidations();
    });
  }catch(err){
    fail('No debería haber ocurrido un error: $err');
  }
}

Future<void> _executeValidateCurrentNewCacheLugarValidations()async{
  SharedPreferences.setMockInitialValues({});
  await sharedPreferencesUtils.initSharedPreferences();
  await _addNewLugarToSharedPreferences();
  LugarModel currentCacheLugar = sharedPreferencesUtils.getLugarTemporalInicial();
  await _lSManager.validateCurrentNewCacheLugar();
  LugarModel currentElegido = _lugaresBloc.state.elegido; 
  expect(currentCacheLugar.direccion, currentElegido.direccion, reason:'La dirección del actual lugar elegido debe ser la misma que la del lugar que estaba en caché');
}

void _testValidateCurrentCacheLugarYaExistente(){
  try{
    test(_validateCurrentCacheLugarConDireccionYUbicacionYaExistentesDescription,()async{
        await _executeValidateCurrentCacheLugarYaExistenteValidations();
    });
  }catch(err){
    fail('No debería haber ocurrido un error: $err');
  }
}

Future<void> _executeValidateCurrentCacheLugarYaExistenteValidations()async{
  SharedPreferences.setMockInitialValues({});
  await sharedPreferencesUtils.initSharedPreferences();
  final LugarModel currentCacheLugar = _lugaresCargados[0];
  await sharedPreferencesUtils.setLugarTemporal(currentCacheLugar);
  await _lSManager.validateCurrentNewCacheLugar();
  final LugarModel currentElegido = _lugaresBloc.state.elegido;
  expect(currentCacheLugar.id, currentElegido.id, reason: 'El lugar que se elgió debería ser el que ya existía con el id tomado para la prueba, sin crear uno nuevo.');
}

void _testValidCurrentCacheLugarYaExistenteConPosicDistinta(){
  try{
    test(_validateCurrentCacheLugarConDireccionYUbicacionYaExistentesDescription,()async{
        await _executeValidCurrentCacheLugarYaExistenteConPosicDistintaValidations();
    });
  }catch(err){
    fail('No debería haber ocurrido un error: $err');
  }
}

Future<void> _executeValidCurrentCacheLugarYaExistenteConPosicDistintaValidations()async{
  final LugarModel currentCacheLugar = _obtenerLugarExistenteConPosicionDistinta();
  await sharedPreferencesUtils.setLugarTemporal(currentCacheLugar);
  await _lSManager.validateCurrentNewCacheLugar();
  final LugarModel currentElegido = _lugaresBloc.state.elegido;
  expect(currentCacheLugar.id, currentElegido.id, reason: 'El lugar que se elgió debería ser el que ya existía con el id tomado para la prueba, sin crear uno nuevo.');
  expect(currentElegido.latitud, currentCacheLugar.latitud,reason: 'El lugar que se eligió debió haber cambiado su latitud y su longitud a la que tenía el lugar creado en caché');
  expect(currentElegido.longitud, currentCacheLugar.longitud,reason: 'El lugar que se eligió debió haber cambiado su latitud y su longitud a la que tenía el lugar creado en caché');
}

LugarModel _obtenerLugarExistenteConPosicionDistinta(){
  final LugarModel lugar = _lugaresCargados[1];
  lugar.latitud = lugar.latitud - 21;
  lugar.longitud = lugar.longitud + 11;
  return lugar;
}

void _testElegirLugar(){
  try{
    test(_elegirLugarDescription,()async{
      await _executeElegirLugarValidations();
    });
  }catch(err){

  }
}

Future<void> _executeElegirLugarValidations()async{
  _obtenerIdDePrimerLugarNoElegidoParaElegir();
  await _lSManager.elegirLugar(_currentLugarAElegir);
  final LugarModel elegido = _lugaresBloc.state.elegido;
  expect(elegido.id, _currentLugarAElegir.id, reason: 'El lugar actualmente elegido debería tener el mismo id que el lugar que se tomó para elegir');
}

void _testChangeLatLng(){
  try{
    test(_changeLatLngDescription,()async{
      await _executeChangeLatLngValidations();
    });
  }catch(err){

  }
}

Future<void> _executeChangeLatLngValidations()async{
  _currentACambiarLatLng = _lugaresCargados[0];
  final LatLng newPositionForChange = await _createNewLatLngForALugar();
  await _lSManager.changeLatLng(_currentACambiarLatLng.id, newPositionForChange.latitude, newPositionForChange.longitude);
  _updateCurrentLocalLugares();
  final LatLng newLugarPosition = _lugaresCargados.singleWhere((LugarModel lugar) => lugar.id == _currentACambiarLatLng.id).latLng;
  _expectTwoLongDoublesToRound(newPositionForChange.latitude, newLugarPosition.latitude, reason: 'La nueva latitud del lugar en el bloc debe ser la misma que se le puso para reemplazar a la anterior');
  _expectTwoLongDoublesToRound(newPositionForChange.longitude, newLugarPosition.longitude, reason: 'La nueva longitud del lugar en el bloc debe ser la misma que se le puso para reemplazar a la anterior');
}

Future<LatLng> _createNewLatLngForALugar()async{
  final LatLng position = _currentACambiarLatLng.latLng;
  final double newLatitude = position.latitude -10.55;
  final double newLongitude = position.longitude + 8.38;
  final LatLng newPosition = LatLng(newLatitude, newLongitude);
  return newPosition;
}

void _expectTwoLongDoublesToRound(double num1, double num2, {@required String reason}){
  num1 = double.parse(num1.toStringAsFixed(5));
  num2 = double.parse(num2.toStringAsFixed(5));
  expect(num1, num2, reason: reason);
}

Future<void> _login()async{
  final Map<String, dynamic> loginBody = {
    'email':_loginData['email'],
    'password':_loginData['password']
  };
  final Map<String, dynamic> loginResponse = await userService.login(loginBody);
  _authorizationToken = loginResponse['token'];
  _userBloc.add(SetAuthorizationToken(authorizationToken: _authorizationToken));
}

Map<String, dynamic> _crearLugarUnicoFromDate(){
  final DateTime nowDate = DateTime.now();
  final String uniqueString = '${nowDate.year}_${nowDate.month}_${nowDate.day}_${nowDate.hour}_${nowDate.minute}_${nowDate.second}';
  final String uniqueAddres = 'new_address:$uniqueString';
  final double uniqueDouble = (nowDate.month + nowDate.day + nowDate.hour + nowDate.minute + nowDate.second) / nowDate.year;
  final LatLng uniquePosition = LatLng(50.0 - uniqueDouble*0.8, -100 + uniqueDouble*0.975);
  return {
    'direccion':uniqueAddres,
    'latitud':uniquePosition.latitude,
    'longitud':uniquePosition.longitude,
    'pais':'Colombia',
    'ciudad':'Cali',
    'observaciones':'Estas son las observaciones',
    'tipo':'cliente'
  };
}

Future<void> _addNewLugarToSharedPreferences()async{
  final Map<String, dynamic> lugarMap = _crearLugarUnicoFromDate();
  final LugarModel newLugar = LugarModel.fromJsonMap(lugarMap);
  await sharedPreferencesUtils.setLugarTemporal(newLugar);
}

void _obtenerIdDePrimerLugarNoElegidoParaElegir(){
  for(int i = 0; i < _lugaresCargados.length; i++){
    final LugarModel lugar = _lugaresCargados[i];
    if(!lugar.elegido){
      _currentLugarAElegir = lugar;
      return;
    }      
  }
}

Future<void> _loadLugares()async{
  await _lSManager.loadLugares();
  _updateCurrentLocalLugares();
}

void _updateCurrentLocalLugares(){
  _lugaresCargados = _lugaresBloc.state.lugares;
}