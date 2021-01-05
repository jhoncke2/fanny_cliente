import 'package:fanny_cliente/src/models/horarios_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:fanny_cliente/src/models/tiendas_model.dart';

class TiendaProvider{
  final _apiRoute = 'https://codecloud.xyz/api';

  Future<Map<String, dynamic>> crearTienda(String token, TiendaModel tienda, File ccFrontal, File ccAtras, File certificacionBancaria)async{
    Map<String, String> headers = {
      'Authorization':'Bearer $token',
      'Content-Type':'application/x-www-form-urlencoded'
    };
    Map<String, String> body = {
      'horario_id':tienda.horarioId.toString(),
      'direccion_id':tienda.direccionId.toString(),
      'tipo_de_pago':tienda.tipoDePago
    };


    var request = http.MultipartRequest('POST', Uri.parse('$_apiRoute/tiendas'));
    if(tienda.tipoDePago == 'pago_electronico'){
      body['banco'] = tienda.banco;
      body['tipo_de_cuenta'] = tienda.tipoDeCuenta;
      body['numero_de_cuenta'] = tienda.numeroDeCuenta;
      //retorna algo como: image/jpeg
      request.files.add(
        http.MultipartFile(
          'certificacion_bancaria',
          certificacionBancaria.readAsBytes().asStream(),
          certificacionBancaria.lengthSync(),
          filename: certificacionBancaria.path.split('/').last
        )
      );
    }

    request.files.add(
      http.MultipartFile(
        'cc_frontal',
        ccFrontal.readAsBytes().asStream(),
        ccFrontal.lengthSync(),
        filename: ccFrontal.path.split('/').last
      )
    );
    request.files.add(
      http.MultipartFile(
        'cc_atras',
        ccAtras.readAsBytes().asStream(),
        ccAtras.lengthSync(),
        filename: ccAtras.path.split('/').last
      )
    );
    request.fields.addAll(
      body
    );
    request.headers.addAll(headers);
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    try{
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'tienda':decodedResponse['tienda']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cargarTienda(String token)async{
    final response = await http.get(
      '$_apiRoute/tiendas',
      headers:{
        'Authorization':'Bearer $token'
      }
    );
    try{
      Map<String, dynamic> decodedResponse = {};
      if(response.body != "")
        decodedResponse = json.decode(response.body);
      if(decodedResponse['status'] == null)
        return {
          'status':'ok',
          'tienda':decodedResponse['data']
        };
      else
        return decodedResponse;
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    } 
  }

  Future<Map<String, dynamic>> cargarTiendaPublic(String token, int tiendaId)async{
    try{
      final response = await http.get(
        '$_apiRoute/tiendas/$tiendaId',
        headers: {
          'Authorization':'Bearer $token'
        }
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'tienda':decodedResponse['data']
      };
    }
    catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> crearHorario(String token, HorarioModel horarioModel)async{

    Map<String, dynamic> body = horarioModel.toJson(); 
    try{
      final response = await http.post(
        '$_apiRoute/horario/store',
        headers: {
          'Authorization':'Bearer $token'
        },
        body: body
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      if(decodedResponse['tienda']!=null){
        return {
          'status':'ok',
          'content':decodedResponse['tienda']
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
}