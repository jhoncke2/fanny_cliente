import 'package:fanny_cliente/src/bloc/products/products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class ProductosServicesManager {
  //******** Diseño Singleton
  static final ProductosServicesManager _pSManager = ProductosServicesManager._internal();
  ProductosServicesManager._internal();

  factory ProductosServicesManager({
    @required BuildContext appContext
  }){
    _initInitialElements(appContext);
    return _pSManager;
  }

  static void _initInitialElements(BuildContext appContext){
    if(_pSManager._appContext == null){
      _pSManager.._appContext = appContext
                .._productosBloc = BlocProvider.of<ProductsBloc>(appContext);
    }
  }

  factory ProductosServicesManager.forTesting({
    @required BuildContext appContext,
    @required ProductsBloc productosBloc
  }){
    _initInitialTestingElements(appContext, productosBloc);
    return _pSManager;
  }

  static void _initInitialTestingElements(BuildContext appContext, ProductsBloc productosBloc){
    if(_pSManager._appContext == null){
      _pSManager.._appContext = appContext
                .._productosBloc = productosBloc;
    }
  }
  // ************** fin de diseño Singleton

  BuildContext _appContext;
  ProductsBloc _productosBloc;

  
}