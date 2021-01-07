import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/providers/push_notifications_provider.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/services/user_service.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_services_manager.dart';
import 'package:fanny_cliente/src/utils/navigation.dart';
import 'package:fanny_cliente/src/utils/shared_preferences.dart';
import 'package:fanny_cliente/src/models/usuarios_model.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:fanny_cliente/src/pages/pasos_confirmacion_celular_page.dart';
import 'package:fanny_cliente/src/utils/data_prueba/tienda_polygons.dart' as tiendaPolygons;

enum LoginProviders{
  GOOGLE,
  FACEBOOK,
  EMAIL
}

class UserServicesManager {

  // ******************* Modelo Singleton
  static final UserServicesManager _usManager = UserServicesManager._internal();
  UserServicesManager._internal();

  factory UserServicesManager({
    BuildContext appContext
  }){
    _initInitialElements(appContext);
    return _usManager;
  }
  
  static void _initInitialElements(BuildContext appContext){
    if(_usManager._appContext == null){
      _usManager.._appContext = appContext
      .._lugaresServicesManager = LugaresServicesManager(appContext: appContext)
      .._userBloc = BlocProvider.of<UserBloc>(appContext)
      .._polygonsBloc = BlocProvider.of<PolygonsBloc>(appContext);
    }
  }

  @protected
  factory UserServicesManager.forTesting({
    @required BuildContext appContext,
    @required UserBloc userBloc, 
    @required LugaresBloc lugaresBloc,
    @required PolygonsBloc polygonsBloc
  }){
    _initInitialTestingElements(appContext, userBloc, lugaresBloc, polygonsBloc);
    return _usManager;
  }

  static void _initInitialTestingElements(BuildContext appContext, UserBloc userBloc,  LugaresBloc lugaresBloc, PolygonsBloc polygonsBloc,){
    if(_usManager._appContext == null){
      _usManager.._appContext = appContext
      .._lugaresServicesManager = LugaresServicesManager.forTesting(appContext: appContext, userBloc: userBloc, lugaresBloc: lugaresBloc)
      .._userBloc = userBloc
      .._polygonsBloc = polygonsBloc;
    }
  }
  // ****************** Fin del modelo Singleton

  BuildContext _appContext;
  UserBloc _userBloc;
  PolygonsBloc _polygonsBloc;
  LugaresServicesManager _lugaresServicesManager;
  //TODO: Cambiar por el nuevo formato de bloc
  //final PedidosBloc _pedidosBloc;

  Future<Map<String, dynamic>> validarEmail(String email)async{
    final Map<String, dynamic> body = {'email':email};
    Map<String, dynamic> validarEmailResponse = await userService.validarEmail(body);
    if(validarEmailResponse['status'] == 'ok'){
      final String authorizationToken = validarEmailResponse['token'];
      _addAuthorizationTokenToBloc(authorizationToken);
      await _getUserInformation();
    }  
    return validarEmailResponse;
  }

  Future<void> login(String email, String password)async{
    try{
      final Map<String, dynamic> loginBody = {
        'email':email,
        'password':password
      };
      await _executeLogin(loginBody);
      await _getUserInformation();  
      await _doPostLoginConfiguration(loginBody);
    }on ServiceStatusErr catch(err){
      print(err);
    }catch(err){
      print(err);
    }
  }

  Future<void> _executeLogin(Map<String, dynamic> loginBody)async{
    Map<String, dynamic> loginResponse = await userService.login(loginBody);
    final String authorizationToken = loginResponse['token'];
    _addAuthorizationTokenToBloc(authorizationToken);
  }

  void _addAuthorizationTokenToBloc(String authorizationToken){
    final SetAuthorizationToken setAuthTokenEvent = SetAuthorizationToken(authorizationToken: authorizationToken);
    _userBloc.add(setAuthTokenEvent);
  }

  Future<void> _doPostLoginConfiguration(Map<String, dynamic> loginBody)async{
    if(_userBloc.state.userInformation.phoneVerify){
      //TODO: Implementar el proceso de pedidos validations
      await _doCurrentNewPedidoValidations();
      await _lugaresServicesManager.loadLugares();
      _addPolygons();
      await _doMobileTokenConfiguration(loginBody);
      await _doPostLoginInitializations(loginBody);
      Navigator.pushReplacementNamed(_appContext, HomePage.route);
    } 
    else
      Navigator.pushNamed(_appContext, PasosConfirmacionCelularPage.route);
  }

  Future<void> _doCurrentNewPedidoValidations()async{
    List<Map<String, dynamic>> pedidoActual = await sharedPreferencesUtils.getPedidoTemporal();   
  }

  void _addPolygons(){
    _polygonsBloc.add(AddPolygons(polygons: tiendaPolygons.tiendaPolygons));
  }

  Future<void> _doMobileTokenConfiguration(Map<String, dynamic> loginBody)async{
    final String newMobileToken = await PushNotificationsProvider.getMobileToken();
    final String mobileToken = _userBloc.state.userInformation.mobileToken;
    if(newMobileToken != mobileToken){
      await updateMobileToken(newMobileToken);
      _lugaresServicesManager.validarSiHayDirecciones();
    }
  }

  Future<void> _doPostLoginInitializations(Map<String, dynamic> loginBody)async{
    await _lugaresServicesManager.validateCurrentNewCacheLugar();
    //TODO: Reemplazar la línea de abajo
    //await _pedidosBloc.cargarPedidosAnterioresPorClienteOTienda(_userBloc.state.authorizationToken, 'cliente', null);
    sharedPreferencesUtils.normalLogin(loginBody['email'], loginBody['password']);  
    navigationUtils.reiniciarIndex();
  }

  Future<Map<String, dynamic>> updateMobileToken(String newMobileToken)async{
    final int userId = _userBloc.state.userInformation.id;
    final Map<String, String> headers = _createAuthorizationTokenHeader();
    Map<String, dynamic> body = {
      'mobile_token':newMobileToken,
      'user_id':userId
    };
    Map<String, dynamic> response = await userService.updateMobileToken(headers, body);
    await _getUserInformation();
    return response;
  }

  Future<UsuarioModel> _getUserInformation()async{
    try{
      Map<String, String> headers = _createAuthorizationTokenHeader();
      Map<String, dynamic> response = await userService.getUserInformation(headers);
      final UsuarioModel user = UsuarioModel.fromJsonMap(response['data']);
      final SetUserInformation setUserInformationEvent = SetUserInformation(user: user);
      _userBloc.add(setUserInformationEvent);
      return user;
    }on ServiceStatusErr catch(err){
      print(err);
    }catch(err){
      print(err);
    }
    return null; 
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
      await _getUserInformation();
      //TODO: Agregar al nuevo formato de UserBloc
    }
    return registerResponse;
  }

  Future<void> logOut(String authorizationToken)async{
    try{
      final serviceBody = {'token':authorizationToken};
      await userService.logout(serviceBody);
      _userBloc.add(Logout());
    }on ServiceStatusErr catch(err){
      print(err);
    }catch(err){
      print(err);      
    }
    /*
    if(response['status']=='ok'){
      this.usuario = null;
      this.token = null;
    }
    */
  }

  Map<String, String> _createAuthorizationTokenHeader(){
    final String authorizationToken = _userBloc.state.authorizationToken;
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

  //*********************************************************** */
  //    For testing
  //********************************************************** */
}

final UserServicesManager userServicesManager = UserServicesManager();