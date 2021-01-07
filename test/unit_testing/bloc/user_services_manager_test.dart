import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'mock/blocs.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/services/user_service.dart';
import 'package:fanny_cliente/src/bloc/user/user_services_manager.dart';
import 'mock/build_context.dart';

final String _testingGroupDescription = 'Se testearán métodos de userServicesManager';
final String _loginDescription = 'Se intentará loggear al usuario, pasando todas las validaciones del login';
final String _updateMobileTokenDescription = 'Se intentará actualizar el mobile token del usuario actual';
final String _getUserInformationDescription = 'Se intentará obtener la información del usuario actual';

final Map<String, dynamic> _loginData = {
  'email':'filledMoon@gmail.com',
  'password':'12345678'
};
final String _newMobileToken = 'abcNew2sMobilex2Token';
final BuildContext _context = MockBuildContext();
final UserBloc _userBloc = MockUserBloc();
final LugaresBloc _lugaresBloc = MockLugaresBloc();
final PolygonsBloc _polygonsBloc = PolygonsBloc();

UserServicesManager _uSManager;

void _initUserServicesMIanager(){
  _uSManager = UserServicesManager.forTesting(appContext: _context, userBloc: _userBloc, polygonsBloc: _polygonsBloc, lugaresBloc: _lugaresBloc);
}

void main(){
  //_initInitialVariables();
  
  group(_testingGroupDescription, (){
    _testLogin();
    _testUpdateMobileToken();
  });
}

void _testLogin(){
  test(_loginDescription, ()async{
    try{
      await _executeLoginValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería haber ocurrido un ServiceStatusErr: ${err.status}/${err.extraInformation}');
    }catch(err){
      fail('No debería haber ocurrido un error: $err');
    }
  });
}

Future<void> _executeLoginValidations()async{
  _initUserServicesMIanager();
  await _uSManager.login(_loginData['email'], _loginData['password']);
  expect(_userBloc.state.authorizationToken, isNotNull, reason: 'El authorization token debe existir Después de un login');
}

void _testUpdateMobileToken(){
  test(_updateMobileTokenDescription, ()async{
    try{
      await _executeUpdateMobileTokenValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  });
}

Future<void> _executeUpdateMobileTokenValidations()async{
  _initUserServicesMIanager();
  final Map<String, dynamic> serviceResponse = await _uSManager.updateMobileToken(_newMobileToken);
  expect(serviceResponse['status'], 'ok', reason: 'El status message del service response debería ser <ok>');
  final String currentMobileToken = _userBloc.state.userInformation.mobileToken;
  expect(currentMobileToken, _newMobileToken, reason: 'El mobile token del userBloc debe ser el nuevo mobile token que se acaba de actualizar para el usuario');
}

Future<void> _login()async{
  final Map<String, dynamic> loginBody = {
    'email':_loginData['email'],
    'password':_loginData['password']
  };
  final Map<String, dynamic> loginResponse = await userService.login(loginBody);
  final String authorizationToken = loginResponse['token'];
  _userBloc.add(SetAuthorizationToken(authorizationToken: authorizationToken));
}



