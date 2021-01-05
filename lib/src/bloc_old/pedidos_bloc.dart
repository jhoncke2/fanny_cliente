import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:fanny_cliente/src/providers/pedidos_provider.dart';
import 'package:rxdart/rxdart.dart';

enum EstadosPedido{
  INEXISTENTE,
  EN_CARRITO,
  POR_CONFIRMAR
}

class PedidosBloc{

  PedidosProvider _pedidosProvider = new PedidosProvider();

  BehaviorSubject<List<Map<String, dynamic>>> _pedidoActualClienteController = BehaviorSubject();
  BehaviorSubject<List<Map<String, dynamic>>> _pedidosHistorialClienteController = BehaviorSubject();
  BehaviorSubject<List<Map<String, dynamic>>> _pedidosHistorialTiendaController = BehaviorSubject();
  BehaviorSubject<List<Map<String, dynamic>>> _pedidosSinRevisarTiendaController = BehaviorSubject();

  Stream<List<Map<String, dynamic>>> get pedidoActualClienteStream => _pedidoActualClienteController.stream;
  Stream<List<Map<String, dynamic>>> get pedidosHistorialClienteStream => _pedidosHistorialClienteController.stream;
  Stream<List<Map<String, dynamic>>> get pedidosHistorialTiendaStream => _pedidosHistorialTiendaController.stream;
  Stream<List<Map<String, dynamic>>> get pedidosSinRevisarTiendaStream => _pedidosSinRevisarTiendaController.stream;

  List<Map<String, dynamic>> _pedidosClienteSync;
  EstadosPedido _estadoPedido;
  int pedidoActualTiendaId;
  double valorTotalPedidoActual;
  /**
   * 0: pedido actual
   * 1: pedidos anteriores
   */
  int indexNavegacionPedidosPage = 0;
  bool _pedidosAnterioresCargados;

  bool get pedidosAnterioresCargados => _pedidosAnterioresCargados;

  PedidosBloc(){
    //falta por implementar la caché
    _pedidosClienteSync = [];
    _estadoPedido = EstadosPedido.INEXISTENTE;
    indexNavegacionPedidosPage = 1;
    _pedidosAnterioresCargados = false;
  }

  set estadoPedido(EstadosPedido estadoPedido){
    _estadoPedido = estadoPedido;
    indexNavegacionPedidosPage = (_estadoPedido == EstadosPedido.EN_CARRITO)? 0 : 1;
  }

  bool get pedidoActualControllerHasValue => (_pedidoActualClienteController.value != null);

  Future<void> agregarProductoAPedido(Map<String, dynamic> ordenProducto)async{
    List<Map<String, dynamic>> pedido = (_pedidoActualClienteController.value??[]);
    if(_estadoPedido==EstadosPedido.INEXISTENTE){
      _estadoPedido = EstadosPedido.EN_CARRITO;
      pedidoActualTiendaId = (ordenProducto['data_product'] as ProductoModel).tiendaId;
    }
    pedido.add(ordenProducto);
    _pedidoActualClienteController.sink.add(pedido);
  }

  Future<void> agregarTodosLosProductosAPedido(List<Map<String, dynamic>> productosPedido)async{
    if(productosPedido != null)
      _pedidoActualClienteController.sink.add(productosPedido);
  }

  void quitarProductoDePedido(Map<String, dynamic> ordenProducto)async{
    if(_estadoPedido == EstadosPedido.EN_CARRITO){
      try{
        List<Map<String, dynamic>> pedido = (_pedidoActualClienteController.value)??[];
        pedido.remove(ordenProducto);
        print(pedido);
        _pedidoActualClienteController.sink.add(pedido);
      }catch(err){
        print(err);
      }
      
    }
  }
  // ****************************************
  //Comunicación con el back
  // ****************************************

  Future<Map<String, dynamic>> generarPedido(String token, int direccionId)async{
    try{
      List<Map<String, dynamic>> pedidoActual = ( _pedidoActualClienteController.stream.value).cast<Map<String, dynamic>>();
      Map<String, dynamic> crearCarritoResponse = await _pedidosProvider.crearCarritoDeCompras(token, pedidoActual[0]['data_product'].tiendaId, direccionId);   
      if(crearCarritoResponse['status'] == 'ok'){
        List<Map<String, dynamic>> productosCarrito = pedidoActual.map((Map<String, dynamic> producto){
          return {
            'producto_id':producto['data_product'].id,
            'cantidad':producto['cantidad'],
            'precio':producto['precio']
          };
        }).toList();
        Map<String, dynamic> crearProductosCarritoResponse = await _pedidosProvider.crearProductosCarritoDeCompras(token, crearCarritoResponse['pedido']['id'], productosCarrito);    
        if(crearProductosCarritoResponse['status'] != 'ok'){
          print(crearProductosCarritoResponse);
        }
        crearProductosCarritoResponse['tienda_mobile_token'] = crearCarritoResponse['pedido']['tienda_mobile_token'];
        return crearProductosCarritoResponse;
      }else{
        print(crearCarritoResponse);
        return crearCarritoResponse;
      }
    }catch(err){
      print(err);
      return {
        'status':'err',
        'message':err
      };
    }   
  }

