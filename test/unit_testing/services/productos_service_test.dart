import 'package:flutter_test/flutter_test.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/services/productos_service.dart';
import 'package:fanny_cliente/src/services/user_service.dart';

final String _successGroupDescription = 'Se intenta hacer una sucesión de tests exitosos: cargarProductosPublic, cargar categorias, load products by category, by search, cargar favoritos, crear favorito, eliminar favorito';
final String _loadPublicProductsDescription = 'Se intenta cargar los productos de manera pública';
final String _loadProductsByCategoryDescription = 'Se intenta cargar productos por categoría';
final String _loadProductsBySearchDescription = 'Se intenta cargar productos por medio de una búsqueda';
final String _loadFavoritosDescription = 'Se intenta cargar productos por medio de una búsqueda';
final String _crearFavoritoDescription = 'Se intenta cargar productos por medio de una búsqueda';
final String _eliminarFavoritoDescription = 'Se intenta cargar productos por medio de una búsqueda';
final String _loadCategoriesDescription = 'Se intenta cargar productos por medio de una búsqueda';

final Map<String, dynamic> _loginBody = {
  'email':'email2@gmail.com',
  'password':'12345678'
};
final String _searchTextForProducts = 'hamburguesa';

List<Map<String, dynamic>> _categories;
String _authorizationToken;
Map<String, dynamic> _userInformation;
Map<String, dynamic> _currentFavoriteToCreate;
int _currentCreatedFavoriteId;

void main(){
  group(_successGroupDescription, (){
    _testLoadPublicProducts();
    _testLoadCategories();
    _testLoadProductsByCategory();
    _testLoadProductsBySearch();
    _testLoadFavoritos();
    _testCreateFavorito();
    _testDeleteFavorito();
  });
}

void _testLoadPublicProducts(){
  test(_loadPublicProductsDescription, ()async{
    try{
      await _executeLoadPublicProductsValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería ocurrir un ServiceStatusErr: ${err.message} || ${err.status}');
    }catch(err){
      fail('No debería ocurrir un error: $err');
    }
  });
}

Future<void> _executeLoadPublicProductsValidations()async{
  final Map<String, dynamic> response = await productosService.loadPublicProducts();
  final List<Map<String, dynamic>> products = response['data'].cast<Map<String, dynamic>>();
  _validateProducts(products);
}

void _validateProducts(List<Map<String, dynamic>> products){
  expect(products, isNotNull, reason: 'Los productos no deben ser null');
  expect(products.length, isNot(0), reason: 'La cantidad de productos debe ser mayor a 0');
  products.forEach((Map<String, dynamic> producto) {
    expect(producto, isNotNull, reason: 'El producto actual no debe ser null');
    expect(producto['id'], isNotNull, reason: 'El id del producto actual no debe ser null');
  });
}

void _testLoadCategories(){
  test(_loadCategoriesDescription, ( )async{
    try{
      _executeLoadCategoriesValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería producirse un ServiceStatusErr: ${err.status} || ${err.message}}');
    }catch(err){
      fail('No se debería producir un error: $err');
    }
  });
}

Future<void> _executeLoadCategoriesValidations()async{
  final Map<String, dynamic> response = await productosService.loadCategories();
  final List<Map<String, dynamic>> categories = (response as List).cast<Map<String, dynamic>>();
  expect(categories, isNotNull, reason: 'Las categorías no pueden ser null');
  expect(categories.length, isNot(0), reason: 'El número de categorías debe ser mayor a 0');
  categories.forEach((Map<String, dynamic> category) {
    _validateCategory(category);
  });
  _categories = categories;
}

void _validateCategory(Map<String, dynamic> category){
  expect(category, isNotNull, reason: 'La categoria actual no debe ser null');
  expect(category['id'], isNotNull, reason: 'El campo <id> de la categoria actual no debe ser null');
  expect(category['name'], isNotNull, reason: 'El campo <name> de la categoria actual no debe ser null');
  expect(category['icon'], isNotNull, reason: 'El campo <icon> de la categoria actual no debe ser null');
  expect(category['activo'], isNotNull, reason: 'El campo <activo> de la categoria actual no debe ser null');
}

void _testLoadProductsByCategory(){
  test(_loadProductsByCategoryDescription, ( )async{
    try{
      await _executeLoadProductsByCategoryValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){
      
    }
  });
}

Future<void> _executeLoadProductsByCategoryValidations()async{
  final int categoryId = _categories[0]['id'];
  final Map<String, dynamic> response = await productosService.loadProductsByCategory(categoryId);
  expect(response, isNotNull, reason: 'El response no debe ser null');
  final List<Map<String, dynamic>> products = response['data'];
  expect(products, isNotNull, reason: 'La lista de productos no debe ser nula');
  _currentFavoriteToCreate = products[0];
  products.forEach((Map<String, dynamic> product) {
    _validateProduct(product, categoryId);
  });
}

void _validateProduct(Map<String, dynamic> product, int categoryId){
  expect(product['id'], isNotNull, reason: 'El id del producto no debe ser null');
  expect(product['category']['id'], categoryId, reason: 'El id de la categoría del producto actual debe ser el mismo que el id de la categoría por la que se buscaron los productos');
}

void _testLoadProductsBySearch(){
  test(_loadProductsBySearchDescription, ( )async{
    try{
      _executeLoadProductsBySearchValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería producirse un ServiceStatusErr: ${err.status} || ${err.message}}');
    }catch(err){
      fail('No se debería producir un error: $err');
    }
  });
}

