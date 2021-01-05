import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:fanny_cliente/src/bloc_old/pedidos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/productos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/widgets/bottom_bar/bottom_bar_widget.dart';
//import 'package:porta/src/widgets/custom_widgets/custom_popup_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//importaciones locales
import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:fanny_cliente/src/utils/data_prueba/resenhas_prueba.dart' as resenhas;

class ProductoDetailPage extends StatefulWidget {
  static final route = 'producto_detail';
  @override
  _ProductoDetailPageState createState() => _ProductoDetailPageState();
}

class _ProductoDetailPageState extends State<ProductoDetailPage> {
  BuildContext context; 
  Size size;
  UsuarioBloc usuarioBloc;
  ProductosBloc productosBloc;
  PedidosBloc pedidosBloc;

  bool _esFavorito;
  //test
  double _promedioPuntajePrueba = 4.1;

  //Código
  int _favoritoId;
  ProductoModel _producto;
  //unidades a pedir
  int _cantidadUnidades = 1;

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    usuarioBloc = Provider.usuarioBloc(context);
    productosBloc = Provider.productosBloc(context);
    pedidosBloc = Provider.pedidosBloc(context);
    Map<String, dynamic> argument = ModalRoute.of(context).settings.arguments;
    
    if(argument['tipo'] == 'favorito'){
      if(_esFavorito == null)
        _esFavorito = true;
      _favoritoId = argument['value']['id'];
      _producto  = ProductoModel.fromJsonMap(argument['value']['product']);
    }else{
      _producto  = argument['value'];
      if(_esFavorito == null)
        _verificarSiEsFavorito();
    }
    _producto;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _crearElementos(context, size, _producto),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(BuildContext context, Size size, ProductoModel producto){
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      children: <Widget>[
        SizedBox(
          height: size.height * 0.065
        ),
        _crearTitulo(size),
        SizedBox(
          height: size.height * 0.025,
        ),
        Container(
          child: FadeInImage(
            width: size.width * 0.8,
            height: size.height * 0.25,
            fit: BoxFit.cover,
            image: NetworkImage(producto.photos[0]['url']),
            placeholder: AssetImage('assets/placeholder_images/domicilio_icono.png')
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Center(
          child: Text(
            'Tiempo máximo de entrega: ${_producto.tiempoDeEntrega} minutos',
            style: TextStyle(
              fontSize: size.width * 0.031,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.75)
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: Text(
            producto.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.06,
              color: Colors.black
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.025,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Text(
            producto.description,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: size.width * 0.04,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.07,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: _crearTablaValorCantidad(context, size),
        ),
        SizedBox(
          height: size.height * 0.04,
        ),
        _crearBotonSubmit(),
        SizedBox(
          height: size.height * 0.01,
        ),
        Divider(
          color: Colors.black.withOpacity(0.8),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        _crearResenhas(),
        SizedBox(
          height: size.height * 0.035,
        ),
      ],
    );
  }

  void _probarLast()async{
    bool favoritos =  await productosBloc.favoritosStream.isEmpty;
    print(favoritos);
  }

  Widget _crearTitulo(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          iconSize: size.width * 0.06,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),     
        Text(
          //_producto.store.userName,
          'Fanny tienda',
          style: TextStyle(
            color: Colors.black.withOpacity(0.9),
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.07
          ),
        ),
        (
          (usuarioBloc.usuario != null)?
            IconButton(
              icon: (
                (_esFavorito)?
                Icon(Icons.favorite)
                :Icon(Icons.favorite_border)
              ),
              color: Colors.redAccent,
              iconSize: size.width * 0.072,
              onPressed: (){
                _crearOEliminarFavorito((_esFavorito)? 'eliminar' : 'crear');   
              },
            )
          :SizedBox(
            width: size.width * 0.1,
          )
        ),

      ],
    );
  }
  /**
   * params:
   *  *accion: <"crear"|"eliminar">
   */
  void _crearOEliminarFavorito(String accion)async{
    if(accion == 'crear'){
      Map<String, dynamic> response = await productosBloc.crearFavorito(usuarioBloc.token, usuarioBloc.usuario.id, _producto.id);
      if(response['status'] == 'ok'){
        _esFavorito = true;
        setState(() {
          
        });
      }    
    }
    else{
      Map<String, dynamic> response = await productosBloc.eliminarFavorito(usuarioBloc.token, _favoritoId);
      if(response['status'] == 'ok'){
        _esFavorito = false;
        setState(() {
          
        });
      }
    }
  }

  void _verificarSiEsFavorito()async{
    if(_favoritoId != null){
      _esFavorito = true;
      return;
    }
    _esFavorito = false;
    List<Map<String, dynamic>> favoritos = await productosBloc.favoritosStream.last;
    print('****favoritos:');
    print(favoritos);
     for(int i = 0; i < favoritos.length; i++){
       if(favoritos[i]['product']['id'] == _producto.id){
         _esFavorito = true;
         _favoritoId = favoritos[i]['id'];
         break;
       }        
     }
     setState(() {
       
     });
  }


  Widget _crearTablaValorCantidad(BuildContext context, Size size){
    return Table(
      border: TableBorder(

      ),
      children: <TableRow>[
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0
              )
            )
          ),
          children: <Widget>[
            Text(
              'Valor unitario',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,

                fontSize: size.width * 0.044,
              ),
            ),
            Text(
              'Cantidad',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.044,
              ),
            )
          ]
        ),
        TableRow(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:size.height * 0.015),
              child: Text(
                //'\$${_producto.precio * _cantidadUnidades}',
                '${_producto.precio}',
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontSize: size.width * 0.045
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: size.height * 0.015),
                width: size.width * 0.12,
                child: _crearPopupCantidad(30),
              ),
            )
          ]
        ),
        TableRow(
          children: <Widget>[
            Container(),
            Column(
              children: <Widget>[
                Text(
                  'unidades',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.042,
                  ),
                ),
              ],
            ),
            
          ]
        )
      ],
    );
  }

  Widget _crearPopupCantidad(int maximoCantidad){
    List<PopupMenuEntry<int>> popupMenuItems = [];
    popupMenuItems.add(
      PopupMenuItem<int>(
        enabled: false,
        height: size.height * 0.3,
        value: 0,
        child: _crearListViewCantidad(20),
      )
    );
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.04)
      ),
      itemBuilder: (BuildContext context){
        return popupMenuItems;
      },
      child: Row(
        children: <Widget>[
          Text(
            '$_cantidadUnidades',
            style: TextStyle(
              fontSize: size.width * 0.045,
              color: Colors.black
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: size.width * 0.065,
            color: Colors.grey,
          )
        ],
      ),
      onSelected: (int newValue){
        setState(() {
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget _crearListViewCantidad(int cantidadMaxima){
    List<Widget> cantidadFlatButtonItems = [];
    for(int i = 1; i <= cantidadMaxima; i++){
      cantidadFlatButtonItems.add(
        Container(
          padding: EdgeInsets.all(0.0),
          height: size.height * 0.038,
          child: FlatButton(
            
            padding: EdgeInsets.symmetric(
              horizontal:0, 
              vertical: size.height * 0.004
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(0.0),
                  width: size.width * 0.095,
                  height: size.height * 0.025,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: ((i == _cantidadUnidades )?
                      null
                      :Border.all(
                        width: 1,
                        color: Colors.black
                      )
                    ),
                    color: (i == _cantidadUnidades)? Theme.of(context).primaryColor.withOpacity(0.8) : Colors.white,
                  ),
                ),
                Text(
                  '$i',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.036
                  ),
                ),
              ] 
            ),
            onPressed: (){
              _cantidadUnidades = i;
              setState(() {
                Navigator.of(context).pop();
              });
            }
          ),
          
        )
      );
    }
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      height: size.height * 0.3,
      width: size.width * 0.19,
      child: ListView(
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        children: cantidadFlatButtonItems,
      ),
    );
  }

  Widget _crearResenhas(){
    List<Widget> _columnChildren = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Reseñas',
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.06
            ),
          ),
          _crearEstrellasPuntaje(size),
        ],
      ),
      SizedBox(
        height: size.height * 0.035,
      ),
    ];
    resenhas.resenhas.forEach((Map<String, dynamic> resenha){
      _columnChildren.add(
        _crearResenha(size, resenha)
      );
      _columnChildren.add(
        SizedBox(
          height: size.height * 0.055,
        )
      );
    });
    return Column(
      children: _columnChildren,
    );
  }

  Widget _crearEstrellasPuntaje(Size size){
    return Row(
      children: <Widget>[
        _crearIconoEstrella(size, 1),
        _crearIconoEstrella(size, 2),
        _crearIconoEstrella(size, 3),
        _crearIconoEstrella(size, 4),
        _crearIconoEstrella(size, 5),
      ],
    );
  }

  Widget _crearIconoEstrella(Size size, int index){
    IconData iconData = (_promedioPuntajePrueba >= index)? Icons.star
                      : (_promedioPuntajePrueba >= index-0.5)? Icons.star_half
                      : Icons.star_border;
    return Icon(
      iconData,
      color: Colors.orangeAccent,
      size: size.width * 0.055,
    );
  }

  Widget _crearResenha(Size size, Map<String, dynamic> resenha){
    return Container(
      decoration: BoxDecoration(
        //color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      width: size.width * 0.11,
                      height: size.height * 0.07,
                      image: NetworkImage(resenha['url_foto']),
                      placeholder: AssetImage('assets/placeholder_images/user.png'),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.045,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        resenha['nombre_usuario'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.046,
                        ),
                      ),
                      Text(
                        resenha['fecha'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.035,
                        ),
                      ),
                    ],
                  ),
                ],   
              ),
              
              SizedBox(
                width: size.width * 0.03,
              ),
              Container(
                width: size.width * 0.14,
                height: size.height * 0.039,
                child: Center(
                  child: Badge(
                    shape: BadgeShape.square,
                    badgeColor: Colors.grey,
                    borderRadius: size.width * 0.011,
                    badgeContent: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                          '${resenha['calificacion']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.029
                          ),
                        ),
                        Icon(
                          Icons.star,
                          size: size.width * 0.041,
                          color: Colors.orangeAccent,
                        )
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
          SizedBox(
            height: size.height * 0.013,
          ),
          Text(
            resenha['comentario'],
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.04,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _crearBotonSubmit(){
    return Center(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.045),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.045,
          vertical: size.height * 0.007
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        child: Text(
          'Agregar a pedidos',
          style: TextStyle(
            fontSize: size.width * 0.05,
            color: Colors.white.withOpacity(0.8)
          ),
        ),
        onPressed: (){
          _guardarDatos();
        },
      ),
    );
  }

  void _guardarDatos()async{
    print(_producto);
    await pedidosBloc.agregarProductoAPedido({
      'cantidad':_cantidadUnidades,
      'precio':_producto.precio,
      'data_product':_producto,
    });
    Navigator.of(context).pop();
    //await pedidosBloc
  }
}