import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_services_manager.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/services/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'current_testing_widget.dart';
import 'mock/blocs.dart';
import 'mock/build_context.dart';

final String _testingGroupDescription = 'Se testearán métodos de lugaresServicesManager';
final String _initLugaresServicesManagerDescription = 'Se inicializará LugaresServicesManager';
final String _createLugarDescription = 'Se intentará crear un lugar';

final Map<String, dynamic> _loginData = {
  'email':'filledMoon@gmail.com',
  'password':'12345678'
};
final BuildContext _context = MockBuildContext();
final UserBloc _userBloc = MockUserBloc();
final LugaresBloc _lugaresBloc = MockLugaresBloc();
String _authorizationToken;
LugaresServicesManager _lSManager;

void main(){
  group(_testingGroupDescription, (){
    _initLugaresServicesManager();
    _testCreateLugar();
  });
}

void _initLugaresServicesManager(){
  /** 
  testWidgets(_initLugaresServicesManagerDescription, (WidgetTester tester)async{
  //  _mCWidget = CurrentTestingWidget();
  //  tester.pumpWidget(_mCWidget);
  // _lSManager = LugaresServicesManager.forTesting(appContext: _mCWidget.appContext, userBloc: _userBloc, lugaresBloc: _lugaresBloc);
  });
  */
  _lSManager = LugaresServicesManager.forTesting(appContext: _context, userBloc: _userBloc, lugaresBloc: _lugaresBloc);
  
}

void _testCreateLugar(){
  try{
    test(_createLugarDescription,()async{
      await _executeCreateLugarValidations();
    });
  }catch(err){
    fail('No deberia haber ocurrido un error: $err');
  }
}

Future<void> _executeCreateLugarValidations()async{
  await _login();
  final LugarModel newLugar = LugarModel.fromJsonMap(_crearLugarUnicoFromDate());
  await _lSManager.createLugar(newLugar);
}


void _testLoadLugares(){
  try{
    test(_createLugarDescription,()async{
      await _executeLoadLugaresValidations();
    });
  }catch(err){
    fail('No deberia haber ocurrido un error: $err');
  }
}

Future<void> _executeLoadLugaresValidations()async{
  
}

void _test3(){
  try{
    test(_createLugarDescription,()async{
    });
  }catch(err){

  }
}

void _test4(){
  try{
    test(_createLugarDescription,()async{
    });
  }catch(err){

  }
}

void _test5(){
  try{
    test(_createLugarDescription,()async{
    });
  }catch(err){

  }
}

Future<void> _login()async{
  final Map<String, dynamic> loginBody = {
    'email':_loginData['email'],
    'password':_loginData['password']
  };
  final Map<String, dynamic> loginResponse = await userService.login(loginBody);
  _authorizationToken = loginResponse['token'];
  _userBloc.add(SetAuthorizationToken(authorizationToken: _authorizationToken));
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