part of 'push_notifications_bloc.dart';

@immutable
abstract class PushNotificationsEvent {}

class SendPedidoFromCliente extends PushNotificationsEvent{

}

class ConfirmarPedidoFromTienda extends PushNotificationsEvent{
  final String nombreTienda;
  final String tiempoMaximoDeEntrega;

  ConfirmarPedidoFromTienda({
    @required this.nombreTienda,
    @required this.tiempoMaximoDeEntrega
  });
}

class DenegarPedidoFromTienda extends PushNotificationsEvent{
  final String nombreTienda;
  final String justificacion;

  DenegarPedidoFromTienda({
    @required this.nombreTienda,
    @required this.justificacion
  });
}

class CrearDomiciliarioFromTienda extends PushNotificationsEvent{
  String nombreTienda;

  CrearDomiciliarioFromTienda({
    @required this.nombreTienda
  });
}

class ResetCodigoDomiciliarioFromTienda extends PushNotificationsEvent{
  String nombreTienda;

  ResetCodigoDomiciliarioFromTienda({
    @required this.nombreTienda
  });
}

class DelegarPedidoADomiciliarioFromTienda extends PushNotificationsEvent{
  final String clienteMobileToken;
  final String tiendaMobileToken;
  final int pedidoId;
  final String nombreTienda;
  final String direccionDeEntrega;

  DelegarPedidoADomiciliarioFromTienda({
    @required this.clienteMobileToken,
    @required this.tiendaMobileToken,
    @required this.pedidoId,
    @required this.nombreTienda,
    @required this.direccionDeEntrega
  });
}

class ValidarFormularioDeNuevoDomiciliarioFromTienda extends PushNotificationsEvent{
  final String nombreTienda;
  
  ValidarFormularioDeNuevoDomiciliarioFromTienda({
    @required this.nombreTienda
  });
}

class AceptarPedidoTiendaFromDomiciliario extends PushNotificationsEvent{
  final String clienteMobileToken;
  final String nombreDomiciliario;

  AceptarPedidoTiendaFromDomiciliario({
    @required this.clienteMobileToken,
    @required this.nombreDomiciliario
  });
}

class DenegarPedidoFromDomiciliario extends PushNotificationsEvent{
  final String clienteMobileToken;
  final String nombreDomiciliario;
  final int pedidoId;

  DenegarPedidoFromDomiciliario({
    @required this.clienteMobileToken,
    @required this.nombreDomiciliario,
    @required this.pedidoId
  });
}