import 'package:fanny_cliente/src/bloc/products/products_bloc.dart';
import 'package:fanny_cliente/src/models/categorias_model.dart';
import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:mockito/mockito.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/utils/polygons_manager.dart' as polygonsManager;


class MockUserBloc extends Mock implements UserBloc{
  UserState _mockState;
  MockUserBloc() 
  : super(){
    _mockState = UserState();
  }
  @override
  void add(UserEvent event) {
    // TODO: implement add
    switch(event.runtimeType){
      case SetAuthorizationToken:
        _setAuthorizationToken(event as SetAuthorizationToken);
      break;
      case SetUserInformation:
        _setUserInformation(event as SetUserInformation);
      break;
      case Logout:
        _logout();
      break;
    }
  }

  @override
  void _setAuthorizationToken(SetAuthorizationToken event){
    this._mockState = this._mockState.copyWith(authorizationToken: event.authorizationToken);
  }

  @override
  void _setUserInformation(SetUserInformation event){
    this._mockState = this._mockState.copyWith(userInformation: event.user);
  }

  @override
  void _logout(){
    this._mockState = this._mockState.reset();
  }

  @override
  UserState get state => this._mockState;
}

class MockLugaresBloc extends Mock implements LugaresBloc{
  LugaresState _mockState;
  MockLugaresBloc() 
  : super(){
    _mockState = LugaresState();
  }
  @override
  void add(LugaresEvent event) {
    switch(event.runtimeType){
      case SetLugares:
        _setLugares(event as SetLugares);
      break;
      case ResetLugares:
        _resetLugares();
      break;
    }
  }

  @override  
  void _setLugares(SetLugares event){
    final List<LugarModel> lugares = event.lugares;
    LugarModel elegido;
    for(int i = 0; i < lugares.length; i++){
      final LugarModel lugar = lugares[i];
      if(lugar.elegido){
        elegido = lugar;
        break;
      }
    }
    _mockState = _mockState.copyWith(lugaresCargados:true, lugares: lugares, elegido: elegido);
  }

  @override
  void _resetLugares(){
    _mockState = _mockState.reset();
  }

  @override
  LugaresState get state => this._mockState;
}


class MockPolygonsBloc extends Mock implements PolygonsBloc{
  PolygonsState _mockState;
  MockPolygonsBloc() 
  : super(){
    _mockState = PolygonsState();
  }

  @override
  void add(PolygonsEvent event) {
    switch(event.runtimeType){
      case AddPolygons:
        _addPolygons(event as AddPolygons);
      break;
      case DefineIfPositionIsOnAnyPolygon:
        _defineIfWeAreOnAnyPolygon(event as DefineIfPositionIsOnAnyPolygon);
      break;
    }
  }

  @override
  void _addPolygons(AddPolygons event){
    _mockState = state.copyWith(
      tiendaPolygonsCargados: true,
      tiendaPolygons: event.polygons
    );
  }  


  @override
  void _defineIfWeAreOnAnyPolygon(DefineIfPositionIsOnAnyPolygon event){
    final List<Polygon> polygonsList = state.tiendaPolygons.toList();
    final bool estamosEnAlgunPolygon = polygonsManager.hallarSiPuntoEstaDentroDePolygons(polygonsList, event.position);
    _mockState = state.copyWith(estamosDentroDeAlgunPolygon: estamosEnAlgunPolygon);
  }

  @override
  PolygonsState get state => this._mockState;
}

class MockProductosBloc extends Mock implements ProductsBloc{
  ProductsState _mockState;
  MockProductosBloc() 
  : super(){
    _mockState = ProductsState();
  }
  @override
  void add(ProductsEvent event) {
    switch(event.runtimeType){
      case SetCategories:
        _setCategories(event as SetCategories);
      break;
      case SetProducts:
        _setProducts(event as SetProducts);
      break;
      case SelectProduct:
        _elegirProducto(event as SelectProduct);
      break;
      case SetProductsByCategory:
        _setProductsByCategory(event as SetProductsByCategory);
      break;
      case SetProductsBySearch:
        _setProductsBySearch(event as SetProductsBySearch);
      break;
    }
  }

  @override
  void _setCategories(SetCategories event){
    final List<CategoriaModel> categories = event.categories;
    _mockState = state.copyWith(categories: categories);
  }

  @override  
  void _setProducts(SetProducts event){
    final List<ProductoModel> products = event.products;
    _mockState = _mockState.copyWith(products: products);
  }

   @override  
  void _elegirProducto(SelectProduct event){
    final ProductoModel selected = event.selected;
    _mockState = _mockState.copyWith(currentSelectedProduct: selected);
  }

  @override
  void _setProductsByCategory(SetProductsByCategory event){
    final CategoriaModel category = event.category;
    final List<ProductoModel> products = event.products;
    _mockState = state.copyWith(currentSelectedCategory: category, currentProductsByCategory: products);
  }

  @override
  void _setProductsBySearch(SetProductsBySearch event){
    final String search = event.search;
    final List<ProductoModel> products = event.products;
    _mockState = state.copyWith(currentSearch: search, currentProductsBySearch: products);
  }

  @override
  ProductsState get state => this._mockState;
}