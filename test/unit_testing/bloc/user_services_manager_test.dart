import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'mock/blocs.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/bloc/user/user_services_manager.dart';
import 'mock/build_context.dart';

final String _testingGroupDescription = 'Se testearán métodos de userServicesManager';
final String _loginDescription = 'Se intentará loggear al usuario, pasando todas las validaciones del login';
final String _updateMobileTokenDescription = 'Se intentará actualizar el mobile token del usuario actual';
final String _logoutDescription = 'Se intentará ejecutar un logout';

final Map<String, dynamic> _loginData = {
  'email':'filledMoon@gmail.com',
  'password':'12345678'
};
final BuildContext _context = MockBuildContext();
final UserBloc _userBloc = MockUserBloc();
final LugaresBloc _lugaresBloc = MockLugaresBloc();
final PolygonsBloc _polygonsBloc = PolygonsBloc();
String _newMobileToken;

UserServicesManager _uSManager;

void _initUserServicesManager(){
  _uSManager = UserServicesManager.forTesting(appContext: _context, userBloc: _userBloc, polygonsBloc: _polygonsBloc, lugaresBloc: _lugaresBloc);
}

void main(){
  //_initInitialVariables();
  
  group(_testingGroupDescription, (){
    _testLogin();
    _testUpdateMobileToken();
    _testLogout();
  });
}

void _testLogin(){
  test(_loginDescription, ()async{
    try{
      await _executeLoginValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería haber ocurrido un ServiceStatusErr: ${err.status}/${err.extraInformation}');
    }on TestFailure catch(err){
      fail('$err');
    }catch(err){
      fail('No debería haber ocurrido un error: $err');
    }
  });
}

Future<void> _executeLoginValidations()async{
  _initUserServicesManager();
  await _uSManager.login(_loginData['email'], _loginData['password']);
  expect(_userBloc.state.authorizationToken, isNotNull, reason: 'El authorization token debe existir Después de un login');
  expect(_userBloc.state.userInformation, isNotNull, reason: 'El userInformation debe existir después del proceso de login');
}

void _testUpdateMobileToken(){
  test(_updateMobileTokenDescription, ()async{
    try{
      await _executeUpdateMobileTokenValidations();
    }on ServiceStatusErr catch(err){
      fail('No deberia ocurrir un ServiceStatusErr: ${err.status} || ${err.extraInformation}');      
    }on TestFailure catch(err){
      fail('$err');
    }catch(err){
      fail('No debería ocurrir un error: $err');
    }
  });
}

Future<void> _executeUpdateMobileTokenValidations()async{
  _generateNewMobileToken();
  _initUserServicesManager();
  final Map<String, dynamic> serviceResponse = await _uSManager.updateMobileToken(_newMobileToken);
  expect(serviceResponse['data'], isNotNull, reason: 'El status message del service response debería ser <ok>');
  final String currentMobileToken = _userBloc.state.userInformation.mobileToken;
  expect(currentMobileToken, _newMobileToken, reason: 'El mobile token del userBloc debe ser el nuevo mobile token que se acaba de actualizar para el usuario');
}

void _testLogout(){
  test(_logoutDescription, ()async{
    try{
      await _executeLogoutValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería ocurrir un ServiceStatusErr: ${err.status} || ${err.extraInformation}');
    }on TestFailure catch(err){
      fail('$err');
    }catch(err){
      fail('No debería ocurrir un error: $err');
    }
  });
}

Future<void> _executeLogoutValidations()async{
  final String authorizationToken = _userBloc.state.authorizationToken;
  await _uSManager.logOut(authorizationToken);
  final UserState state = _userBloc.state;
  expect(state.authorizationToken, isNull, reason: 'Después de un logout exitoso el authorization token del state debe ser null');
  expect(state.userInformation, isNull, reason: 'Después de un logout exitoso el userInformation del state debe ser null');
}

void _generateNewMobileToken(){
  final DateTime nowDate = DateTime.now();
  final String uniqueString = '${nowDate.year}_${nowDate.month}_${nowDate.day}_${nowDate.hour}_${nowDate.minute}_${nowDate.second}';
  _newMobileToken = uniqueString;
}