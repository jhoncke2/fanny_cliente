import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fanny_cliente/src/models/categorias_model.dart';
import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsState _currentYieldedState;

  ProductsBloc() : super(ProductsState());

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    switch(event.runtimeType){
      case SetCategories:
        _setCategories(event as SetCategories);
      break;
      case SetProducts:
        _setProductos(event as SetProducts);
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
    yield _currentYieldedState;
  }

  void _setCategories(SetCategories event){
    final List<CategoriaModel> categories = event.categories;
    _currentYieldedState = state.copyWith(categories: categories);
  }

  void _setProductos(SetProducts event){
    final List<ProductoModel> products = event.products;
    _currentYieldedState = state.copyWith(products: products);
  }

  void _elegirProducto(SelectProduct event){
    final ProductoModel selected = event.selected;
    _currentYieldedState = state.copyWith(currentSelectedProduct: selected);
  }

  void _setProductsByCategory(SetProductsByCategory event){
    final CategoriaModel category = event.category;
    final List<ProductoModel> products = event.products;
    _currentYieldedState = state.copyWith(currentSelectedCategory: category, currentProductsByCategory: products);
  }

  void _setProductsBySearch(SetProductsBySearch event){
    final String search = event.search;
    final List<ProductoModel> products = event.products;
    _currentYieldedState = state.copyWith(currentSearch: search, currentProductsBySearch: products);
  }
}
