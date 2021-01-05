import 'package:fanny_cliente/src/models/usuarios_model.dart';
import 'package:fanny_cliente/src/services/user_service.dart';

enum LoginProviders{
  GOOGLE,
  FACEBOOK,
  EMAIL
}

final String INVALID_CREDENTIALS_MESSAGE = 'invalid_credentials';

Future<Map<String, dynamic>> validarEmail(String email)async{
  final Map<String, dynamic> body = {'email':email};
  Map<String, dynamic> validarEmailResponse = await userService.validarEmail(body);
  if(validarEmailResponse['status'] == 'ok'){
    final String authorizationToken = validarEmailResponse['token'];
    await getUserInformation(authorizationToken);
  }  
  return validarEmailResponse;
}

Future<Map<String, dynamic>> login(String email, String password)async{
  final Map<String, dynamic> body = {
    'email':email,
    'password':password
  };
  Map<String, dynamic> respuesta = await userService.login(body);
  if(respuesta['status']=='ok'){
    final String authorizationToken = respuesta['token'];
    final UsuarioModel usuario = await getUserInformation(authorizationToken);
    return{
      'status':'ok',
      'token':authorizationToken,
      'user':usuario,
    };
  }
  return respuesta;
}

Future<Map<String, dynamic>> updateMobileToken(String authorizationToken, String mobileToken, int userId)async{
  final Map<String, dynamic> headers = _createAuthorizationTokenHeader(authorizationToken);
  Map<String, dynamic> body = {
    'mobile_token':mobileToken,
    'user_id':userId
  };
  Map<String, dynamic> response = await userService.updateMobileToken(headers, body);
  return response;
}

Future<UsuarioModel> getUserInformation(String authorizationToken)async{
  Map<String, dynamic> headers = _createAuthorizationTokenHeader(authorizationToken);
  Map<String, dynamic> response = await userService.getUserInformation(headers);
  if(response['status'] == 'ok'){
    try{
      final UsuarioModel usuario = UsuarioModel.fromJsonMap(response['user']);
      //TODO: implementar con el nuevo formato bloc
      String mobileToken = 'mobile_token';
      updateMobileToken(authorizationToken, mobileToken, usuario.id);
      return usuario;
    }catch(err){
      print('ha ocurrido un error:');
      print(err);
    }
    return null; 
  }
}

Future<Map<String, dynamic>> register(String name, String email, String phone, String password, String passwordConfirmation)async{
  final Map<String, dynamic> serviceBody = {
    'name':name,
    'email':email,
    'phone':phone,
    'password':password,
    'password_confirmation':passwordConfirmation
  };
  Map<String, dynamic> registerResponse = await userService.register(serviceBody);
  
  if(registerResponse['status'] == 'ok'){
    final String authorizationToken = registerResponse['token'];
    final UsuarioModel usuario = await getUserInformation(authorizationToken);
    //TODO: Agregar al nuevo formato de UserBloc
  }
  return registerResponse;
}

Future<void> logOut(String authorizationToken)async{
  final serviceBody = {'token':authorizationToken};
  Map<String, dynamic> response = await userService.logout(serviceBody);
  /*
  if(response['status']=='ok'){
    this.usuario = null;
    this.token = null;
  }
  */
}

Map<String, dynamic> _createAuthorizationTokenHeader(String authorizationToken){
  return {
    'Authorization':'Bearer $authorizationToken'
  };
}

/*
  Future<Map<String, dynamic>> cambiarNombreYAvatar(String token, int userId, String name, File avatar)async{
    Map<String, dynamic> response = await userService.cambiarNombreYAvatar(token, userId, name, avatar);
    return response;
  }
*/