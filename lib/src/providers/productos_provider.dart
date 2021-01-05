import 'dart:io';

import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductosProvider{

  final _productosPublicServiceRoute = 'https://codecloud.xyz/api/products/public';
  final _productosServiceRoute = 'https://codecloud.xyz/api/products';
  final _productosFavoritosRoute = 'https://codecloud.xyz/api/user-products/favorite';
  final _categoriasServiceRoute = 'https://codecloud.xyz/api/category/public';
  final _productosTiendaRoute = 'https://codecloud.xyz/api/tienda/products';
  final _productosPorCategoriaRoute = 'https://codecloud.xyz/api/products/category';

  Future<Map<String, dynamic>> cargarProductosPublic()async{
    final response = await http.get(
      _productosPublicServiceRoute,
      headers: {
        'Access-Control-Allow-Origin':'*'
      }
    );
    try{
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'productos':decodedResponse['data']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cargarProductosPorCategoria(int categoryId)async{
    try{
      final response = await http.get('$_productosPorCategoriaRoute/$categoryId');
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'data':decodedResponse['data']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cargarProductosBySearch(String searchingString)async{
    try{
      final response = await http.get('$_productosServiceRoute/search/$searchingString');
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'data':decodedResponse['data']
      };
    }catch(err){
      return{
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> crearProducto(String token, ProductoModel producto, List<File> photos, int categoryId)async{
    Map<String, String> headers = {
      'Authorization':'Bearer $token',
      'Content-Type':'application/x-www-form-urlencoded'
    };
    
    Map<String, String> fields = producto.toForBackJson();
    fields['category_id'] = categoryId.toString();
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse(_productosServiceRoute)
    );
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.addAll(photos.map((File photo){
      return http.MultipartFile(
        'imagenes[]',
        photo.readAsBytes().asStream(),
        photo.lengthSync(),
        filename: photo.path.split('/').last
      );
    }));
    
    try{
      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
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

  Future<Map<String, dynamic>> editarProducto(String token, ProductoModel producto, Map<String, dynamic> programacion)async{
    Map<String, dynamic> body = producto.toForBackJson().cast<String, dynamic>();
    body['programado'] = programacion;
    body['category_id'] = producto.category['id'];
    try{
      final response = await http.put(
        '$_productosServiceRoute/${producto.id}',
        headers: {
          'Authorization':'Bearer $token',
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

  Future<Map<String, dynamic>> cargarProductosByToken(String token)async{
    final response = await http.get(
      _productosServiceRoute,
      headers: {
        'Authorization': 'Bearer $token',
        'Access-Control-Allow-Origin':'*'
      }
    );
    try{
      final decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'productos':decodedResponse['data']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cargarProductosTienda(int tiendaId)async{
    final response = await http.get(
      '$_productosTiendaRoute/$tiendaId',
      headers: {
        'Access-Control-Allow-Origin':'*'
      }
    );
    try{
      final decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'productos':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> activarODesactivarProducto(String token, int productoId)async{
    final response = await http.delete(
      '$_productosServiceRoute/$productoId',
      headers: {
        'Authorization':'Bearer $token'
      }
    );
    try{
      final decodedResponse = json.decode(response.body);
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

  Future<Map<String, dynamic>> cargarFavoritos(String token)async{
    final response = await http.get(
      _productosFavoritosRoute,
      headers: {
        'Authorization':'Bearer $token'
      }
    );

    try{
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      return {
        'status':'ok',
        'favoritos':decodedResponse['data']
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> crearFavorito(String token, int clienteId, int productoId)async{
    final response = await http.post(
      _productosFavoritosRoute,
      headers:{
        'Authorization':'Bearer $token'
      },
      body: {
        'cliente_id':clienteId.toString(),
        'producto_id':productoId.toString()
      }
    );

    try{
      final decodedResponse = json.decode(response.body);
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

  Future<Map<String, dynamic>> eliminarFavorito(String token, int favoritoId)async{
    final response = await http.delete(
      '$_productosFavoritosRoute/$favoritoId',
      headers:{
        'Authorization':'Bearer $token'
      }
    );

    try{
      final decodedResponse = json.decode(response.body);
      if(decodedResponse == "true" || decodedResponse == true){
        return {
          'status':'ok'
        };
      }else{
        return {
          'status':'err',
          'message':decodedResponse
        };
      }
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> cargarCategorias()async{
    final response = await http.get(
      _categoriasServiceRoute,
    ); 
    try{
      List<Map<String, dynamic>> decodedResponse = (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      return{
        'status':'ok', 
        'categorias':decodedResponse
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }
}