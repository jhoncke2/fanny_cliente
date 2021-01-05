import 'package:fanny_cliente/src/bloc_old/confirmation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/navigation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/productos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/size_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/tienda_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/providers/push_notifications_provider.dart';
import 'package:flutter/cupertino.dart';

class Provider extends InheritedWidget{
  final _sizeBloc = new SizeBloc();
  final _sharedPreferencesBloc = new SharedPreferencesBloc();
  final _pushNotificationsProvider = new PushNotificationsProvider();
  final _lugaresBloc = new LugaresBloc();
  final _usuarioBloc = new UsuarioBloc();
  final _tiendaBloc = new TiendaBloc();
  final _navigationBloc = new NavigationBloc();
  final _confirmationBloc = new ConfirmationBloc();
  final _productosBloc = new ProductosBloc();
  final _pedidosBloc = new PedidosBloc();  
  
  
 
  

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child})
    :super(key: key, child: child);

  /**
   * ¿Al actualizarse debe notificarle a los hijos?: true
   */
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SizeBloc sizeBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._sizeBloc;
  }
  
  static LugaresBloc lugaresBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._lugaresBloc;
  }

  static UsuarioBloc usuarioBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._usuarioBloc;
  }

  static TiendaBloc tiendaBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._tiendaBloc;
  }

  static NavigationBloc navigationBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._navigationBloc;
  }

  static ConfirmationBloc confirmationBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._confirmationBloc;
  }

  static ProductosBloc productosBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }

  static PedidosBloc pedidosBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._pedidosBloc;
  }


  static SharedPreferencesBloc sharedPreferencesBloc(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._sharedPreferencesBloc;
  }

  static PushNotificationsProvider pushNotificationsProvider(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._pushNotificationsProvider;
  }

  void dispose(){
    _lugaresBloc.dispose();
    _usuarioBloc.dispose();
    _confirmationBloc.dispose();
    _productosBloc.dispose();
    _pedidosBloc.dispose();
    _pushNotificationsProvider.dispose();
  }
}