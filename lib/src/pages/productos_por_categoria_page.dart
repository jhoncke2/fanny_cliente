import 'package:fanny_cliente/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/productos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/size_bloc.dart';
import 'package:fanny_cliente/src/widgets/header/header_widget.dart';
import 'package:fanny_cliente/src/widgets/productos/productos_widget.dart';
class ProductosPorCategoriaPage extends StatefulWidget {
  static final route = 'Productos_por_categoria';
  @override
  _ProductosPorCategoriaPageState createState() => _ProductosPorCategoriaPageState();
}

class _ProductosPorCategoriaPageState extends State<ProductosPorCategoriaPage> {
  BuildContext context;
  Size size;
  SizeBloc sizeBloc;
  ProductosBloc productosBloc;

  Map<String, dynamic> _categoria;
  bool _widgetBuilded;

  @override
  void initState() { 
    _widgetBuilded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    sizeBloc = Provider.sizeBloc(context);
    productosBloc = Provider.productosBloc(context);
    _categoria = ModalRoute.of(context).settings.arguments;
    if(!_widgetBuilded){
      _widgetBuilded = true;
      productosBloc.cargarProductosPorCategoria(_categoria['id']);
    }
    return Scaffold(
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.06,
          ),
          HeaderWidget(),
          _crearTitulo(),
          ProductosWidget(
            tipoListaProducto: TipoListaProducto.POR_CATEGORIA,
            categoryId: _categoria['id'],
          )
        ],
      ),
    );
  }

  Widget _crearTitulo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          iconSize: sizeBloc.normalIconSize * 0.8,
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back_ios
          ),
          onPressed: (){
            _disposeProductosPorCategoria();
            Provider.navigationBloc(context).reiniciarIndex();
            Navigator.of(context).pop();
          },
        ),
        Text(
          _categoria['name'],
          style: TextStyle(
            color: Colors.black,
            fontSize: sizeBloc.titleSize,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(
          width: sizeBloc.xasisSobreYasis * 0.05,
        )
      ],
    );
  }

  Future<void> _disposeProductosPorCategoria()async{
    await productosBloc.disposeProductosPorCategoriaController();
    productosBloc.initProductosPorCategoriaController();
  }

  

  /*
  StreamBuilder(
    stream: productosBloc.productosPorCategoriaStream,
    builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
      if(snapshot.connectionState == ConnectionState.active){
        if(snapshot.hasData){
          return Container(
            height: size.height * 0.7,
            child: ListView(
              children: snapshot.data.map((ProductoModel producto){
                return ProductoCardWidget(producto: producto);
              }).toList(),
            ),
          );
        }else{
          return Container();
        }
      }else{
        return Container();
      }
    },
  )
  */
}