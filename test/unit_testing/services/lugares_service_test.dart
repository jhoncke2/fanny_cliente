import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/services/lugares_service.dart';
import 'package:fanny_cliente/src/services/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final Map<String, dynamic> _loginData = {
    'email': 'filledMoon@gmail.com',
   'password': '12345678'
};

final String _successSuccessionOfTestsMessage = 'Se intenta hacer una sucesión de crear_lugar, cargar_lugares, cambiar_elegido, cambiar_latlong';
final String _cargarLugaresMessage = 'Se intenta cargar los lugares.';
final String _crearLugarMessage = 'Se intenta crear un lugar.';
final String _elegirLugarMessage = 'Se intenta elegir un lugar.';
final String _changeLatLongOfLugarMessage = 'Se intenta cambiar la latitud y longitud de un lugar existente.';
final String _editarLugarMessage = 'Se intenta cargar los lugares.';

String _authorizationToken;
List<Map<String, dynamic>> _lugares;
int _elegidoId;

main(){
  group(_successSuccessionOfTestsMessage, (){
    _testCargarLugares();
    _testCrearLugar();
    _testElegirLugar();
    _testChangelatLongOfLugar();
  });
}

void _testCargarLugares(){
  test(_cargarLugaresMessage, ()async{
    try{
      await _executeCargarLugaresValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){
      
    }
  });
  
}

Future<void> _executeCargarLugaresValidations()async{
  await _login();
  final Map<String, dynamic> response = await _cargarLugares();
  expect(response, isNotNull, reason: 'el response debe existir');
  final List<Map<String, dynamic>> direcciones = response['direcciones'];
  expect(direcciones, isNotNull, reason: 'Debe existir la lista de direcciones');
  expect(direcciones.length, isNot(0), reason: 'Debe existir al menos una dirección');
  _lugares = direcciones;
  _validateDireccionByDireccion(direcciones);
}

void _validateDireccionByDireccion(List<Map<String, dynamic>> direcciones){
  int nElegidas = 0;
  direcciones.forEach((Map<String, dynamic> direccion) {
    expect(direccion, isNotNull, reason: 'La dirección actual no debe ser null');
    expect(direccion['id'], isNotNull, reason: 'La dirección actual debe tener un id != null');
    expect(direccion['direccion'], isNotNull, reason: 'La dirección actual debe tener una direccion != null');
    expect(direccion['ciudad'], isNotNull, reason: 'La dirección actual debe tener una ciudad != null');
    expect(direccion['pais'], isNotNull, reason: 'La dirección actual debe tener un pais != null');
    expect(direccion['latitud'], isNotNull, reason: 'La dirección actual debe tener una latitud != null');
    expect(direccion['longitud'], isNotNull, reason: 'La dirección actual debe tener una longitud != null');
    expect(direccion['observaciones'], isNotNull, reason: 'La dirección actual debe tener unas observaciones != null');
    expect(direccion['elegido'], isNotNull, reason: 'La dirección actual debe tener un elegido != null');
    expect(direccion['tipo'], isNotNull, reason: 'La dirección actual debe tener un tipo != null');
    expect(direccion['rango'], isNotNull, reason: 'La dirección actual debe tener un rango != null');
    expect(direccion['user_id'], isNotNull, reason: 'La dirección actual debe tener un user_id != null');
    if(direccion['elegido'])
      nElegidas ++;
  });
  expect(nElegidas, 1, reason: 'Debe haber una dirección eleigida, y solo una');
}

Future<void> _login()async{
  final Map<String, dynamic> loginBody = {
    'email':_loginData['email'],
    'password':_loginData['password']
  };
  final Map<String, dynamic> loginResponse = await userService.login(loginBody);
  _authorizationToken = loginResponse['token'];
}

void _testCrearLugar(){
  test(_crearLugarMessage, ()async{
    try{
      await _executeCrearLugarValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería haber un serviceStatusErr: err: ${err.status}');
    }catch(err){
      fail('No debería ocurrir error alguno: $err');
    }
  });
}

