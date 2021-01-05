import 'dart:io';
import 'dart:convert';
import 'package:fanny_cliente/src/providers/push_notifications_provider.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider{
  final _apiUrl = 'https://codecloud.xyz/api';

  Future<Map<String, dynamic>> register(String name, String email, String phone, String password, String passwordConfirmation)async{
    final answer = await http.post(
      '$_apiUrl/register',
      body:{
        'name':name,
        'email':email,
        'phone':phone,
        'password':password,
        'password_confirmation':passwordConfirmation
      }
    );
    if(answer.body != null)
      return json.decode(answer.body);
    return {
      'status':'err',
      'message':'ocurrió algún error al tratar de crear el usuario'
    };
  }

  Future<Map<String, dynamic>> login( String email, String password)async{
    final loginUrl = '$_apiUrl/login';
    
    try{
      final respuesta = await http.post(
        loginUrl,
        body: {
          "email":email,
          "password":password
        }
      );
      Map<String, dynamic> decodedResp = json.decode(respuesta.body);
      return decodedResp;
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  /**
   * usado cuando se intenta hacer login por externo(facebook, ...).
   */
  Future<Map<String, dynamic>> validarEmail(String email)async{
    try{
      final response = await http.post(
        '$_apiUrl/validar/email',
        headers: {
          'Content-Type':'Application/json'
        },
        body: json.encode({
          'email':email
        })
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

  Future<Map<String, dynamic>> updateMobileToken(String token, int userId, String mobileToken)async{
    try{
      final response = await http.post(
        '$_apiUrl/mobile_token',
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'Application/json'
        },
        body: json.encode({
          'user_id':userId,
          'mobile_token':mobileToken
        })
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'response':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> logOut(String token)async{
    try{
      final respuesta = await http.post(
        '$_apiUrl/logout',
        body: {
          "token":token
        }
      );
      Map<String, dynamic> decodedMap = json.decode(respuesta.body);
      return decodedMap;
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> getUserByToken(String token)async{  
    try{
      final respuesta = await http.get(
        '$_apiUrl/seeUserAuth',
        headers: {
          "Authorization": 'Bearer $token'
        }
      );
      Map<String, dynamic> decodedResp = json.decode(respuesta.body)['data'];
      
      return {
        'status':'ok',
        'user':decodedResp
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cambiarNombreYAvatar(String token, int userId, String name, File avatar)async{
    Map<String, String> headers = {
      'Authorization':'Bearer $token',
      'Content-Type':'application/x-www-form-urlencoded'
    };

    var request = http.MultipartRequest('POST', Uri.parse('$_apiUrl/perfil/update/$userId'));

    if(avatar != null){
      request.files.add(
        http.MultipartFile(
          'avatar',
          avatar.readAsBytes().asStream(),
          avatar.lengthSync(),
          filename: avatar.path.split('/').last
        )
      );
    }
    request.fields.addAll({
      'name':name
    });
    request.headers.addAll(headers);
    
    try{
      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      Map<String, dynamic> decodedResponse = json.decode(response.body);

      return {
        'status':'ok',
        'content':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cambiarFoto(String token, File foto)async{
    return null;
  }

  //*********************************** 
  //  Recuperar contraseña
  //**********************************
  Future<Map<String, dynamic>> enviarCorreoRecuperarPassword(String email)async{
    final passwordResetUrl = '$_apiUrl/password/reset';
    final answer = await http.post(
      passwordResetUrl,
      body: {
        'email':email
      }
    );

    if(answer.body != null)
      return json.decode(answer.body);
    return {
      'status':'err',
      'message':answer.reasonPhrase
    };
  }

  Future<Map<String, dynamic>> enviarCodigoRecuperarPassword(String email, String code)async{
    final passwordCodeVerifyUrl = '$_apiUrl/password/code/verify';
    final answer = await http.post(
      passwordCodeVerifyUrl,
      body: {
        'email':email,
        'code':code
      }
    );
    if(answer.body != null)
      return json.decode(answer.body);
    return {
      'status':'err',
      'message':answer.reasonPhrase
    };
  }

  Future<Map<String, dynamic>> enviarPasswordRecuperarPassword(String email, String password, String passwordConfirmation)async{
    final passwordChangeUrl = '$_apiUrl/password/change';
    final answer = await http.post(
      passwordChangeUrl,
      body:{
        'email':email,
        'password':password,
        'passwordConfirmation':passwordConfirmation
      }
    );
    if(answer.body != null)
      return json.decode(answer.body);
    return {
      'status':'err',
      'message':answer.reasonPhrase
    };
  }

  Future<String> getNewMobileToken()async{
    return PushNotificationsProvider.getMobileToken();
  }

  Future<Map<String, dynamic>> actualizarMobileToken(String loginToken, String mobileToken, int userId)async{
    try{
      final response = await http.post(
        '$_apiUrl/mobile_token',
        headers: {
          'Authorization':'Bearer $loginToken',
          'Content-Type':'Application/json'
        },
        body: json.encode({
          'user_id': userId,
          'mobile_token':mobileToken
        })
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'data':decodedResponse
      };
    }on HttpException catch(err){
      return {
        'status':'http_error',
        'message':err,
      };
    }catch(err){
      return {
        'status':'error',
        'message':err
      };
    }
  }
}