import 'package:http/http.dart' as http;
import 'dart:convert';
class PedidosProvider{
  static final estadosPedidos = [
    'generado',
    'aceptado',
    'rechazado',
    'entregado',
    'devolucion'
  ];

  final _apiUrl = 'https://codecloud.xyz/api';

  Future<Map<String, dynamic>> crearCarritoDeCompras(String token, int tiendaId, int direccionId)async{
    try{
      final response = await http.post(
        '$_apiUrl/shoppingcart',
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'Application/json'
        },
        body: json.encode({
          'tienda_id':tiendaId,
          'direccion_id':direccionId
        })
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'pedido': decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> crearProductosCarritoDeCompras(String token, int shoppingCartId, List<Map<String, dynamic>> productsMap)async{
    try{
      final response = await http.post(
        '$_apiUrl/shoppingcart-products',
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'Application/json'
        },
        body: json.encode({
          'shopping_cart_id':shoppingCartId,
          'products':productsMap
        })
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'pedido':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cargarPedidosAnteriores(String token)async{
    try{
      final response = await http.get(
        '$_apiUrl/shoppingcart',
        headers: {
          'Authorization':'Bearer $token'
        }
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'pedidos': decodedResponse['data']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cargarPedidosAnterioresPorClienteOTienda(String token, String tipoUsuario, int tiendaId)async{
    try{
      Map<String, dynamic> body = {};
      if(tipoUsuario=='tienda')
        body['tienda_id'] = tiendaId.toString();
      final response = await http.post(
        '$_apiUrl/shoppingcart-list',
        body: body,
        headers: {
          'Authorization':'Bearer $token'
        }
      );
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'pedidos': decodedResponse['data']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> updatePedido(String token, Map<String, dynamic> data)async{
    Map<String, dynamic> body = {};
    if(data['accion'] == 'aceptar'){
      body['domiciliario_id'] = data['domiciliario_id'];
      body['estado'] = estadosPedidos[1];
    } 
    else
      body['estado'] = estadosPedidos[2];
    try{
      final response = await http.put(
        '$_apiUrl/shoppingcart/${data['shopping_cart_id']}',
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'Application/json'
        },
        body: json.encode(body)
      );

      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'data':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cambiarEstadoCalificacionProductoPedido(String token, int idProductoPedido)async{
    try{
      final response = await http.put(
        '$_apiUrl/shoppingcart-products/$idProductoPedido',
        headers: {
          'Authorization':'Bearer $token'
        }
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

  Future<Map<String, dynamic>> crearCalificacion(String token, double p1, double p2, String comment, int idProducto, int idCliente)async{
    try{
      final response = await http.post(
        '$_apiUrl/calification-product',
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'Application/json'
        },
        body: json.encode({
          'p1':p1,
          'p2':p2,
          'comment':comment,
          'product_id':idProducto,
          'user_id':idCliente
        })
      );

      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'response':decodedResponse
      };
    }catch(err){
      return{
        'status':'err',
        'message':err
      };
    }
  }
}