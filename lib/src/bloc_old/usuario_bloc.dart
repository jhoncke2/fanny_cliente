import 'dart:io';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:fanny_cliente/src/models/usuarios_model.dart';
import 'package:fanny_cliente/src/providers/usuario_provider.dart';
import 'package:fanny_cliente/src/providers/push_notifications_provider.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';


enum LoginProviders{
  GOOGLE,
  FACEBOOK,
  EMAIL
}
class UsuarioBloc{
  static final String INVALID_CREDENTIALS_MESSAGE = 'invalid_credentials';

  final _usuarioProvider = new UsuarioProvider();
  final _usuarioController = new BehaviorSubject<List<UsuarioModel>>();

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UsuarioModel usuario;
  String token;
  bool isLogged = false;

  Stream<List<UsuarioModel>> get usuarioStream => _usuarioController.stream;

  bool _loading;
  bool _loggedIn;

  UsuarioBloc(){
    print('se inició usuarioBloc: ');
    /*
    FirebaseApp.configure(
      name: 'porta', 
      options: FirebaseOptions(
        apiKey: 'AIzaSyAYics0yUQL-QaxJKC-roZosXOcP40qW7s',
        googleAppID: 'login-externo-8d887',

      )
    );
    print('app name:');
    print(_auth.app.name);
    print(_auth.app);
    */
  } 

  Future<Map<String, dynamic>> validarEmail(String email)async{
    Map<String, dynamic> validarEmailResponse = await _usuarioProvider.validarEmail(email);
    if(validarEmailResponse['status'] == 'ok'){
      token = validarEmailResponse['token'];
      await cargarUsuario(token);
    }  
    return validarEmailResponse;
  }

  Future<Map<String, dynamic>> login(String email, String password)async{
    Map<String, dynamic> respuesta = await _usuarioProvider.login(email, password);
    if(respuesta['status']=='ok'){
      isLogged = true;
      token = respuesta['token'];
      await cargarUsuario(token);
      return{
        'status':'ok',
        'token':token,
        'user':usuario,
      };
    }
    return respuesta;
  }

  Future<Map<String, dynamic>> updateMobileToken(String loginToken, String mobileToken, int userId)async{
    Map<String, dynamic> response = await _usuarioProvider.actualizarMobileToken(loginToken, mobileToken, userId);
    return response;
  }

  Future<void> cargarUsuario(String pToken)async{
    Map<String, dynamic> response = await _usuarioProvider.getUserByToken(pToken);
    if(response['status'] == 'ok'){
      try{
        usuario = UsuarioModel.fromJsonMap(response['user']);
        String mobileToken = await PushNotificationsProvider.getMobileToken();
        _usuarioProvider.actualizarMobileToken(token, mobileToken, usuario.id);
      }catch(err){
        print('ha ocurrido un error:');
        print(err);
      }     
    }
    return response;
  }

  Future<Map<String, dynamic>> register(String name, String email, String phone, String password, String passwordConfirmation)async{
    Map<String, dynamic> registerResponse = await _usuarioProvider.register(name, email, phone, password, passwordConfirmation);
    
    if(registerResponse['status'] == 'ok'){
      token = registerResponse['token'];
      Map<String, dynamic> userResponse = await _usuarioProvider.getUserByToken(registerResponse['token']);
      usuario = UsuarioModel.fromJsonMap(userResponse['user']);
    }
    return registerResponse;
  }
  
  Future<void> logOut(String token)async{
    Map<String, dynamic> response = await _usuarioProvider.logOut(token);
    if(response['status']=='ok'){
      this.usuario = null;
      this.token = null;
    }

  }

  Future<Map<String, dynamic>> cambiarNombreYAvatar(String token, int userId, String name, File avatar)async{
    Map<String, dynamic> response = await _usuarioProvider.cambiarNombreYAvatar(token, userId, name, avatar);
    return response;
  }

  Future<Map<String, dynamic>> cambiarFoto(String token, File foto)async{
    
  }

  void dispose(){
    _usuarioController.close();
  }
}