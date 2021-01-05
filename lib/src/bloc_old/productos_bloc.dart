import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:fanny_cliente/src/providers/productos_provider.dart';

class ProductosBloc{
  final _productosProvider = new ProductosProvider();

  final _productosPublicController = new BehaviorSubject<List<ProductoModel>>();
  final _productosTiendaController = new BehaviorSubject<List<ProductoModel>>();
  BehaviorSubject<List<ProductoModel>> _productosSearchController = new BehaviorSubject<List<ProductoModel>>();
  final _favoritosStream = new BehaviorSubject<List<Map<String, dynamic>>>();
  final _categoriasController = new BehaviorSubject<List<Map<String, dynamic>>>();
  BehaviorSubject<List<ProductoModel>> _productosPorCategoriaController = new BehaviorSubject<List<ProductoModel>>();
  final _ownersFavoritosController = new BehaviorSubject<List<Map<String, dynamic>>>();
  
  Stream<List<ProductoModel>> get productosPublicStream => _productosPublicController.stream;
  Stream<List<ProductoModel>> get productosTiendaStream => _productosTiendaController.stream;
  Stream<List<Map<String, dynamic>>> get favoritosStream => _favoritosStream.stream;
  Stream<List<Map<String, dynamic>>> get categoriasStream => _categoriasController.stream;
  Stream<List<ProductoModel>> get productosPorCategoriaStream => _productosPorCategoriaController.stream;
  Stream<List<ProductoModel>> get productosSearchStream => _productosSearchController.stream;
  Stream<List<Map<String, dynamic>>> get ownersFavoritosStream => _ownersFavoritosController.stream;
  

  Future<Map<String, dynamic>> cargarProductosPublic()async{
    Map<String, dynamic> response = await _productosProvider.cargarProductosPublic();
    if(response['status'] == 'ok')
      response['productos'] = ProductosModel.fromJsonList(response['productos']).productos;
      _productosPublicController.sink.add(
        response['productos']
      );
    return response;
  }

  Future<Map<String, dynamic>> cargarProductosPorCategoria(int categoryId)async{
    Map<String, dynamic> productosPorCategoriaResponse = await _productosProvider.cargarProductosPorCategoria(categoryId);
    if(productosPorCategoriaResponse['status'] == 'ok'){
      List<ProductoModel> productosPorCategoria = ((productosPorCategoriaResponse['data'] as List).cast<Map<String, dynamic>>()).map<ProductoModel>((Map<String, dynamic> productoJson){
        return ProductoModel.fromJsonMap(productoJson);
      }).toList();
      _productosPorCategoriaController.sink.add(productosPorCategoria);
    }
    return productosPorCategoriaResponse;
  }

  Future<Map<String, dynamic>> cargarProductosBySearch(String searchingString)async{
    Map<String, dynamic> searchResponse = await _productosProvider.cargarProductosBySearch(searchingString);
    if(searchResponse['status'] =='ok'){
      List<ProductoModel> productosList = (( searchResponse['data'] as List).cast<Map<String, dynamic>>())
      .map((Map<String, dynamic> productoJson){
        return ProductoModel.fromJsonMap(productoJson);
      }).toList();
      _productosSearchController.sink.add(productosList);
    }
    return searchResponse;
  }

  Future<Map<String, dynamic>> crearProducto(String  token, ProductoModel producto, List<File> photos, int categoryId)async{
    Map<String, dynamic> response = await _productosProvider.crearProducto(token, producto, photos, categoryId);
    return response;
  }
  
  Future<Map<String, dynamic>> editarProducto(String token, ProductoModel producto, Map<String, dynamic> programacion)async{
    Map<String, dynamic> editResponse = await _productosProvider.editarProducto(token, producto, programacion);
    return editResponse;
  }

  Future<Map<String, dynamic>> cargarProductosTienda(int tiendaId)async{
    Map<String, dynamic> response = await _productosProvider.cargarProductosTienda(tiendaId);
    if(response['status'] == 'ok'){
      final productosModel = ProductosModel.fromJsonList(response['productos']);
      _productosTiendaController.sink.add(productosModel.productos);
    }
    return response;
  }

  Future<Map<String, dynamic>> activarODesactivarProducto(String token, int productoId)async{
    Map<String, dynamic> response = await _productosProvider.activarODesactivarProducto(token, productoId);
    return response;
  }

  Future<Map<String, dynamic>> cargarFavoritos(String token)async{
    Map<String, dynamic> response = await _productosProvider.cargarFavoritos(token);
    List<Map<String, dynamic>> favoritosList= ((response['favoritos'] as List).cast<Map<String, dynamic>>())
    .map((Map<String, dynamic> favorito){
      favorito['product'] = ProductoModel.fromJsonMap(favorito['product']);
      return favorito;
    }).toList();
    if(response['status'] == 'ok'){
      _favoritosStream.sink.add(favoritosList);
    }
    response['favoritos'] = favoritosList;
    return response;
  }

  Future<Map<String, dynamic>> crearFavorito(String token, int clienteId, int productoId)async{
    Map<String, dynamic> response = await _productosProvider.crearFavorito(token, clienteId, productoId);
    if(response['status'] == 'ok')
      cargarFavoritos(token);
    return response;
  }

  Future<Map<String, dynamic>> eliminarFavorito(String token, int favoritoId)async{
    Map<String, dynamic> response = await _productosProvider.eliminarFavorito(token, favoritoId);
    if(response['status'] == 'ok')
      cargarFavoritos(token);
    return response;
  }

  Future<Map<String, dynamic>> cargarCategorias()async{
    Map<String, dynamic> response = await _productosProvider.cargarCategorias();
    if(response['status'] == 'ok'){
      _categoriasController.sink.add(response['categorias']);
    }
    return response;
  }

  Future<Map<String, dynamic>> cargarOwnersFavoritos(List<Map<String, dynamic>> ownersFavoritos)async{
    try{
      _ownersFavoritosController.sink.add(ownersFavoritos);
      return {
        'status':'ok'
      };
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  void dispose(){
    _productosPublicController.close();
    _productosTiendaController.close();
    _favoritosStream.close();
    _categoriasController.close();
    _productosPorCategoriaController.close();
    _productosSearchController.close();
    _ownersFavoritosController.close();
  }

  Future<void> disposeProductosSearchController()async{
    await _productosSearchController.close();
  }

  void initProductosSearchController(){
    _productosSearchController = BehaviorSubject<List<ProductoModel>>();
  }

  Future<void> disposeProductosPorCategoriaController()async{
    await _productosPorCategoriaController.close();
  }

  void initProductosPorCategoriaController(){
    _productosPorCategoriaController = new BehaviorSubject<List<ProductoModel>>();
  }
 
}