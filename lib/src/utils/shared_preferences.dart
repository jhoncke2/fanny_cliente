import 'dart:convert';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils{
  SharedPreferences sharedPreferences;

  Future<void> initSharedPreferences()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> logOut()async{
    try{
      await sharedPreferences.remove('login_tipo');
      await sharedPreferences.remove('login_email');
      await sharedPreferences.remove('login_password');
      await deletePedidoTemporal();
      return true;
    }catch(err){
      return false;
    }
  }

  Future<bool> normalLogin(String loginEmail, String loginPassword)async{
    try{
      await sharedPreferences.setString('login_tipo', 'normal');
      await sharedPreferences.setString('login_email', loginEmail);
      await sharedPreferences.setString('login_password', loginPassword);
      return true;
    }catch(err){
      return false;
    }
  }

  Future<bool> externalLogin(String loginEmail)async{
    try{
      await sharedPreferences.setString('login_tipo', 'normal');
      await sharedPreferences.setString('login_email', loginEmail);
      return true;
    }catch(err){
      return false;
    }
  }

  Map<String, dynamic> getCurrentLoginCredentials(){
    Map<String, dynamic> credentials = {};
    credentials['tipo'] = sharedPreferences.getString('login_tipo');
    credentials['email'] = sharedPreferences.getString('login_email');
    credentials['password'] = sharedPreferences.getString('login_password');
    return credentials;
  }

  Future<bool> setLugarTemporal(LugarModel direccionTemporalInicial)async{
    try{
      Map<String, dynamic> direccionTemporalInicialJson = direccionTemporalInicial.toJson();
      await sharedPreferences.setString('direccion_temporal_inicial', json.encode(direccionTemporalInicialJson));
      return true;
    }catch(err){
      return false;
    }
  }

  LugarModel getLugarTemporalInicial(){
    String direccionTemporalInicialString = sharedPreferences.getString('direccion_temporal_inicial');
    if(direccionTemporalInicialString != null){
      Map<String, dynamic> lugarTemporalInicialJson = json.decode(direccionTemporalInicialString);
      final LugarModel lugarTemporalInicial = LugarModel.fromJsonMap(lugarTemporalInicialJson);
      /*
      LugarModel direccionTemporalInicial = LugarModel(
        direccion: direccionTemporalInicialJson['direccion'],
        latitud: double.parse( direccionTemporalInicialJson['latitud']),
        longitud:double.parse( direccionTemporalInicialJson['longitud']),
        elegido: true,
        pais: direccionTemporalInicialJson['pais'],
        ciudad: direccionTemporalInicialJson['ciudad'],
        observaciones: direccionTemporalInicialJson['observaciones'],
        tipo: direccionTemporalInicialJson['tipo']
      );
      */
      return lugarTemporalInicial;
    }
    return null;
  }

  bool deleteDireccionTemporalInicial(){
    try{
      sharedPreferences.remove('direccion_temporal_inicial');
      return true;
    }catch(err){
      return false;
    }
  }

  Future<bool> deletePedidoTemporal()async{
    return await sharedPreferences.remove('pedido_temporal');
  }

  Future<bool> setProductoAPedidoTemporal(Map<String, dynamic> productoPedido)async{
    try{
      List<String> productosStringPedido = sharedPreferences.getStringList('pedido_temporal')??[];
      productosStringPedido.add(json.encode(productoPedido) );
      return await sharedPreferences.setStringList('pedido_temporal', productosStringPedido);
    }catch(err){
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPedidoTemporal()async{
    try{
      List<String> productosPedidoString = sharedPreferences.getStringList('pedido_temporal');
      List<Map<String, dynamic>> productosPedido = productosPedidoString.map((String productoString){
        Map<String, dynamic> productoJson = json.decode(productoString);
        productoJson['data_product'] = ProductoModel.fromForFrontJsonMap( productoJson['data_product'] );
        return productoJson;
      }).toList();
      return productosPedido;
    }catch(err){
      return null;
    }
  }
}

final SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();