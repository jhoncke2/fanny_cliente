import 'package:fanny_cliente/src/bloc/map/map_bloc.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/pages/buscar_page.dart';
import 'package:fanny_cliente/src/pages/cuenta_page.dart';
import 'package:fanny_cliente/src/pages/direccion_create_mapa_page.dart';
import 'package:fanny_cliente/src/pages/direccion_create_page.dart';
import 'package:fanny_cliente/src/pages/favoritos_page.dart';
import 'package:fanny_cliente/src/pages/init_validation_page.dart';
import 'package:fanny_cliente/src/pages/pedidos_page.dart';
import 'package:fanny_cliente/src/pages/mapa_page.dart';
import 'package:fanny_cliente/src/pages/pasos_confirmacion_celular_page.dart';
import 'package:fanny_cliente/src/pages/pasos_recuperar_password_page.dart';
import 'package:fanny_cliente/src/pages/perfil_page.dart';
import 'package:fanny_cliente/src/pages/productos_por_categoria_page.dart';
import 'package:fanny_cliente/src/pages/splash_screen_page.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:fanny_cliente/src/pages/login_page.dart';
import 'package:fanny_cliente/src/pages/producto_detail_page.dart';
import 'package:fanny_cliente/src/pages/productos_catalogo_page.dart';
import 'package:fanny_cliente/src/pages/carrito_page.dart';
import 'package:fanny_cliente/src/pages/register_page.dart';

void main()async{
   runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  _MyAppState _state = _MyAppState();
  @override
  _MyAppState createState(){
    _state = _MyAppState();
    return _state;
  }

  BuildContext get appContext => _state.context;
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext appContext){
    /**
     * Esta es la forma como Flutter recomienda que manipulemos la información
     * y/o el estado de la misma.
     * 
     * Como estoy implementando el InheritedWidget en la parte más alta(la cabeza) del
     * árbol de Widgets, va a ser distribuido alrededor de toda mi aplicación.
     */
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(create: (_)=>MapBloc()),
        BlocProvider<PolygonsBloc>(create: (_)=>PolygonsBloc()),
        BlocProvider<UserBloc>(create: (_)=>UserBloc()),
      ],
      child: Provider(
        child: MaterialApp(
          title: 'Domicilios',
          initialRoute: InitValidationPage.route,
          routes:{
            InitValidationPage.route:(BuildContext context)=>InitValidationPage(),
            HomePage.route:(BuildContext context)=>HomePage(),
            ProductosPorCategoriaPage.route:(BuildContext context)=>ProductosPorCategoriaPage(),
            SplashScreenPage.route:(BuildContext context)=>SplashScreenPage(),
            LoginPage.route:(BuildContext context)=>LoginPage(),
            RegisterPage.route:(BuildContext context)=>RegisterPage(),
            PasosRecuperarPasswordPage.route:(BuildContext context)=>PasosRecuperarPasswordPage(),
            PasosConfirmacionCelularPage.route:(BuildContext context)=>PasosConfirmacionCelularPage(),
            BuscarPage.route:(BuildContext context)=>BuscarPage(),
            PedidosPage.route:(BuildContext context)=>PedidosPage(),
            CuentaPage.route:(BuildContext context)=>CuentaPage(),
            PerfilPage.route:(BuildContext context)=>PerfilPage(),
            DireccionCreatePage.route:(BuildContext context)=>DireccionCreatePage(),
            ProductosCatalogoPage.route:(BuildContext context)=>ProductosCatalogoPage(),
            ProductoDetailPage.route:(BuildContext context)=>ProductoDetailPage(),
            FavoritosPage.route:(BuildContext context)=>FavoritosPage(),
            CarritoPage.route:(BuildContext context)=>CarritoPage(),
            MapaPage.route:(BuildContext context)=>MapaPage(),
            DireccionCreateMapaPage.route:(BuildContext context)=>DireccionCreateMapaPage(),
          },
          theme: ThemeData(
            fontFamily: 'OpenSans',
            //backgroundColor: Color.fromRGBO(50, 196, 171, 1),//verde azulado
            //backgroundColor: Color.fromRGBO(240, 200, 102, 1),
            primaryColor: Color.fromRGBO(164, 41, 15, 1),
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),   
            secondaryHeaderColor: Color.fromRGBO(69, 58, 60, 1),
            //primaryColor: Colors.white,
            //secondaryHeaderColor: Color.fromRGBO(134, 174, 188, 1),//azul grisaseo
            //secondaryHeaderColor: Color.fromRGBO(240, 190, 92, 1),//orange
            hoverColor: Colors.white,
            iconTheme: IconThemeData(
              //color: Color.fromRGBO(240, 200, 102, 1),
              color: Colors.blueAccent
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.blue,
              focusColor: Colors.grey,
              hoverColor: Colors.redAccent
            ),
            buttonColor: Color.fromRGBO(240, 200, 102, 1),
            buttonTheme: ButtonThemeData(
              buttonColor: Color.fromRGBO(240, 200, 102, 1),
            )
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

