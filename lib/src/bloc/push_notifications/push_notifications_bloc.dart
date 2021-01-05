import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/models/push_notification_info.dart';
import 'package:fanny_cliente/src/bloc/push_notifications/push_notifications_reacter.dart';
import 'package:fanny_cliente/src/services/push_notifications_service.dart';

part 'push_notifications_event.dart';
part 'push_notifications_state.dart';

class PushNotificationsBloc extends Bloc<PushNotificationsEvent, PushNotificationsState> {
  static const String clienteEnviarPedido = 'enviar_pedido_from_cliente';
  static const String tiendaConfirmarPedido ='confirmar_pedido_from_tienda';
  static const String tiendaDenegarPedido ='denegar_pedido_from_tienda';
  static const String tiendaDelegarPedidoADomiciliario ='delegar_pedido_a_domiciliario_from_tienda';
  static const String tiendaCrearDomiciliario ='crear_domiciliario_from_tienda';
  static const String tiendaResetearCodigoDomiciliario='resetear_codigo_domiciliario_from_tienda';
  static const String tiendaValidarDomiciliario ='validar_domiciliario_from_tienda';
  static const String domiciliarioAceptarPedido ='aceptar_pedido_from_domiciliario';
  static const String domiciliarioDenegarPedido ='denegar_pedido_from_domiciliario';

  final PushNotificationsService _pushNotificationsService = PushNotificationsService();
  final PushNotificationsReacter _pushNotificationsReacter = PushNotificationsReacter();
  Stream<PushNotificationInfo> _innerPushNotificationStream;

  PushNotificationsBloc(): super(PushNotificationsState()){
    _pushNotificationsService.initNotificationsReceiver();
    _innerPushNotificationStream = _pushNotificationsService.innerPushNotificationStream;
    //TODO: probar que funcione
    _innerPushNotificationStream.listen((PushNotificationInfo innerPushNotificationInfo) { 
      print(innerPushNotificationInfo.toString());
      _pushNotificationsReacter.reaccionarAPushNotification(innerPushNotificationInfo);
    });
  }

  void sendPushNotificationFromOuterPushNotifStream(){

  }

  @override
  Stream<PushNotificationsState> mapEventToState(
    PushNotificationsEvent event,
  ) async* {
    // TODO: implement mapEventToState
    Map<String, dynamic> bodyData;
    switch(event.runtimeType){
      case SendPedidoFromCliente:
        bodyData = _createSendPedidoPorClienteBodyData(event);
        _pushNotificationsService.sendSendPedidoFromClientePNotification(bodyData);
        yield state;
      break;
      case ConfirmarPedidoFromTienda:
        bodyData = _createConfirmarPedidoFromTiendaBodyData((event as ConfirmarPedidoFromTienda));
        _pushNotificationsService.sendConfirmarPedidoFromTiendaPNotification(bodyData);
        yield state;
      break;
      case DenegarPedidoFromTienda:
        bodyData = _createDenegarPedidoFromTiendaBodyData((event as DenegarPedidoFromTienda));
        _pushNotificationsService.sendDenegarPedidoFromTiendaPNotification(bodyData);
        yield state;
      break;
      case CrearDomiciliarioFromTienda:
        bodyData = _createCrearDomiciliarioFromTiendaBodyData((event as CrearDomiciliarioFromTienda));
        _pushNotificationsService.sendCrearDomiciliarioFromTiendaPNotification(bodyData);
        yield state;
      break;
      case ResetCodigoDomiciliarioFromTienda:
        bodyData = _createResetCodigoDomiciliarioFromTiendaBodyData((event as ResetCodigoDomiciliarioFromTienda));
        _pushNotificationsService.sendResetCodigoDomiciliarioFromTiendaPNotification(bodyData);
        yield state;
      break;
      case DelegarPedidoADomiciliarioFromTienda:
        bodyData = _createDelegarPedidoADomiciliarioFromTiendaBodyData((event as DelegarPedidoADomiciliarioFromTienda));
        _pushNotificationsService.sendDelegarPedidoADomiciliarioFromTiendaPNotification(bodyData);
        yield state;
      break;
      case ValidarFormularioDeNuevoDomiciliarioFromTienda:
        bodyData = _createValidarFormularioDeNuevoDomiciliarioFromTiendaBodyData((event as ValidarFormularioDeNuevoDomiciliarioFromTienda));
        _pushNotificationsService.sendValidarFormularioDeNuevoDomiciliarioFromTiendaPNotification(bodyData);
        yield state;
      break;
      case AceptarPedidoTiendaFromDomiciliario:
        bodyData = _createAceptarPedidoFromDomiciliarioBodyData((event as AceptarPedidoTiendaFromDomiciliario));
        _pushNotificationsService.sendAceptarPedidoFromDomiciliarioPNotification(bodyData);
        yield state;
      break;
      case DenegarPedidoFromDomiciliario:
        bodyData = _createDenegarPedidoFromDomiciliarioBodyData((event as DenegarPedidoFromDomiciliario));
        _pushNotificationsService.sendDenegarPedidoFromDomiciliarioPNotification(bodyData);
        yield state;
      break;
    }
  }

