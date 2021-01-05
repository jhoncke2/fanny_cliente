import 'dart:io';

import 'package:fanny_cliente/src/models/horarios_model.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/models/tiendas_model.dart';
import 'package:fanny_cliente/src/providers/tienda_provider.dart';
import 'package:rxdart/rxdart.dart';
class TiendaBloc{
  final _tiendaProvider = new TiendaProvider();
  final _tiendaController = new BehaviorSubject<TiendaModel>();
  final _ventasController = new BehaviorSubject<List<Map<String, dynamic>>>();
  //las tiendas de los correspondientes pedidos del cliente
  final _tiendasPedidosController = new BehaviorSubject<Map<String, dynamic>>();

  Stream<TiendaModel> get tiendaStream => _tiendaController.stream;
  Stream<List<Map<String, dynamic>>> get ventasStream => _ventasController.stream;
  Stream<Map<String, dynamic>> get tiendasPedidosStream => _tiendasPedidosController.stream;

  TiendaModel tienda;
  LugarModel direccionTienda;
  HorarioModel horarioTienda;

  //creación de tienda
  bool enCreacion = false;
  File ccAtras;
  File ccDelantera;
  File certificacionBancaria;

  Future<Map<String, dynamic>> crearTienda(String token)async{
    Map<String, dynamic> response = await _tiendaProvider.crearTienda(token, tienda, ccDelantera, ccAtras, certificacionBancaria);
    return response;
  }

  Future<Map<String, dynamic>> cargarTienda(String token)async{
    Map<String, dynamic> response = await _tiendaProvider.cargarTienda(token);
    
    if(response['status'] == 'ok'){
      tienda = TiendaModel();
      if(response['tienda'] != null)
        tienda = TiendaModel.fromJsonMap( response['tienda']);
      _tiendaController.sink.add(tienda);
    }else{
      _tiendaController.sink.add(TiendaModel());
    }
    return response;
  }

  Future<Map<String, dynamic>> cargarTiendaPublic(String token, int tiendaId)async{
    Map<String, dynamic> response = await _tiendaProvider.cargarTiendaPublic(token, tiendaId);
    if(response['status'] == 'ok'){
      _tiendasPedidosController.sink.add(response['tienda']);
    }else
      _tiendasPedidosController.sink.add({});
    return response;
  }

  Future<Map<String, dynamic>> crearHorario(String token){
    Future<Map<String, dynamic>> response = _tiendaProvider.crearHorario(token, horarioTienda);
    return response;
  }

  void iniciarCreacionTienda(){
    enCreacion = true;
    tienda = TiendaModel();
    horarioTienda = HorarioModel();
  }

  void dispose(){
    _tiendaController.close();
    _tiendasPedidosController.close();
  }
}