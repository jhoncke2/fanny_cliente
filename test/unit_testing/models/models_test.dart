import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:flutter_test/flutter_test.dart';

final String _lugarModelDescription = 'Se probará el método .fromJson y .toJson de LugarModel';

Map<String, dynamic> _testingLugarMap = {
    'id':100200300409209320,
    'direccion':'address_n',
    'latitud':-100.8,
    'longitud':40.5,
    'pais':'Colombia',
    'ciudad':'Cali',
    'observaciones':'Estas son las observaciones',
    'tipo':'cliente'
  };

void main(){
  _testLugarModel();
}

void _testLugarModel(){
  test(_lugarModelDescription, (){
    try{
      _executeLugarModelValidations();
    }catch(err){
      fail('No debería haber ocurrido un error: $err');
    }
  });
}

void _executeLugarModelValidations(){
  final LugarModel lugar = LugarModel.fromJsonMap(_testingLugarMap);
  expect(lugar.id, isNotNull, reason: 'El id no debería ser null');
  expect(lugar.pais, isNotNull, reason: 'El pais no debería ser null');
  expect(lugar.ciudad, isNotNull, reason: 'La ciudad no debería ser null');
  expect(lugar.direccion, isNotNull, reason: 'La direccion no debería ser null');
  expect(lugar.latitud, isNotNull, reason: 'La latitud no debería ser null');
  expect(lugar.longitud, isNotNull, reason: 'La longitud no debería ser null');
  expect(lugar.elegido, isNotNull, reason: 'El campo elegido no debería ser null');
  expect(lugar.observaciones, isNotNull, reason: 'Las observaciones no debería ser null');
  expect(lugar.tipo, isNotNull, reason: 'El tipo no debería ser null');
  expect(lugar.rango, isNotNull, reason: 'El rango no debería ser null');
  
  _testingLugarMap = lugar.toJson();
  expect(_testingLugarMap['id'], isNotNull, reason: 'El id no debería ser null');
  expect(_testingLugarMap['pais'], isNotNull, reason: 'El pais no debería ser null');
  expect(_testingLugarMap['ciudad'], isNotNull, reason: 'La ciudad no debería ser null');
  expect(_testingLugarMap['direccion'], isNotNull, reason: 'La direccion no debería ser null');
  expect(_testingLugarMap['latitud'], isNotNull, reason: 'La latitud no debería ser null');
  expect(_testingLugarMap['longitud'], isNotNull, reason: 'La longitud no debería ser null');
  expect(_testingLugarMap['elegido'], isNotNull, reason: 'El campo elegido no debería ser null');
  expect(_testingLugarMap['observaciones'], isNotNull, reason: 'Las observaciones no debería ser null');
  expect(_testingLugarMap['tipo'], isNotNull, reason: 'El tipo no debería ser null');
  expect(_testingLugarMap['rango'], isNotNull, reason: 'El rango no debería ser null');
}