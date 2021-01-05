import 'package:fanny_cliente/src/pages/buscar_page.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:fanny_cliente/src/pages/login_page.dart';
import 'package:fanny_cliente/src/pages/pedidos_page.dart';

class NavigationUtils{
  int index = 0;

  String get routeByIndex{
    switch(index){
      case 0:
        return HomePage.route;
      case 1:
        return BuscarPage.route;
      case 2:
        return PedidosPage.route;
      case 3:
        return LoginPage.route;
      default:
        return LoginPage.route;
    }
  }

  void reiniciarIndex(){
    index = 0;
  }
}

final NavigationUtils navigationUtils = NavigationUtils();