import 'package:fanny_cliente/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:fanny_cliente/src/widgets/fuera_de_polygons_widget.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/productos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/widgets/categorias_scrollview_widget.dart';
import 'package:fanny_cliente/src/widgets/header/header_widget.dart';
import 'package:fanny_cliente/src/widgets/productos/productos_widget.dart';
//importaciones locales
import 'package:fanny_cliente/src/utils/menu_categorias.dart';

class HomePage extends StatefulWidget with MenuCategorias{
  static final String route = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MenuCategorias{
  bool _widgetBuilded = false;
  BuildContext context;
  Size size;
  String token;
  UsuarioBloc usuarioBloc;
  LugaresBloc lugaresBloc;
  ProductosBloc productosBloc;
  SharedPreferencesBloc sharedPreferencesBloc;
  PedidosBloc pedidosBloc;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void didUpdateWidget(HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    if(!_widgetBuilded){
      print('Home page widget builded');
      //_cargarLugares();
      
      _widgetBuilded = true;
    }    
    print('Home page widget updated');
    super.didUpdateWidget(oldWidget);
  }

  /*
  No entiendo por qué no se quieren subir los cambios
  */
  @override
  Widget build(BuildContext appContext) {
    print('codigo icono:');
    print(Icons.fastfood.codePoint);
    context = appContext;
    //if(!Provider.pushNotificationsProvider(context).yaInicio)
      //Provider.pushNotificationsProvider(context).initNotificationsReceiver();
    Provider.pushNotificationsProvider(context).context = appContext;
    size = MediaQuery.of(context).size;
    token = Provider.usuarioBloc(context).token;
    usuarioBloc = Provider.usuarioBloc(context);
    lugaresBloc = Provider.lugaresBloc(context);
    productosBloc = Provider.productosBloc(context);
    sharedPreferencesBloc = Provider.sharedPreferencesBloc(context);
    pedidosBloc = Provider.pedidosBloc(context);
    return _createWidgets();
    //return FueraDePolygonsWidget();
  }
  

  void _inicializarPushNotificationsProvider()async{
    
  }

  Widget _createWidgets(){
    return BlocBuilder<PolygonsBloc, PolygonsState>(
      builder: (context, state) {
        if(state.estamosDentroDeAlgunPolygon)
          return _createElementosExitosos();
        else
          return FueraDePolygonsWidget();
      },
    );
  }
  

  Widget _createElementosExitosos(){
    return Scaffold(
      bottomNavigationBar: BottomBarWidget(),
      body: Column(
        children: <Widget>[
          //_crearMenuCategorias(size),
          SizedBox(height: size.height * 0.065),
          //_crearHeader(size, lugaresBloc),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: HeaderWidget()
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          CategoriasScrollviewWidget(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            //child: ProductosPorCategoriasWidget(),
            child: ProductosWidget(
              heightPercent: 0.6,
              tipoListaProducto: TipoListaProducto.LISTA_GENERAL,
            ),
          ),      
        ],
      ),
    );
  }
}