Future<void> _executeCrearLugarValidations()async{
  final Map<String, String> headers = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> body = _crearLugarUnicoFromDate();
  final Map<String, dynamic> response = await lugaresService.crearLugar(headers, body);
  expect(response, isNotNull, reason: 'La respuesta no debe ser null');
  final Map<String, dynamic> direccion = response['direccion'];
  expect(direccion, isNotNull, reason: 'La dirección del response no debe ser null');
  expect(direccion['id'], isNotNull, reason: 'El id de la dirección no debe ser null');
  expect(direccion['direccion'], isNotNull, reason: 'La direccion de la dirección no debe ser null');
  expect(direccion['latitud'], isNotNull, reason: 'La latitud de la dirección no debe ser null');
  expect(direccion['longitud'], isNotNull, reason: 'La longitud de la dirección no debe ser null');
  expect(direccion['ciudad'], isNotNull, reason: 'La ciudad de la dirección no debe ser null');
  expect(direccion['observaciones'], isNotNull, reason: 'Las observaciones de la dirección no debe ser null');
  expect(direccion['elegido'], isNotNull, reason: 'El elegido de la dirección no debe ser null');
  expect(direccion['elegido'], true, reason: 'La nueva dirección debe estar automáticamente elegida');
  expect(direccion['tipo'], isNotNull, reason: 'El tipo de la dirección no debe ser null');
  expect(direccion['user_id'], isNotNull, reason: 'El user_id de la dirección no debe ser null');
  await _instanciarLugares();
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

Future<void> _instanciarLugares()async{
  final Map<String, dynamic> cargarLugaresResponse = await _cargarLugares();
  _lugares = cargarLugaresResponse['direcciones'].cast<Map<String, dynamic>>();
}

Future<Map<String, dynamic>> _cargarLugares()async{
  final Map<String, String> _requestHeaders = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> response = await lugaresService.cargarLugares(_requestHeaders);
  return response;
}

void _testElegirLugar(){
  test(_elegirLugarMessage, ()async{
    try{
      _executeElegirLugarValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería ocurrir u service status err en elegirLugar: $err');
    }catch(err){
      fail('No debería ocurrir un error en elegirLugar: $err');
    }
  });
}

void _executeElegirLugarValidations()async{
  _obtenerIdDePrimerLugarNoElegidoParaElegir();
  final Map<String, String> headers = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> response = await lugaresService.elegirLugar(_elegidoId, headers);
  expect(response, isNotNull, reason:'El response no debe ser null');
  final Map<String, dynamic> direccion = response['direccion'];
  expect(direccion, isNotNull, reason: 'La dirección no debe ser null');
  expect(direccion['id'], _elegidoId, reason: 'La dirección retornada del servicio debe tener el id de la dirección elegida');
  expect(direccion['elegido'], true, reason: 'La dirección retornada del servicio debe estar elegida');
  await _instanciarLugares();
  _validarEnLugaresElegidoCorrecto();
}

void _obtenerIdDePrimerLugarNoElegidoParaElegir(){
  for(int i = 0; i < _lugares.length; i++){
    final Map<String, dynamic> lugar = _lugares[i];
    if(lugar['elegido'] == 0){
      _elegidoId = lugar['id'];
      return;
    }      
  }
}

void _validarEnLugaresElegidoCorrecto(){
  _lugares.forEach((Map<String, dynamic> lugar) {
    if(lugar['id'] == _elegidoId)
      expect(lugar['elegido'], true, reason: 'De los lugares cargados el lugar elegido debe ser el que se acabó de elegir');
    else
      expect(lugar['elegido'], false, reason: 'De los lugares cargados, ningún lugar debe ser elegido si no tiene el id del que se acabó de elegir');
  });
}

void _testChangelatLongOfLugar(){
  test(_changeLatLongOfLugarMessage, ()async{
    try{
      _executeChangelatLongOfLugarValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería retornarse un ServiceStatusErr: $err');
    }catch(err){
      fail('No debería retornarse un err: $err');
    }
  });
}

void _executeChangelatLongOfLugarValidations()async{
  final Map<String, dynamic> lugarACambiar = _lugares[0];
  final Map<String, String> headers = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> body = {
    'latitud': double.parse(lugarACambiar['latitud']) + 0.05,
    'longitud': double.parse(lugarACambiar['longitud']) - 0.05
  };
  final Map<String, dynamic> response = await lugaresService.changeLatLongOfLugar(lugarACambiar['id'], headers, body);
  expect(response, isNotNull, reason: 'El response de latLong no debería ser null');
  final Map<String, dynamic> direccion = response['direccion'];
  expect(direccion, isNotNull, reason: 'La dirección de latLong no debería ser null');
  expect(direccion['latitud'], lugarACambiar['latitud'], reason: 'La latitud del lugar decién creado debe ser la que se ingresó.');
  expect(direccion['longitud'], lugarACambiar['longitud'], reason: 'La longitud del lugar decién creado debe ser la que se ingresó.');
  expect(direccion['id'], lugarACambiar['id']);
  await _instanciarLugares();
  _validarNuevaLatLngEnLugares(lugarACambiar);
}

void _validarNuevaLatLngEnLugares(Map<String, dynamic> lugarCambiado){
  for(int i = 0; i < _lugares.length; i++){
    final Map<String, dynamic> lugar = _lugares[i];
    if(lugar['id'] == lugarCambiado['id']){
      expect(lugar['latitud'], lugarCambiado['latitud'], reason: 'En la lista de lugares, el lugar cambiado debería aparecer con su latitud cambiada');
      expect(lugar['longitud'], lugarCambiado['longitud'], reason: 'En la lista de lugares, el lugar cambiado debería aparecer con su longitud cambiada');
      return;
    }      
  }
}

Map<String, String> _createAuthorizationTokenHeaders(){
  return {
    'Authorization':'Bearer $_authorizationToken'
  };
}