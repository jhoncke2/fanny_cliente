import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:fanny_cliente/src/pages/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider{
  static bool onPushNotification = false;
  static final _firebaseServerUrl = 'https://fcm.googleapis.com/fcm/send';
  static final _firebaseServerToken = 'AAAA3uYRq0k:APA91bHim1CA93N6ph0tu-y0ZGV04DGVyJS2FYhyj8PYvzUV3xIkSVFRuDJUt-AAAAR3LtH6s:APA91bFAb-FkEtILV8_gk3z-LT8BDufYRzocEMS4cTohAv08HJRChxBuHr4Ayqw1ct_jyAdK1ysRmdoVyXZeyJEhojcLnQegg9UW7-YqI_8CUtOEhRuscEtG9ICUH43B9wvX8QXQFRPQ';

  static final notificationTypes = [
    'cliente_enviar_pedido', 
    'tienda_confirmar_pedido', 
    'tienda_denegar_pedido',
    'tienda_delegar_pedido_a_domiciliario',
    'tienda_crear_domiciliario',
    'tienda_resetear_codigo_domiciliario',
    'tienda_validar_domiciliario',
    'domiciliario_aceptar_pedido',
    'domiciliario_denegar_pedido'
  ];

  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _pushReceiverController = new StreamController<Map<String,dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get pushReceiverStream => _pushReceiverController.stream;
  static String mobileToken;
  bool yaInicio = false;
  BuildContext _context;

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message)async{
      if(message.containsKey('data')){
        final dynamic data = message['data'];
        print('from background: data: $data');
      }
      if(message.containsKey('notificatoin')){
        final dynamic notification = message['notification'];
        print('from background: notification: $notification');
      }
  }

  static Future<String> getMobileToken()async{
    //await _firebaseMessaging.requestNotificationPermissions();
    //mobileToken = await _firebaseMessaging.getToken();
    print('=============mobile token==================');
    print(mobileToken);
    return mobileToken;
  }

  initNotificationsReceiver()async{
    //para obtener permisos del usuario
    yaInicio = true;
    _firebaseMessaging.requestNotificationPermissions();
    mobileToken = await _firebaseMessaging.getToken();
    print('mobile token:');
    print(mobileToken);
    _firebaseMessaging.configure(
      onBackgroundMessage: Platform.isIOS ? null: onBackgroundMessage,
      onMessage: onMessage,
      onResume: onResume,
      onLaunch: onLaunch
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message)async{
    if(!onPushNotification){
      print('======on message =======');
      print(message);
      try{
        _pushReceiverController.sink.add({
          'receiver_channel':'on_message',
          'data':message['data']
        });
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

  Future<dynamic> onResume(Map<String, dynamic> message)async{
    print('======on message =======');
    print(message);
    try{
      _pushReceiverController.sink.add({
        'receiver_channel':'on_resume',
        'data':message['data']
      });
      _reaccionarAPushNotification({
        'receiver_channel':'on_resume',
        'data':message['data'],
      });
    }catch(err){
      print('error en on Resume: $err');
    }
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message)async{
    print('======on message =======');
    print(message);
    try{
      _pushReceiverController.sink.add({
        'receiver_channel':'on_launch',
        'data':message['data']
      });
      _reaccionarAPushNotification({
        'receiver_channel':'on_launch',
        'data':message['data'],
      });
    }catch(err){
      print('error en on Launch: $err');
    }
  }

  Future<Map<String, dynamic>> sendPushNotification(String receiverMobileToken, String notificationType, Map<String, dynamic> data)async{
    try{
      Map<String, dynamic> body = {
        'priority':'high',
        'to':receiverMobileToken
      };
      data['id']='1';
      data['status']='done';
      data['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
      data['notification_type'] = notificationType;
      body['data'] = data;
      String notificationTitle;
      String notificationBody;
      switch(notificationType){
        case 'cliente_enviar_pedido':
          notificationTitle = 'nuevo pedido';
          notificationBody = 'Has recibido un nuevo pedido';
          break;
        case 'tienda_confirmar_pedido':
          notificationTitle = 'pedido aceptado';
          notificationBody = '${data["nombre_tienda"]} ha aceptado tu pedido. Este llegará en máximo ${data['tiempo_maximo_entrega']}';
          break;
        case 'tienda_denegar_pedido':
          notificationTitle = 'pedido denegado';
          notificationBody = 'La tienda ha denegado tu pedido: ${data['razon_tienda']}';
          break;
        case 'tienda_delegar_pedido_a_domiciliario':
          notificationTitle = 'Nueva entrega';
          notificationBody = 'Tienes un nuevo pedido para entregar';
          break;
        case 'tienda_crear_domiciliario':
          notificationTitle = 'Solicitud de contrato';
          notificationBody = '${data["nombre_tienda"]} desea vincularte como su domiciliario. Si deseas aceptar, comunicate con él y envíale el código que te llegará a la bandeja de mensajes.';
          break;

        case 'tienda_resetear_codigo_domiciliario':
          notificationTitle = 'Solicitud de contrato';
          notificationBody = '${data["nombre_tienda"]} ha solicitado un nuevo código para vincularte como su domiciliario. Por favor revisa tus mensajes.';
          break;
        case 'tienda_validar_domiciliario':
          notificationTitle = 'Ascendido a domiciliario';
          notificationBody = '¡Felicidades!, ahora eres un domiciliario de ${data["nombre_tienda"]}';
          break;
        case 'domiciliario_aceptar_pedido':
          notificationTitle = 'Pedido aceptado';
          notificationBody = 'El domiciliario ${data["nombre_domiciliario"]} ha aceptado el pedido que le encargaste';
          break;
        case 'domiciliario_denegar_pedido':
          notificationTitle = 'Pedido rechazado';
          notificationBody = 'El domiciliario ${data["nombre_domiciliario"]} ha rechazado el pedido que le encargaste';
          break;
      }

      body['notification'] = {
        'title':notificationTitle,
        'body':notificationBody
      };
      final response = await http.post(
        _firebaseServerUrl,
        headers: {
          'Authorization':'key=$_firebaseServerToken',
          'Content-Type':'Application/json'
        },
        body: json.encode(body)
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'response':decodedResponse
      };


    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
    
  }

  void _reaccionarAPushNotification(Map<String, dynamic> notification){
    Map<String, dynamic> data = (notification['data'] as Map).cast<String, dynamic>();
    String receiverChannel = notification['receiver_channel'];
    switch(data['notification_type']){
      case 'cliente_enviar_pedido':
        _reaccionarAClienteEnviarPedido(receiverChannel);
        break; 
      case 'tienda_confirmar_pedido':
        _reaccionarATiendaAceptarPedido(receiverChannel, data['nombre_tienda'], data['tiempo_maximo_entrega']);
        break;
      case 'tienda_denegar_pedido':
        _reaccionarATiendaDenegarPedido(receiverChannel, data['nombre_tienda'], data['razon_tienda']);
        break;
      
      case 'tienda_crear_domiciliario':
        _reaccionarATiendaCrearDomiciliario(receiverChannel, data['nombre_tienda']);
        break;
      case 'tienda_resetear_codigo_domiciliario':
        _reaccionarATiendaResetearCodigoDomiciliario(receiverChannel, data['nombre_tienda']);
        break;
      case 'tienda_delegar_pedido_a_domiciliario':
        _reaccionarATiendaDelegarPedidoADomiciliario(receiverChannel, data['pedido_id'], data['cliente_mobile_token'], data['tienda_mobile_token'], data['nombre_tienda'], data['direccion_domicilio']);
        break; 
      case 'tienda_validar_domiciliario':
        _reaccionarATiendaValidarFormulario(receiverChannel, data['nombre_tienda']);
        break;
      case 'domiciliario_aceptar_pedido':
        _reaccionarADomiciliarioAceptarPedido(receiverChannel, data['cliente_mobile_token'], data['nombre_domiciliario']);
        break;
      case 'domiciliario_denegar_pedido':
        _reaccionarADomiciliarioDenegarPedido(receiverChannel, int.parse(data['pedido_id']), data['cliente_mobile_token'], data['nombre_domiciliario']);
        break; 
    }
    print('Recibiendo data de push notification en el main:');
    print(data);
  }

  void _reaccionarAClienteEnviarPedido(String receiverChannel){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(Provider.usuarioBloc(_context).usuario.hasStore){
        if(receiverChannel == 'on_message')
          print('on_message');
          /*
          _crearDialog(
            _context,
            'te ha llegado un nuevo pedido',
            //en realidad debe ser PedidosActualesPage.route
            SolicitudDePedidosPage.route
          );
          */
        else if(receiverChannel == 'on_resume')
        /*
          Navigator.of(_context).pushNamed(SolicitudDePedidosPage
          .route);
          */
          print('on_resume');
        
      }
    }else{
      Navigator.of(_context).pushNamed(LoginPage.route);
    }
  }

  void _reaccionarATiendaAceptarPedido(String receiverChannel, String nombreTienda, int tiempoMaximoEntrega){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        /*
        _crearDialog(
          _context,
          '$nombreTienda ha aceptado tu pedido. Este llegará en máximo $tiempoMaximoEntrega minutos',
          PedidosPage.route
        );
        */
        print('Tienda aceptó pedido: on_message');
      }else if(receiverChannel == 'on_resume'){
        print('Tienda aceptó pedido: on_resume');
      }
    }
  }

  void _reaccionarATiendaDenegarPedido(String receiverChannel, String nombreTienda, String razon){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        /*
        _crearDialog(
          _context,
          '$nombreTienda ha denegado tu pedido debido a lo siguiente: \n$razon',
          PedidosPage.route
        );
        */
        print('tienda denegó pedido: on_message');
      }else if(receiverChannel == 'on_resume'){
        print('tienda denegó pedido: on_resume');
      }
    }
  }

  void _reaccionarATiendaCrearDomiciliario(String receiverChannel, String nombreTienda){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        _crearDialog(
          _context,
         '$nombreTienda quiere hacerte su domiciliario. Si deseas aceptar, comunicate con él y envíale el código que te llegará a la bandeja de mensajes.',
          null
        );
      }else if(receiverChannel == 'on_resume'){
        _crearDialog(
          _context,
         '$nombreTienda quiere hacerte su domiciliario. Si deseas aceptar, comunicate con él y envíale el código que te llegará a la bandeja de mensajes.',
          null
        );
      }
    }
  }

  void _reaccionarATiendaResetearCodigoDomiciliario(String receiverChannel, String nombreTienda){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        _crearDialog(
          _context,
         '$nombreTienda ha generado un nuevo código para hacerte su domiciliario. Si deseas aceptar, comunicate con él y envíale el código que te llegará a la bandeja de mensajes.',
          null
        );
      }else if(receiverChannel == 'on_resume'){
        _crearDialog(
          _context,
         '$nombreTienda ha generado un nuevo código para hacerte su domiciliario. Si deseas aceptar, comunicate con él y envíale el código que te llegará a la bandeja de mensajes.',
          null
        );
      }
    }
  }

  void _reaccionarATiendaDelegarPedidoADomiciliario(String receiverChannel, int pedidoId, String clienteMobileToken, String tiendaMobileToken, String nombreTienda, String direccion){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        _crearDialogAceptarCancelar(
          _context,
          pedidoId,
          clienteMobileToken,
          tiendaMobileToken,
          '$nombreTienda te ha designado un nuevo domicilio para entregar en $direccion',
          null
        );
      }else if(receiverChannel == 'on_resume'){
        _crearDialogAceptarCancelar(
          _context,
          pedidoId,
          clienteMobileToken,
          tiendaMobileToken,
          '$nombreTienda te ha designado un nuevo domicilio para entregar en $direccion',
          null
        );
      }
    }
  }

  void _reaccionarATiendaValidarFormulario(String receiverChannel, String nombreTienda){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        _crearDialog(
          _context,
         '¡Felicidades!, ahora eres un domiciliario de $nombreTienda.',
          null
        );
      }else if(receiverChannel == 'on_resume'){
        _crearDialog(
          _context,
         '¡Felicidades!, ahora eres un domiciliario de $nombreTienda.',
          null
        );
      }
    }
  }

  void _reaccionarADomiciliarioAceptarPedido(String receiverChannel, String clienteMobileToken, String nombreDomiciliario){
    if(Provider.usuarioBloc(_context).usuario != null){
      
      if(receiverChannel == 'on_message'){
        /*
        _crearDialog(
          _context,
          '$nombreDomiciliario ha aceptado tu pedido.',
          PedidosPage.route
        );
        */
        print('Domiciliario aceptó pedido: on_message');
        sendPushNotification(
          clienteMobileToken, 
          notificationTypes[1],
          {
            'nombre_tienda':Provider.usuarioBloc(_context).usuario.name,
            'tiempo_maximo_entrega':60
          }
        );
      }else if(receiverChannel == 'on_resume'){
        print('Domiciliario aceptó pedido: on_resume');
      }
    }
  }

  void _reaccionarADomiciliarioDenegarPedido(String receiverChannel, int pedidoId, String clienteMobileToken, String nombreDomiciliario){
    if(Provider.usuarioBloc(_context).usuario != null){
      if(receiverChannel == 'on_message'){
        /*
        _crearDialogNuevoDomiciliarioORechazar(
          _context,
          pedidoId,
          clienteMobileToken,
          '$nombreDomiciliario ha rechazado tu pedido.',
          PedidosPage.route
        );
        */
        print('Domiciliario denegó pedido: on_message');
      }else if(receiverChannel == 'on_resume'){
        print('Domiciliario denegó pedido: on_resume');
      }
    }
  }

  void _crearDialog(BuildContext context, String mensaje, String pageRoute){
    Size  size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.all(0.0),
            height: size.height * 0.2,
            child: Column(
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
            ),
          ),
          onTap: (){
            if(pageRoute != null)
              Navigator.of(context).pushNamed(pageRoute);
          },
        );
      },

    );
  }


  void _crearDialogAceptarCancelar(BuildContext context, int pedidoId, String clienteMobileToken, String tiendaMobileToken, String mensaje, String pageRoute){
    Size  size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.all(0.0),
            height: size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  mensaje,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.045
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.045)
                      ),
                      color: Colors.grey.withOpacity(0.9),
                      child: Text(
                        'Rechazar',
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        sendPushNotification(
                          tiendaMobileToken, 
                          notificationTypes[8], 
                          {
                            'pedido_id':pedidoId,
                            'nombre_domiciliario':Provider.usuarioBloc(context).usuario.name,
                            'cliente_mobile_token':clienteMobileToken
                          }
                        );
                        Navigator.of(context).pushNamed(HomePage.route);
                      },
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.045)
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        _domiciliarioAceptarPedido(
                          Provider.usuarioBloc(context).token,
                          clienteMobileToken,
                          tiendaMobileToken,
                          {
                            'accion':'aceptar',
                            'domiciliario_id': Provider.usuarioBloc(context).usuario.id,
                            'shopping_cart_id': pedidoId
                          }
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          onTap: (){
            if(pageRoute != null)
              Navigator.of(context).pushNamed(pageRoute);
          },
        );
      },

    );
  }

  Future<void> _domiciliarioAceptarPedido(String token, String clienteMobileToken, String tiendaMobileToken, Map<String, dynamic> data)async{
    Map<String, dynamic> updatePedidoResponse = await Provider.pedidosBloc(_context).updatePedido(token, data);
    if(updatePedidoResponse['status'] == 'ok'){
      sendPushNotification(
        tiendaMobileToken, 
        notificationTypes[7], 
        {
          'cliente_mobile_token':clienteMobileToken,
          'nombre_domiciliario':Provider.usuarioBloc(_context).usuario.name,
        }
      );
    }
  }

  void _crearDialogNuevoDomiciliarioORechazar(BuildContext context, int pedidoId, String clienteMobileToken, String mensaje, String pageRoute){
    Size  size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.all(0.0),
            height: size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  mensaje,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.045
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.045)
                      ),
                      color: Colors.grey.withOpacity(0.9),
                      child: Text(
                        'Rechazar',
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        _showTiendaRechazarPedidoDialog(pedidoId, clienteMobileToken);
                      },
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.045)
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Seleccionar nuevo domiciliario',
                        style: TextStyle(
                          fontSize: size.width * 0.039,
                          color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          onTap: (){
            if(pageRoute != null)
              Navigator.of(context).pushNamed(pageRoute);
          },
        );
      },

    );
  }

  void _showTiendaRechazarPedidoDialog(int shoppingCartId, String clienteMobileToken){
    Size size = MediaQuery.of(_context).size;
    String justificationValue = '';
    showModalBottomSheet(
      context: _context,
      builder: (BuildContext context){
        return Container(
          height: size.height * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Escribe por qué razón decidiste rechazar el pedido',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.04
                ),
              ),
              Container(
                width: size.width * 0.6,
                child: TextFormField(
                  onChanged: (String newValue){
                    justificationValue = newValue;
                  },
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.04)
                ),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Enviar',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: size.width * 0.04,
                  ),
                ),
                onPressed: (){
                  _tiendaRechazarPedido(shoppingCartId, clienteMobileToken, justificationValue);
                  //Navigator.of(context).pushNamed(SolicitudDePedidosPage.route);
                },
              )
            ],
          ),
        );
      }
    );
  }

  void _tiendaRechazarPedido(int shoppingCartId, String clienteMobileToken, String justificacion)async{
    Map<String, dynamic> updatePedidoResponse = await Provider.pedidosBloc(_context).updatePedido(
      Provider.usuarioBloc(_context).token, 
      {
        'accion':'rechazar',
        'shopping_cart_id':shoppingCartId
      }
    );
    if(updatePedidoResponse['status'] == 'ok'){
      sendPushNotification(
        clienteMobileToken, 
        notificationTypes[2], 
        {
          'domiciliario_name':Provider.usuarioBloc(_context).usuario.name,
          'justificacion':justificacion
        }
      );
    }
    
  }

  set context(BuildContext newContext){
    this._context = newContext;
  }

  void dispose(){
    _pushReceiverController.close();
  }
}