  List<Map<String, dynamic>> get valueOfPedidoActualStream{
    return _pedidoActualClienteController.value;
  }

  Future<Map<String, dynamic>> cargarPedidosAnterioresPorClienteOTienda(String token, String tipoUsuario, int tiendaId)async{
    Map<String, dynamic> pedidosResponse = await _pedidosProvider.cargarPedidosAnterioresPorClienteOTienda(token, tipoUsuario, tiendaId);
    if(pedidosResponse['status'] == 'ok'){
      List<Map<String, dynamic>> pedidos = ((pedidosResponse['pedidos'] as List).cast<Map<String, dynamic>>()).map((Map<String, dynamic> pedido){
        Map<String, dynamic> pedidoFormateado = pedido;
        List<Map<String, dynamic>> products = ((pedido['products'] as List).cast<Map<String, dynamic>>()).map((Map<String, dynamic> product){
          
          return {
            'id':product['id'],
            'cantidad':product['cantidad'],
            'precio':product['precio'],
            'calificado':product['calificado'],
            'data_product':ProductoModel.fromJsonMap(product['data_product'])
          };
        }).toList();
        pedidoFormateado['products'] = products;      
        return pedidoFormateado;
      }).toList();
      _pedidosClienteSync = pedidos;
      if(tipoUsuario == 'cliente'){
        _pedidosHistorialClienteController.sink.add(pedidos);
      }else{
        _procesarPedidosTienda(pedidos);
      }
      _pedidosAnterioresCargados = true;
    }
    return pedidosResponse;
  }

  Future<Map<String, dynamic>> updatePedido(String token, Map<String, dynamic> data)async{
    Map<String, dynamic> response = await _pedidosProvider.updatePedido(token, data);
    return response;
  }

  Future<Map<String, dynamic>> calificarProductoPedido(String token, int idCliente, int idProducto, int idProductoPedido, double pCalification1, double pCalification2, String comentario)async{
    Map<String, dynamic> cambiarProductoPedidoCalificadoResponse = await _pedidosProvider.cambiarEstadoCalificacionProductoPedido(token, idProductoPedido);
    if(cambiarProductoPedidoCalificadoResponse['status']=='ok'){
      Map<String, dynamic> crearComentarioResponse = await _pedidosProvider.crearCalificacion(token, pCalification1, pCalification2, comentario, idProducto, idCliente);
      return crearComentarioResponse;
    }
    return cambiarProductoPedidoCalificadoResponse;
  }

  List<Map<String, dynamic>> get pedidosClienteSync{
    print(_pedidosClienteSync);
    return _pedidosClienteSync;
  }

  void _procesarPedidosTienda(List<Map<String, dynamic>> pedidos){
    List<Map<String, dynamic>> pedidosSinRevisar = [];
    List<Map<String, dynamic>> pedidosHistorial = [];
    pedidos.forEach((Map<String, dynamic> pedido){
      if(pedido['estado'] == 'generado')
        pedidosSinRevisar.add(pedido);
      else
        pedidosHistorial.add(pedido);
    });
    if(pedidosSinRevisar.length > 0)
      _pedidosSinRevisarTiendaController.sink.add(pedidosSinRevisar);
    if(pedidosHistorial.length > 0)
      _pedidosHistorialTiendaController.sink.add(pedidosHistorial);
  }

  void initStreams(){
    _pedidoActualClienteController = new BehaviorSubject();
    _pedidosSinRevisarTiendaController = new BehaviorSubject();
    _pedidosHistorialClienteController = new BehaviorSubject();
    _pedidosHistorialTiendaController = new BehaviorSubject();
  } 

  Future<void> dispose()async{
    await _pedidoActualClienteController.close();
    await _pedidosHistorialClienteController.close();
    await _pedidosSinRevisarTiendaController.close();
    await _pedidosHistorialTiendaController.close();
  }

  Future<void> disposePedidoActualClienteController()async{
    await _pedidoActualClienteController.close();
  }

  void initPedidoActualClienteController(){
    _pedidoActualClienteController = new BehaviorSubject();
  }
}