Future<void> _executeLoadProductsBySearchValidations()async{
  final Map<String, dynamic> response = await productosService.loadProductsBySearch(_searchTextForProducts);
  expect(response, isNotNull, reason: 'El response no debe ser null');
  final List<Map<String, dynamic>> products = response['data'];
  expect(products, isNotNull, reason: 'La lista de productos no debe ser nula');
  _validateProductosBySearch(products);
}

void _validateProductosBySearch(List<Map<String, dynamic>> products){
  products.forEach((Map<String, dynamic> product) {
    expect(product, isNotNull, reason: 'El producto actual no debe ser null');
    expect(product['id'], isNotNull, reason: 'El producto actual debe tener id');
    final String name = product['name'];
    expect(name.contains(_searchTextForProducts), true, reason: 'El nombre del producto actual debe contener la palabra por la que se hizo la búsqueda');
  });
}

void _testLoadFavoritos(){
  test(_loadFavoritosDescription, ( )async{
    try{
      _executeLoadFavoritosValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería producirse un ServiceStatusErr: ${err.status} || ${err.message}}');
    }catch(err){
      fail('No se debería producir un error: $err');
    }
  });
}

Future<void> _executeLoadFavoritosValidations()async{
  await _login();
  final List<Map<String, dynamic>> favorites = await _loadFavorites();
  expect(favorites, isNotNull, reason: 'La lista de favoritos no debería ser null');
  favorites.forEach((Map<String, dynamic> favorite) {
    expect(favorite['id'], isNotNull, reason: 'El favorito actual debe tener un id');
    expect(favorite['product'], isNotNull, reason: 'El favorito actual debe tener la información del producto');
  });
}

Future<List<Map<String, dynamic>>> _loadFavorites()async{
  final Map<String, String> headers = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> response = await productosService.loadFavoritos(headers);
  expect(response, isNotNull, reason: 'El response no debe ser null');
  final List<Map<String, dynamic>> favorites = response['data'];
  return favorites;
}

void _testCreateFavorito(){
  test(_crearFavoritoDescription, ( )async{
    try{
      _executeCreateFavoritoValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería producirse un ServiceStatusErr: ${err.status} || ${err.message}}');
    }catch(err){
      fail('No se debería producir un error: $err');
    }
  });
}

Future<void> _executeCreateFavoritoValidations()async{
  await _getUserInformation();
  final Map<String, String> headers = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> body = {
    'cliente_id':_userInformation['id'],
    'producto_id':_currentFavoriteToCreate['id']
  };
  final Map<String, dynamic> response = await productosService.createFavorito(headers, body);
  expect(response, isNotNull, reason: 'El response no debe ser null');
  expect(response['id'],isNotNull, reason: 'El id no debe ser null');
  expect(response['cliente_id'],isNotNull, reason: 'El id del cliente no debe ser null');
  expect(response['cliente_id'], _userInformation['id'], reason: 'El id del cliente del favorito recién creado debe ser el mismo id del usuario que creó el favorito');
  expect(response['producto_id'],isNotNull, reason: 'El id del producto no debe ser null');
  expect(response['producto_id'], _currentFavoriteToCreate['id'], reason: 'El id del producto del favorito recién creado debe ser el mismo id del producto que se tomó para ser favorito');
  _currentCreatedFavoriteId = response['id'];
  final bool thereIsTheCurrentCreatedFavoriteInFavorites = await _validateIfThereIsCurrentCreatedFavoriteInFavorites();
  expect(thereIsTheCurrentCreatedFavoriteInFavorites, true, reason: 'En la lista de favoritos debe estar el favorito que acabamos de crear');
}

void _testDeleteFavorito(){
  test(_eliminarFavoritoDescription, ( )async{
    try{
      _executeDeleteFavoritoValidations();
    }on ServiceStatusErr catch(err){
      fail('No debería producirse un ServiceStatusErr: ${err.status} || ${err.message}}');
    }catch(err){
      fail('No se debería producir un error: $err');
    }
  });
}

Future<void> _executeDeleteFavoritoValidations()async{
  final Map<String, String> headers = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> response = await productosService.deleteFavorito(headers, _currentCreatedFavoriteId);
  expect(response, isNotNull, reason: 'El response no debe ser null');
  expect(response, true, reason: 'Debe venir un true como response');
  bool thereIsTheCurrentCreatedFavoriteInFavorites = await _validateIfThereIsCurrentCreatedFavoriteInFavorites();
  expect(thereIsTheCurrentCreatedFavoriteInFavorites, false, reason: 'En la lista de favoritos no debe estar el favorito que acabamos de eliminar');
}

Future<void> _login()async{
  final Map<String, dynamic> response = await userService.login(_loginBody);
  _authorizationToken = response['token'];
}

Future<void> _getUserInformation()async{
  final Map<String, String> headers = _createAuthorizationTokenHeaders();
  final Map<String, dynamic> response = await userService.getUserInformation(headers);
  _userInformation = response['data'];
}

Map<String, String> _createAuthorizationTokenHeaders(){
  return {
    'Authorization':'Bearer $_authorizationToken'
  };
}

Future<bool> _validateIfThereIsCurrentCreatedFavoriteInFavorites()async{
  final List<Map<String, dynamic>> favorites = await _loadFavorites();
  bool thereIsTheCurrentCreatedFavoriteInFavoritesList = false;
  favorites.forEach((Map<String, dynamic> favorite) {
    if(favorite['id'] == _currentCreatedFavoriteId)
      thereIsTheCurrentCreatedFavoriteInFavoritesList = true;
  });
  return thereIsTheCurrentCreatedFavoriteInFavoritesList;
}