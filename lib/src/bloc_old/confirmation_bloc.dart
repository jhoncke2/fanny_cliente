import 'package:rxdart/rxdart.dart';
import 'package:fanny_cliente/src/providers/confirmation_provider.dart';

class ConfirmationBloc{
  ConfirmationProvider _confirmationProvider = new ConfirmationProvider();

  String _emailPasswordConfirmation;
  String _newPhoneConfirmation;

  final _pasoPasswordSuperadoController = new BehaviorSubject<String>();
  final _pasoPhoneSuperadoController = new BehaviorSubject<String>();
  //final _cargandoController = new BehaviorSubject<bool>();

  Stream<String> get pasoPasswordSuperadoStream => _pasoPasswordSuperadoController.stream;
  Stream<String> get pasoPhoneSuperadoStream => _pasoPhoneSuperadoController.stream;

  String get emailPasswordConfirmation => _emailPasswordConfirmation;
  String get newPhoneConfirmation => _newPhoneConfirmation;

  void set newPhoneConfirmation(String newPhone){
    _newPhoneConfirmation = newPhone;
  }

  //*********************************** 
  //  Recuperar contraseña
  //**********************************

  Future<Map<String, dynamic>> enviarCorreoRecuperarPassword(String email)async{
    _emailPasswordConfirmation = email;
    Map<String, dynamic> respuesta = await _confirmationProvider.enviarCorreoRecuperarPassword(email);
    if(respuesta['status'] == 'ok')
      _pasoPasswordSuperadoController.sink.add('email');
    return respuesta;
  }

  Future<Map<String, dynamic>> enviarCodigoRecuperarPassword(String email, String code)async{
    Map<String, dynamic> respuesta = await _confirmationProvider.enviarCodigoRecuperarPassword(email, code);
    if(respuesta['status'] == 'ok')
      _pasoPasswordSuperadoController.sink.add('code');
    return respuesta;
  }

  Future<Map<String, dynamic>> enviarPasswordRecuperarPassword(String email, String password, String passwordConfirmation)async{
    Map<String, dynamic> respuesta = await _confirmationProvider.enviarPasswordRecuperarPassword(email, password, passwordConfirmation);
    if(respuesta['status'] == 'ok')
      _pasoPasswordSuperadoController.sink.add('password');
    return respuesta;
  }

  Future<Map<String, dynamic>> resetCode(String token, String tipoConfirmacion, String credencial)async{
    final respuesta = await _confirmationProvider.resetCode(token, tipoConfirmacion, credencial);
    return respuesta;
  }

  //*********************************** 
  //  Recuperar contraseña
  //**********************************

  Future<Map<String, dynamic>> enviarCodigoConfirmarPhone(String token, int id, String code)async{
    final respuesta = await _confirmationProvider.enviarCodigoConfirmarPhone(token, id, code);
    if(respuesta['status'] == 'ok')
      _pasoPhoneSuperadoController.sink.add('code');
    return respuesta;
  }


  //*********************************** 
  //  Confirmar domiciliario
  //**********************************
  Future<Map<String, dynamic>> enviarCodigoValidarDomiciliario(String token, int domiciliarioId, String code)async{
    final respuesta = await _confirmationProvider.enviarCodigoValidarDomiciliario(token, domiciliarioId, code);
    return respuesta;
  }

  Future<Map<String, dynamic>> resetCodeDomiciliario(String token, int domiciliarioId)async{
    final respuesta = await _confirmationProvider.resetCodeDomiciliario(token, domiciliarioId);
    return respuesta;
  }

  void dispose(){
    _pasoPasswordSuperadoController.close();
  }
}