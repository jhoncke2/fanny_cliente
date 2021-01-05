import 'package:fanny_cliente/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/navigation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:fanny_cliente/src/pages/login_page.dart';
import 'package:fanny_cliente/src/providers/push_notifications_provider.dart';
import 'package:fanny_cliente/src/widgets/header/header_widget.dart';

class PedidosPage extends StatefulWidget {
  static final route = 'pedidos';
  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  BuildContext context;
  SharedPreferencesBloc sharedPreferencesBloc;
  Size size;
  PedidosBloc pedidosBloc;
  NavigationBloc navigationBloc;
  String token;

  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    sharedPreferencesBloc = Provider.sharedPreferencesBloc(context);
    pedidosBloc = Provider.pedidosBloc(context);
    navigationBloc = Provider.navigationBloc(context);
    token = Provider.usuarioBloc(context).token;
    _inicializarPedidoFromStorage();
    return Scaffold(
      key: _scaffoldKey,
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Future<void> _inicializarPedidoFromStorage()async{
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      List<Map<String, dynamic>> storagePedidoTemporal = await sharedPreferencesBloc.getPedidoTemporal();
      if(storagePedidoTemporal != null){
        pedidosBloc.agregarTodosLosProductosAPedido(storagePedidoTemporal);
        pedidosBloc.estadoPedido = EstadosPedido.EN_CARRITO;
      }
    });
  }

  Widget _crearElementos(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.064,
          ),
          HeaderWidget(),
          SizedBox(
            height: size.height * 0.01,
          ),
          _crearTitulo(size),
          _crearListViewPedidos(),
          SizedBox(
            height: size.height * 0.015,
          ),
          _crearElementosBottomSegunIndex(),
        ],
      ),
    );
  }

  Widget _crearTitulo(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.only(
              right: size.width * 0.04
            ),
            width: size.width * 0.25,
            child: Text(
              'Pedido \nactual',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.055,
                color: (pedidosBloc.indexNavegacionPedidosPage == 0)? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: (){
              pedidosBloc.indexNavegacionPedidosPage = 0;
              setState(() {
                
              });           
          },
        ),
        Container(
          height: size.height * 0.05,
          width: size.width * 0.002,
          color: Colors.black,
        ),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.only(
              left: size.width * 0.04
            ),
            width: size.width * 0.38,
            child: Text(
              'Pedidos \nanteriores',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.055,
                color: (pedidosBloc.indexNavegacionPedidosPage == 1)? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          onTap: (){        
            actualizarIndex1();
          },
        ),
      ],
    );
  }

  Future<void> actualizarIndex1()async{
    if(pedidosBloc.indexNavegacionPedidosPage == 0){
      pedidosBloc.indexNavegacionPedidosPage = 1;
      setState(() {
        
      });
      pedidosBloc.cargarPedidosAnterioresPorClienteOTienda(token, 'cliente', null);
    }
  }

  Widget _crearListViewPedidos( ){
    return Container(
      height: size.height * ((pedidosBloc.indexNavegacionPedidosPage == 0)? 0.53 : 0.66),
      child: ((pedidosBloc.indexNavegacionPedidosPage == 0)?
        _crearStreamBuilderIndex0()
      : _crearStreamBuilderIndex1()
      )
    );
  }

  StreamBuilder<List<Map<String, dynamic>>> _crearStreamBuilderIndex0(){
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: pedidosBloc.pedidoActualClienteStream,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> pedidoActualSnapshot) {
        print(pedidoActualSnapshot.connectionState);
        if(pedidoActualSnapshot.connectionState == ConnectionState.active){
          if(pedidoActualSnapshot.hasData){
            return Column(
              children: <Widget>[
                Container(
                  height: size.height * ((pedidosBloc.indexNavegacionPedidosPage == 0)? 0.47 : 0.65),
                  child: ListView(
                    padding: EdgeInsets.only(top:size.height * 0.045, bottom: size.height * 0.02),
                    children: _crearItemsListViewPedidoActual(pedidoActualSnapshot.data)
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Valor total del pedido \$${_calcularValorTotalProductos(pedidoActualSnapshot.data)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: size.width * 0.048
                  ),
                )             
              ],
            );
          }else{
            return Container();
          }
        }else{
          return Container();
        }
          
      }
    );
  }

  StreamBuilder<List<Map<String, dynamic>>> _crearStreamBuilderIndex1(){
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: pedidosBloc.pedidosHistorialClienteStream,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            return Column(
              children: <Widget>[
                Container(
                  height: size.height * ((pedidosBloc.indexNavegacionPedidosPage == 0)? 0.47 : 0.65),
                  child: ListView(
                    padding: EdgeInsets.only(top:size.height * 0.045, bottom: size.height * 0.02),
                    children: _crearItemsListViewPedidosAnteriores(snapshot.data)
                  ),
                ),            
              ],
            );
          }else{
            return Container();
          }
        }else{
          return Container();
        }
        
      }
    );
  }

  List<Widget> _crearItemsListViewPedidoActual(List<Map<String, dynamic>> pedidoActualProductosMap){
    return pedidoActualProductosMap.map((Map<String, dynamic> pedidoProducto){
      return ListTile(
        title: _crearProductoCarritoActual(pedidoProducto),
        //title: _crearProductoPedido(pedidoProducto['data_product'], pedidoProducto['cantidad'], pedidoProducto['precio'], 0),
      );
    }).toList();
  }

  List<Widget> 
  _crearItemsListViewPedidosAnteriores(List<Map<String, dynamic>> pedidos){
    return pedidos.map((Map<String, dynamic> pedido){
      List<Widget> pedidoActualItems = [];
      int costoTotal = 0;
      List<Map<String, dynamic>> productosPedido = ((pedido['products'] as List).cast<Map<String, dynamic>>());
      for(int i = 0; i < productosPedido.length; i++){
        Map<String, dynamic> productoActual = productosPedido[i];
        costoTotal += productoActual['cantidad'] * productoActual['precio'];
        pedidoActualItems.add(_crearProductoPedido((productoActual['data_product'] as ProductoModel), productoActual['cantidad'], productoActual['precio'], i));
      }
      pedidoActualItems.add(
        Text(
          'Costo total: $costoTotal',
          style: TextStyle(
            color: Colors.grey,
            fontSize: size.width * 0.045
          ),
        )
      );
      return ListTile(
        title: Column(
          children: pedidoActualItems,
        )
      );
    }).toList();
  }

  

  double _calcularValorTotalProductos(List<Map<String, dynamic>> elementos){
    double valorTotal = 0;
    elementos.forEach((Map<String, dynamic> elemento){
      ProductoModel producto = (elemento['data_product'] as ProductoModel);
      valorTotal += producto.precio * elemento['cantidad'];
    });
    return valorTotal;
  }

  Widget _crearProductoPedido( ProductoModel producto, int cantidad, int precio, int pedidoIndex){
    return Container(
      child: Row(
        children: <Widget>[
          FadeInImage(
            width: size.width * 0.3,
            height: size.height * 0.115,
            fit: BoxFit.fill,
            placeholder: AssetImage('assets/placeholder_images/domicilio_icono_2.jpg'),
            image: NetworkImage(producto.photos[0]['url']),
          ),
          SizedBox(
            width: size.width * 0.038,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width  * 0.4),
                child: Text(
                  producto.name,
                  style: TextStyle(
                    fontSize: size.width * 0.049,
                    color: Colors.black.withOpacity(0.85)
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width  * 0.27),
                child: Text(
                  'no figura',
                  style: TextStyle(
                    fontSize: size.width * 0.032,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              Text(
                'cantidad: $cantidad',
                style: TextStyle(
                  fontSize: size.width * 0.037,
                  color: Colors.black.withOpacity(0.8)
                ),
              ),
              Text(
                '20-06-2020',
                style: TextStyle(
                  fontSize: size.width * 0.037,
                  color: Colors.black.withOpacity(0.8)
                ),
              ),
              Text(
                'no figura',
                style: TextStyle(
                  fontSize: size.width * 0.039,
                  color: Colors.black.withOpacity(0.8)
                ),
              ),
            ],
          )
        ],
      )
    );
  }

  Widget _crearProductoCarritoActual(Map<String, dynamic> pedidoProducto){
    ProductoModel producto = pedidoProducto['data_product'];
    int cantidad = pedidoProducto['cantidad']; 
    int precio = pedidoProducto['precio'];
    return Container(
      height: size.height * 0.15,
      width: size.width * 0.7,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _crearCardProductoProgramado(producto, cantidad, precio),
          SizedBox(
            width: size.width * 0.1
          ),
          _crearBotonEliminar(pedidoProducto),
          SizedBox(
            width: size.width * 0.025,
          )
        ],
      ),
    );
  }

  Widget _crearCardProductoProgramado(ProductoModel producto, int cantidad, int precio){
    return Container(
      height: size.height * 0.2,
      child: Row(
        children: <Widget>[
          FadeInImage(
            width: size.width * 0.3,
            height: size.height * 0.115,
            fit: BoxFit.fill,
            placeholder: AssetImage('assets/placeholder_images/productos_gifs/gif_cargando_4.gif'),
            image: NetworkImage(producto.photos[0]['url']),
          ),
          SizedBox(
            width: size.width * 0.038,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width  * 0.4),
                child: Text(
                  producto.name,
                  style: TextStyle(
                    fontSize: size.width * 0.049,
                    color: Colors.black.withOpacity(0.85)
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width  * 0.27),
                child: Text(
                  'no figura',
                  style: TextStyle(
                    fontSize: size.width * 0.032,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              Text(
                'cantidad: $cantidad',
                style: TextStyle(
                  fontSize: size.width * 0.037,
                  color: Colors.black.withOpacity(0.8)
                ),
              ),
              Text(
                '20-06-2020',
                style: TextStyle(
                  fontSize: size.width * 0.037,
                  color: Colors.black.withOpacity(0.8)
                ),
              ),
              Text(
                'no figura',
                style: TextStyle(
                  fontSize: size.width * 0.039,
                  color: Colors.black.withOpacity(0.8)
                ),
              ),
            ],
          )
        ],
      )
    );
  }

  Widget _crearBotonEliminar(Map<String, dynamic> pedidoProducto){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          color: Colors.redAccent,
          iconSize: size.width * 0.085,
          icon: Icon(
            Icons.delete_outline
          ),
          onPressed: (){
            pedidosBloc.quitarProductoDePedido(pedidoProducto);
          },
        ),
      ],
    );
  }

  Widget _crearElementosBottomSegunIndex(){
    List<Widget> elementosBottom = [];
    if(pedidosBloc.indexNavegacionPedidosPage == 0){
      elementosBottom.addAll(
        [
          Container(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.045)
              ),
              color: Theme.of(context).secondaryHeaderColor,
              child: Text(
                'Agregar otro producto al pedido',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: size.width * 0.042,
                ),
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(HomePage.route);
                navigationBloc.reiniciarIndex();
              },
            ),
          ),
          Container(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.045)
              ),
              color: Theme.of(context).primaryColor,
              child: Text(
                'Pagar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: size.width * 0.042,
                ),
              ),
              onPressed: (){
                _generarPedido();
              },
            ),
          )
        ]
      );
    }
    return Column(
      children: elementosBottom,
    );
  }

  Future<void> _generarPedido()async{
    try{
      //List<Map<String, dynamic>> pedidoActual =  ((await pedidosBloc.pedidoActualClienteStream.v).cast<List<Map<String, dynamic>>>()).last;
      if(Provider.usuarioBloc(context).usuario != null){
        Map<String, dynamic> crearCarritoResponse = await pedidosBloc.generarPedido(token, Provider.lugaresBloc(context).actualElegido.id);
        sharedPreferencesBloc.deletePedidoTemporal();
        final pushNotificationsProvider = Provider.pushNotificationsProvider(context);
        pushNotificationsProvider.sendPushNotification(crearCarritoResponse['tienda_mobile_token'], PushNotificationsProvider.notificationTypes[0], {});
        pedidosBloc.disposePedidoActualClienteController();
        pedidosBloc.initPedidoActualClienteController();
        navigationBloc.reiniciarIndex();
        Navigator.of(context).pushReplacementNamed(HomePage.route);
      }else{
        Navigator.of(context).pushNamed(LoginPage.route);
      }
      
    }catch(err){
      print(err);
    }
    
  }
}