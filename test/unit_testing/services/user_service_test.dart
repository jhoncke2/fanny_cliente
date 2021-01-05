import 'package:flutter_test/flutter_test.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/services/user_service.dart';

final String _successfulRegisterDescription = 'Se intenta registrar a un nuevo usuario de manera satisfactoria. Como response se retorna un status y un token existente';
final String _failedRegisterDescription = 'Se intenta registrar un usuario ya existente, de modo que se retornará un error.';
final String _successfulLoginDescription = 'Se intenta un login con email y password correctos. Como response se retorna un status y un token existente.';
final String _failedLoginDescription = 'Se intenta loggear con loggin incorrecto y luego con password incorrecto y el método debe retornar un ServiceStatusErr';
final String _successfulGetUserInformationDescription = 'Se intenta pedir la información de un usuario con un accessToken existente. Se debe lograr.';
final String _failedGetUserInformationDescription = 'Se intenta obtener la información de un usuario, con un accessToken falso. Se debe fallar.';
final String _successfulRefreshTokenDescription = 'Se intenta refrescar un anterior token existente. Se debe lograr.';
final String _failedRefreshTokenDescription = 'Se intenta refrescar un anterior token inexistente. Se debe fallar.';
final String _successfulLogoutDescription = 'Se intenta hacer logout con un accessToken existente. Se debe lograr.';
final String _failedLogoutDescription = 'Se intenta hacer logout con un accessToken falso. Se debe fallar.';

final String _successEmailLoginTest = 'email2@gmail.com';
final String _successPasswordLoginTest = '12345678';
final String _failEmailLoginTest = 'email200000000@gmail.com';
final String _failPasswordLoginTest = '123456789';
final String _successNameRegisterTest = 'The Turtle Test';
final String _successPasswordRegisterTest = '12345678';
final String _successConfirmedPasswordRegisterTest = '12345678';
final String _failAccessToken = 'accessTokensitoMalo';

//Esta variable se usará y cambiará durante la suceción de successful login, getUserInformation, refreshToken, logout.
String _successAccessToken = '';
String _successEmailRegisterTest = '';

void main() {
  _executeLoginTest();
}

void _executeLoginTest(){
  group('register tests', (){
    //_testSuccessfulRegister();
    _testFailedRegister();
  });
  group('Sucesión de successful login, getUserInformation, logout, y refresh', (){
    _testSuccessfulLogin();
    _testSuccessfulGetUserInformation();    
    _testSuccessfulLogout();    
  });

  group('sucesión de failed login, getUserInformation, logout, y refresh', (){
    _testFailedLogin();
    _testFailedGetUserInformation();
    _testFailedLogout();
  });

}

Future<void> _testSuccessfulRegister()async{
  test(_successfulRegisterDescription, ()async{
    try{
      await _executeSuccessRegisterValidations();
    }on ServiceStatusErr catch(_){
      fail('succesfulRegister: No debería ocurrir un ServiceStatusErr.');
    }catch(err){
      fail('succesfulRegister: Ocurrió un error inesperado: ${err.toString()}');
    }
  });
}

Future<void> _executeSuccessRegisterValidations()async{
  _successEmailRegisterTest = _generateNewUserEmailFromCurrentDate();
  Map<String, dynamic> registerData = {
    'name':_successNameRegisterTest,
    'email':_successEmailRegisterTest,
    'password':_successPasswordRegisterTest,
    'confirmed_password':_successConfirmedPasswordRegisterTest
  };
  final Map<String, dynamic> response = await userService.register(registerData);
  _executeSuccessfulTestValidations(response);
  expect(response['data']['original']['access_token'], isNotNull, reason:'el token debe existir');
}

/**
 * Crea un email único, basado en la fecha actual exacta (desde el año hasta el segundo).
 */
String _generateNewUserEmailFromCurrentDate(){
  DateTime nowTime = DateTime.now();
  String newEmail = 'email';
  newEmail += '${nowTime.year}${nowTime.month}${nowTime.day}${nowTime.hour}${nowTime.minute}${nowTime.second}';
  newEmail += '@gmail.com';
  return newEmail;
}

Future<void> _testFailedRegister()async{
  test(_failedRegisterDescription, ()async{
    try{
      await _executeFailedByExistingEmailRegisterValidations();
      fail('failedRegister: Debería haberse generado un ServiceStatusErr');
    }on ServiceStatusErr catch(err){
    }catch(err){
      fail('failedRegister: Ocurrió un error inesperado: ${err.toString()}');
    }
  });
}

Future<void> _executeFailedByExistingEmailRegisterValidations()async{
  Map<String, dynamic> registerData = {
    'name':_successNameRegisterTest,
    'email':_successEmailLoginTest,
    'password':_successPasswordRegisterTest,
    'confirmed_password':_successConfirmedPasswordRegisterTest
  };
  final Map<String, dynamic> response = await userService.register(registerData);
  expect(response, isNotNull, reason: 'el response nunca debe ser null');
  expect(response['status'], 'invalid_validations', reason:'el status debe ser invalid_validations');
  expect(response['code'], 400, reason:'El código de error debe ser 400');
}

