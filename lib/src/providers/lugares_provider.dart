import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fanny_cliente/src/models/lugares_model.dart';

class LugaresProvider{
  final _serviceRoute = 'https://codecloud.xyz/api/direcciones';
  final _serviceDireccionRoute = 'https://codecloud.xyz/api/direccion';
  List<LugarModel> _lugares;

  Future<Map<String, dynamic>> cargarLugares(String token)async{
    //a modo de prueba, mientras se implementa el crud
    final response = await http.get(
      _serviceRoute,
      headers: {
        'Authorization':'Bearer $token'
      }
    );
    try{
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'direcciones':decodedResponse['direcciones']
      };
    }catch(err){
      return {
        'status':'err',
        'message':'err'
      };
    }
  }

  Future<Map<String, dynamic>> crearLugar(LugarModel lugar, String token)async{
    try{
      final response = await http.post(
        _serviceRoute,
        body: lugar.toJson(),
        headers: {
          'Authorization':'Bearer $token',
          //'Content-Type':'application/json'
        }
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      if(decodedResponse['status']==null){
        return {
          'status':'ok',
          'content':decodedResponse['direccion']
        };
      }
      return decodedResponse;
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> elegirLugar(int idLugar, String token)async{
    try{
      final elegirRoute = '$_serviceDireccionRoute/elegido/$idLugar';
      final response = await http.get(
        elegirRoute,
        headers: {
          'Authorization':'Bearer $token'
        }
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return decodedResponse;
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> latLong(int idLugar, String token, double latitud, double longitud)async{
    final latlonRoute = '$_serviceDireccionRoute/latlon/$idLugar';
    final response = await http.post(
      latlonRoute,
      headers: {
        'Authorization':'Bearer $token'
      },
      body: {
        'latitud': '$latitud',
        'longitud': '$longitud'
      }
    );
    try{
      Map<String, dynamic> decodedData = json.decode(response.body);
      return {
        'status':'ok',
        'direccion':decodedData['direccion']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }   
  }
  
  Future<Map<String, dynamic>> editarLugar(LugarModel lugar, String token)async{
    //a modo de prueba, mientras se implementa el crud}
    
    final response = await http.put(
      '$_serviceRoute/${lugar.id}',
      body: lugar.toJson(),
      headers: {
        'Authorization':'Bearer $token'
      }
    );

    final decodedResponse = json.decode(response.body);
    return decodedResponse;
  }

  Future<void> eliminarLugar(int idLugar)async{
    _lugares.remove(_lugares.singleWhere((element) => element.id == idLugar));
  }
}