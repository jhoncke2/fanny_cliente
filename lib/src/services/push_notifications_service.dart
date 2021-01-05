import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fanny_cliente/src/bloc/push_notifications/push_notifications_bloc.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/models/push_notification_info.dart';
import 'package:fanny_cliente/src/services/basic_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;

class PushNotificationsService extends BasicService{
  static final _firebaseServerUrl = 'https://fcm.googleapis.com/fcm/send';
  static final _firebaseServerToken = 'AAAA4CBqs3c:APA91bGuz9vFuiAmNrfrDZ6OoISAuli_grwbkaR6hKHi6sIjtjVNs3c7WfZT6mP3Ftc6R8OgVN_yteCgW0RiNSiz_5qDr6IV9J3FJhlIqZhH5U96HSju75mpuOpayJeCNgPVf_srEPaq';
  
  static bool onPushNotification = false;
  static String mobileToken;
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final StreamController _innerPushNotificationsController = new StreamController<PushNotificationInfo>.broadcast();
  
  Stream<PushNotificationInfo> get innerPushNotificationStream => _innerPushNotificationsController.stream;
  bool yaInicio = false;
  String _currentOuterPNotificationTitle;
  String _currentOuterPNotificationBody;

  initNotificationsReceiver()async{
    //para obtener permisos del usuario
    yaInicio = true;
    _firebaseMessaging.requestNotificationPermissions();
    mobileToken = await _firebaseMessaging.getToken();
    _firebaseMessaging.configure(
      onBackgroundMessage: Platform.isIOS ? null: onBackgroundMessage,
      onMessage: _onMessage,
      onResume: _onResume,
      onLaunch: _onLaunch
    );
  }

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message)async{
    if(message.containsKey('data')){
      final dynamic data = message['data'];
      print('from background: data: $data');
    }
    if(message.containsKey('notification')){
      final dynamic notification = message['notification'];
      print('from background: notification: $notification');
    }
  }

  static Future<String> getMobileToken()async{
    //await _firebaseMessaging.requestNotificationPermissions();
    mobileToken = await _firebaseMessaging.getToken();
    return mobileToken;
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message)async{
    if(!onPushNotification){
      try{
        _reaccionarAPushNotification({
          'receiver_channel':'on_message',
          'data':message['data']
        });
      }catch(err){
        print('error en on Message: $err');
      }
    }
    onPushNotification = !onPushNotification;
  }

  Future<dynamic> _onResume(Map<String, dynamic> message)async{
    try{
      _reaccionarAPushNotification({
        'receiver_channel':'on_resume',
        'data':message['data'],
      });
    }catch(err){
      print('error en on Resume: $err');
    }
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message)async{
    try{
      _reaccionarAPushNotification({
        'receiver_channel':'on_launch',
        'data':message['data'],
      });
    }catch(err){
      print('error en on Launch: $err');
    }
  }

  Future<Map<String, dynamic>> sendSendPedidoFromClientePNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'nuevo pedido';
      _currentOuterPNotificationBody = 'Has recibido un nuevo pedido';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['tienda_mobile_token'], PushNotificationsBloc.clienteEnviarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }

  Future<Map<String, dynamic>> sendConfirmarPedidoFromTiendaPNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'pedido aceptado';
      _currentOuterPNotificationBody = '${bodyData["nombre_tienda"]} ha aceptado tu pedido. Este llegará en máximo ${bodyData['tiempo_maximo_entrega']}';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['cliente_mobile_token'], PushNotificationsBloc.tiendaConfirmarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
  Future<Map<String, dynamic>> sendDenegarPedidoFromTiendaPNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'pedido denegado';
      _currentOuterPNotificationBody = 'La tienda ha denegado tu pedido: ${bodyData['razon_tienda']}';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['cliente_mobile_token'], PushNotificationsBloc.tiendaDenegarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
  Future<Map<String, dynamic>> sendCrearDomiciliarioFromTiendaPNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'Solicitud de contrato';
      _currentOuterPNotificationBody = '${bodyData["nombre_tienda"]} desea vincularte como su domiciliario. Si deseas aceptar, comunicate con él y envíale el código que te llegará a la bandeja de mensajes.';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['tienda_mobile_token'], PushNotificationsBloc.clienteEnviarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
  Future<Map<String, dynamic>> sendResetCodigoDomiciliarioFromTiendaPNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'Solicitud de contrato';
      _currentOuterPNotificationBody = '${bodyData["nombre_tienda"]} ha solicitado un nuevo código para vincularte como su domiciliario. Por favor revisa tus mensajes.';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['tienda_mobile_token'], PushNotificationsBloc.clienteEnviarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
  Future<Map<String, dynamic>> sendDelegarPedidoADomiciliarioFromTiendaPNotification(Map<String, dynamic> bodyData)async{
    try{
     _currentOuterPNotificationTitle = 'Nueva entrega';
      _currentOuterPNotificationBody = 'Tienes un nuevo pedido para entregar';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['tienda_mobile_token'], PushNotificationsBloc.clienteEnviarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
  Future<Map<String, dynamic>> sendValidarFormularioDeNuevoDomiciliarioFromTiendaPNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'Ascendido a domiciliario';
      _currentOuterPNotificationBody = '¡Felicidades!, ahora eres un domiciliario de ${bodyData["nombre_tienda"]}';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['tienda_mobile_token'], PushNotificationsBloc.clienteEnviarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
  Future<Map<String, dynamic>> sendAceptarPedidoFromDomiciliarioPNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'Pedido aceptado';
      _currentOuterPNotificationBody = 'El domiciliario ${bodyData["nombre_domiciliario"]} ha aceptado el pedido que le encargaste';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['tienda_mobile_token'], PushNotificationsBloc.clienteEnviarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
  Future<Map<String, dynamic>> sendDenegarPedidoFromDomiciliarioPNotification(Map<String, dynamic> bodyData)async{
    try{
      _currentOuterPNotificationTitle = 'Pedido rechazado';
      _currentOuterPNotificationBody = 'El domiciliario ${bodyData["nombre_domiciliario"]} ha rechazado el pedido que le encargaste';
      Map<String, dynamic> pushNotifRequestBody = _defineSendPushNotificationRequestBody(bodyData['tienda_mobile_token'], PushNotificationsBloc.clienteEnviarPedido, bodyData);
      _executeSendPushNotificationRequest(pushNotifRequestBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }

  Map<String, dynamic> _defineSendPushNotificationRequestBody(String receiverMobileToken, String notificationType, 
                                                              Map<String, dynamic> bodyData){
    Map<String, dynamic> requestBody = {
      'priority':'high',
      'to':receiverMobileToken
    };
    requestBody['notification'] = {
      'title':_currentOuterPNotificationTitle,
      'body':_currentOuterPNotificationBody
    };
    bodyData['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
    bodyData['notification_type'] = notificationType;
    requestBody['data'] = bodyData;
    return requestBody;
  }

  Future<void> _executeSendPushNotificationRequest(Map<String, dynamic> requestBody)async{
    final http.Response serverResponse = await http.post(
      _firebaseServerUrl,
      headers: {
        'Authorization':'key=$_firebaseServerToken',
        'Content-Type':'Application/json'
      },
      body: json.encode(requestBody)
    );
    if(serverResponse.body != null)
      currentResponseBody = json.decode(serverResponse.body);
    else
      throw ServiceStatusErr(status: serverResponse.statusCode);     
  }

  void _reaccionarAPushNotification(Map<String, dynamic> notification){
    Map<String, dynamic> bodyData = (notification['data'] as Map).cast<String, dynamic>();
    String notificationType = bodyData['notification_type'];
    String receiverChannel = notification['receiver_channel'];
    final PushNotificationInfo pushNotificationInfo = PushNotificationInfo.innerNotification(
      receiverChannel: receiverChannel,
      bodyData: bodyData,
      notificationType: notificationType
    );
    _innerPushNotificationsController.sink.add(pushNotificationInfo);
  }

  void dispose(){
    _innerPushNotificationsController.close();
  }
}