/**
 * **********************************************
 *    Sucesión de successful login, getUserInformation, logout, y refresh
 * **********************************************
 */

Future<void> _testSuccessfulLogin()async{
  test(_successfulLoginDescription, ()async{
    try{
      await _executeSuccessfulLoginValidations();
    }on ServiceStatusErr catch(_){
      fail('sucessfulLogin: No debería ocurrir un ServiceStatusErr. Los datos del login están bien');
    }catch(err){
      fail('sucessfulLogin: Ocurrió un error inesperado: ${err.toString()}');
    }
  });
}

Future<void> _executeSuccessfulLoginValidations()async{
  Map<String, dynamic> loginData = {
    'email':_successEmailLoginTest,
    'password':_successPasswordLoginTest
  };
  Map<String, dynamic> response = await userService.login(loginData);
  _executeSuccessfulTestValidations(response);
  final String accessToken = response['token'];
  expect(accessToken, isNotNull, reason:'el token debe existir');
  _successAccessToken = accessToken;
}

Future<void> _testSuccessfulGetUserInformation()async{
  test(_successfulGetUserInformationDescription, ()async{
    try{
      await _executeSuccessfulGetUserInformationValidations();
    }on ServiceStatusErr catch(err){
      fail('successfulGetUserInformation: No debería ocurrir un ServiceStatusErr: ${err.message}');
    }catch(err){
      fail('successfulGetUserInformation: Ocurrió un error inesperado: ${err.toString()}');
    }
  });
}

Future<void> _executeSuccessfulGetUserInformationValidations()async{
  Map<String, String> headers = {'Authorization':'Bearer $_successAccessToken'};
  Map<String, dynamic> response = await userService.getUserInformation(headers);
  final Map<String, dynamic> userInformation = response['data'];
  expect(userInformation, isNotNull, reason: 'La información de usuario debe existir en el response');
  expect(userInformation['id'], isNotNull, reason: 'El id del usuario debe venir en su información');
  expect(userInformation['name'], isNotNull, reason: 'El name del usuario debe venir en su información');
  expect(userInformation['email'], isNotNull, reason: 'El email del usuario debe venir en su información');
  expect(userInformation['phone'], isNotNull, reason: 'El phone del usuario debe venir en su información');
}

Future<void> _testSuccessfulLogout()async{
  test(_successfulLogoutDescription, ()async{
    try{
      await _executeSuccessfulLogoutValidations();
    }on ServiceStatusErr catch(_){
      fail('successfulLogout: No debería ocurrir un ServiceStatusErr. Los datos del login están bien');
    }catch(err){
      fail('successfulLogout: Ocurrió un error inesperado: ${err.toString()}');
    }
  });
}

Future<void> _executeSuccessfulLogoutValidations()async{
  Map<String, dynamic> bodyData = {'token':_successAccessToken};
  Map<String, dynamic> response = await userService.logout(bodyData);
  _executeSuccessfulTestValidations(response);
}

void _executeSuccessfulTestValidations(Map<String, dynamic> response){
  expect(response, isNotNull, reason: 'el response nunca debe ser null');
  expect(response['status'], 'ok', reason:'El status debe ser ok');
}

/**
 * **********************************************
 *    Sucesión de failed login, getUserInformation, logout, y refresh
 * **********************************************
 */

Future<void> _testFailedLogin()async{
  test(_failedLoginDescription, ()async{
    try{
      await _executeFailedLoginValidations();
      fail('failedLogin: la ejecución debería haber parado debido al ServiceStatusErr.');
    }on ServiceStatusErr catch(err){
      if(err.status != 401)
        fail('failedLogin: El status code debería ser 401, y es : ${err.status}');
    }catch(err){
      fail('failedLogin: Ocurrió un error inesperado: ${err.toString()}');
    }
  });
}

Future<void> _executeFailedLoginValidations()async{
  Map<String, dynamic> loginData = {
    'email':_failEmailLoginTest,
    'password':_failPasswordLoginTest
  };
  Map<String, dynamic> response = await userService.login(loginData);
}



Future<void> _testFailedGetUserInformation()async{
  test(_failedGetUserInformationDescription, ()async{
    try{
      await _executeFailedGetUserInformationValidations();
      fail('failedGetUserInformation: la ejecución debería haber parado debido al ServiceStatusErr.');
    }on ServiceStatusErr catch(err){

    }catch(err){
      //fail('failedGetUserInformation: Ocurrió un error inesperado: ${err.toString()}');
    }
  });
}

Future<void> _executeFailedGetUserInformationValidations()async{
  Map<String, dynamic> bodyData = {'token':_failAccessToken};
  Map<String, dynamic> response = await userService.getUserInformation(bodyData);
}

Future<void> _testFailedLogout()async{
  test(_failedLogoutDescription, ()async{
    try{
      await _executeFailedLogoutValidations();
      fail('failedLogout: la ejecución debería haber parado debido al ServiceStatusErr.');
    }catch(err){
      
    }
  });
}

Future<void> _executeFailedLogoutValidations()async{
  Map<String, dynamic> bodyData = {'token':_failAccessToken};
  Map<String, dynamic> response = await userService.logout(bodyData);
}