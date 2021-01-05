import 'package:flutter_test/flutter_test.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/services/user_service.dart';
import 'package:fanny_cliente/src/services/pedidos_service.dart';

final String _successTestGroupDescription = 'Se intenta llevar a cabo, exitosamente, una sucesión de: crear shopping cart, crear productos del shopping cart, update el pedido, pedir pedidos anteriores, crear calificación de un producto, y update calificación de un producto';

final String _createPedidoDescription = 'Se intenta crear un pedido';
final String _createPedidoProductsDescription = 'Se intenta acrear productos a un pedido';
final String _updatePedidoDescription = 'Se intenta actualizar un pedido';
final String _loadPedidosAnterioresDescription = 'Se intenta cargar los pedidos anteriormente hechos';
final String _createCalificationDescription = 'Se intenta crear la calificación de un producto';
final String _updateEstadoCalificationDeProductoPedidoDescription = 'Se intenta actualizar el estado de una calificación';

final Map<String, dynamic> _loginBody = {
  'email':'email2@gmail.com',
  'password':'12345678'
};

String _authorizationToken;

main(){
  group(_successTestGroupDescription, (){
    _testCreatePedido();
  });
}

void _testCreatePedido(){
  test(_createPedidoDescription, ()async{
    try{
      await _executeCreatePedidoValidations();
    }on ServiceStatusErr catch(err){
      
    }catch(err){

    }
  });
}

Future<void> _executeCreatePedidoValidations()async{

}

void _testCreatePedidoProducts(){
  test(_createPedidoProductsDescription, ()async{
    try{
      await _executeCreatePedidoProductsValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  });
}

Future<void> _executeCreatePedidoProductsValidations()async{
  
}

void _testUpdatePedido(){
  test(_updatePedidoDescription, ()async{
    try{
      await _executeUpdatePedidoValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  });
}

Future<void> _executeUpdatePedidoValidations()async{
  
}

void _testLoadPedidosAnteriores(){
  test(_loadPedidosAnterioresDescription, ()async{
    try{
      await _executeloadPedidosAnterioresValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  });
}

Future<void> _executeloadPedidosAnterioresValidations()async{
  
}

void _testCreateCalification(){
  test(_createCalificationDescription, ()async{
    try{
      await _executecreateCalificationValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  });
}

Future<void> _executecreateCalificationValidations()async{
  
}

void _testUpdateEstadoCalificationDeProductoPedido(){
  test(_updateEstadoCalificationDeProductoPedidoDescription, ()async{
    try{
      await _executeupdateEstadoCalificationDeProductoPedidoValidations();
    }on ServiceStatusErr catch(err){

    }catch(err){

    }
  });
}

Future<void> _executeupdateEstadoCalificationDeProductoPedidoValidations()async{
  
}

Future<void> _login()async{
  final Map<String, dynamic> response = await userService.login(_loginBody);
  _authorizationToken = response['token'];
}