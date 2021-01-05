import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/models/push_notification_info.dart';
import 'package:fanny_cliente/src/bloc/push_notifications/push_notifications_bloc.dart';
import 'package:fanny_cliente/src/pages/pedidos_page.dart';

class PushNotificationsReacter{
  BuildContext _context;
  Size _size;

  String _currentJustificacionDeTiendaRechazoPedido;

  void reaccionarAPushNotification(PushNotificationInfo info){
    Map<String, dynamic> pushNotifData = info.bodyData ;
    String notificationType = info.notificationType;
    String receiverChannel = info.receiverChannel;
    switch(pushNotifData['notification_type']){
      case 'tienda_confirmar_pedido':
        _reaccionarATiendaAceptarPedido(receiverChannel, pushNotifData);
        break;
      case 'tienda_denegar_pedido':
        _reaccionarATiendaDenegarPedido(receiverChannel, pushNotifData);
        break;
      case 'domiciliario_aceptar_pedido':
        _reaccionarADomiciliarioAceptarPedido(receiverChannel, pushNotifData);
        break;
    }
  }

  void _reaccionarATiendaAceptarPedido(String receiverChannel, Map<String, dynamic> pushNotifData){  
    String nombreTienda = pushNotifData['nombre_tienda'];
    String tiempoMaximoEntrega = pushNotifData['tiempo_maximo_entrega'];
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        _crearBasicNavigationDialog(
          _context,
          '$nombreTienda ha aceptado tu pedido. Este llegará en máximo $tiempoMaximoEntrega minutos',
          PedidosPage.route
        );
      }else if(receiverChannel == 'on_resume'){
        print('tiendaAceptóPedido on resume');
      }
    }
  }

  void _reaccionarATiendaDenegarPedido(String receiverChannel, Map<String, dynamic> pushNotifData){ 
    String nombreTienda = pushNotifData['nombre_tienda'];
    String razonTienda = pushNotifData['razon_tienda'];
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        _crearBasicNavigationDialog(
          _context,
          '$nombreTienda ha denegado tu pedido debido a lo siguiente: \n$razonTienda',
          PedidosPage.route
        );
      }else if(receiverChannel == 'on_resume'){
        print('tienda denegó pedido  onesume');
      }
    }
  }

  void _reaccionarADomiciliarioAceptarPedido(String receiverChannel, Map<String, dynamic> pushNotifData){
    String clienteMobileToken = pushNotifData['cliente_mobile_token'];
    String nombreDomiciliario = pushNotifData['nombre_domiciliario'];
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        _crearBasicNavigationDialog(
          _context,
          '$nombreDomiciliario ha aceptado tu pedido.',
          PedidosPage.route
        );
        Provider.pushNotificationsProvider(_context).sendPushNotification(
          clienteMobileToken, 
          PushNotificationsBloc.tiendaConfirmarPedido,
          {
            'nombre_tienda':Provider.usuarioBloc(_context).usuario.name,
            'tiempo_maximo_entrega':60
          }
        );
      }else if(receiverChannel == 'on_resume'){
        print('on resume');
      }
    }
  }

  void _crearBasicNavigationDialog(BuildContext context, String mensaje, String pageRoute){
    Size  size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        _context = context;
        return _crearBasicNavigationDialogBuilder(size, mensaje, pageRoute);
      },
    );
  }

  Widget _crearBasicNavigationDialogBuilder(Size size, String mensaje, String pageRoute){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(0.0),
        height: size.height * 0.2,
        child: _crearTextOfBasicNavigationDialogBuilder(size, mensaje)
      ),
      onTap: (){
        if(pageRoute != null)
          Navigator.of(_context).pushNamed(pageRoute);
      },
    );
  }

  Widget _crearTextOfBasicNavigationDialogBuilder(Size size, String mensaje){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          mensaje,
          style: TextStyle(
            color: Colors.black,
            fontSize: size.width * 0.045
          ),
        )
      ],
    );
  }

  set contextConfiguration(BuildContext newContext){
    this._context = newContext;
    this._size = MediaQuery.of(_context).size;
  }

  void _navigateTo(String routeName){
    Navigator.of(_context).pushNamed(routeName);
  }
}