  Map<String, dynamic> _createSendPedidoPorClienteBodyData(SendPedidoFromCliente event){
    return {};
  }
  Map<String, dynamic> _createConfirmarPedidoFromTiendaBodyData(ConfirmarPedidoFromTienda event){
    String nombreTienda = event.nombreTienda;
    String tiempoMaximoDeEntrega = event.tiempoMaximoDeEntrega;
    return {
      'nombre_tienda':nombreTienda,
      'tiempo_maximo_de_entrega':tiempoMaximoDeEntrega
    };
  }
  Map<String, dynamic> _createDenegarPedidoFromTiendaBodyData(DenegarPedidoFromTienda event){
    String nombreTienda = event.nombreTienda;
    String justificacion = event.justificacion;
    return {
      'nombre_tienda':nombreTienda,
      'justificacion':justificacion
    };
  }
  Map<String, dynamic> _createCrearDomiciliarioFromTiendaBodyData(CrearDomiciliarioFromTienda event){
    String nombreTienda = event.nombreTienda;
    return {
      'nombre_tienda':nombreTienda
    };
  }
  Map<String, dynamic> _createResetCodigoDomiciliarioFromTiendaBodyData(ResetCodigoDomiciliarioFromTienda event){
    String nombreTienda = event.nombreTienda;
    return {
      'nombre_tienda':nombreTienda
    };
  }
  Map<String, dynamic> _createDelegarPedidoADomiciliarioFromTiendaBodyData(DelegarPedidoADomiciliarioFromTienda event){
    String clienteMobileToken = event.clienteMobileToken;
    String tiendaMobileToken = event.tiendaMobileToken;
    String direccionDeEntrega = event.direccionDeEntrega;
    String nombreTienda = event.nombreTienda;
    int pedidoId = event.pedidoId;
    return {
      'cliente_mobile_token':clienteMobileToken,
      'tienda_mobile_token':tiendaMobileToken,
      'direccion_de_entrega':direccionDeEntrega,
      'nombre_tienda':nombreTienda,
      'pedido_id':pedidoId
    };
  }
  Map<String, dynamic> _createValidarFormularioDeNuevoDomiciliarioFromTiendaBodyData(ValidarFormularioDeNuevoDomiciliarioFromTienda event){
    String nombreTienda = event.nombreTienda;
    return {
      'nombre_tienda':nombreTienda
    };
  }
  Map<String, dynamic> _createAceptarPedidoFromDomiciliarioBodyData(AceptarPedidoTiendaFromDomiciliario event){
    String clienteMobileToken = event.clienteMobileToken;
    String nombreDomiciliario = event.nombreDomiciliario;
    return {
      'cliente_mobile_token':clienteMobileToken,
      'nombre_domiciliario':nombreDomiciliario
    };
  }
  Map<String, dynamic> _createDenegarPedidoFromDomiciliarioBodyData(DenegarPedidoFromDomiciliario event){
    String clienteMobileToken = event.clienteMobileToken;
    String nombreDomiciliario = event.nombreDomiciliario;
    int pedidoId = event.pedidoId;
    return {
      'cliente_mobile_token':clienteMobileToken,
      'nombre_domiciliario':nombreDomiciliario,
      'pedido_id':pedidoId
    };
  }

  String get mobileToken => PushNotificationsService.mobileToken;
}