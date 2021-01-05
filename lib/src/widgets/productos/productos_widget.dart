import 'package:fanny_cliente/src/bloc_old/productos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:flutter/material.dart';
//Importaciones
import 'package:fanny_cliente/src/widgets/productos/producto_card_widget.dart';

enum TipoListaProducto{
  LISTA_GENERAL,
  POR_CATEGORIA,
  BY_SEARCH
}

class ProductosWidget extends StatefulWidget {
  //lista estática de productos ingresada desde clase padre, en caso de que se quiera desplegar esa lista especifica de elementos.

  double horizontalMarginPercent;
  double horizontalPaddinghPercent;
  double heightPercent;
  double widthPercent;
  bool scrollable;

  TipoListaProducto tipoListaProducto;
  //para el caso de productos por categoria
  int categoryId;

  ProductosWidget({
    this.horizontalMarginPercent = 0.015,
    this.horizontalPaddinghPercent = 0.0,
    this.heightPercent = 0.7,
    this.widthPercent = 0.76,
    this.scrollable = true,
    this.tipoListaProducto,
    this.categoryId
  });

  @override
  _ProductosWidgetState createState() => _ProductosWidgetState();
}

class _ProductosWidgetState extends State<ProductosWidget> {
  bool _widgetBuilded;

  BuildContext context;
  Size size;

  ProductosBloc productosBloc;

  @override
  void initState() { 
    super.initState();
    _widgetBuilded = false;
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    productosBloc = Provider.productosBloc(context);
    if(!_widgetBuilded){
      switch(widget.tipoListaProducto){
        case TipoListaProducto.LISTA_GENERAL:
          productosBloc.cargarProductosPublic();
        break;
        case  TipoListaProducto.POR_CATEGORIA:
          productosBloc.cargarProductosPorCategoria(widget.categoryId);
        break;
        case TipoListaProducto.BY_SEARCH:
          print('productos widget by search');
        break;
      }
      
      _widgetBuilded = true;
    }
    return _crearStreamBuilder();
  }

  Widget _crearStreamBuilder(){
    Stream<List<ProductoModel>> stream;
    switch(widget.tipoListaProducto){
      case TipoListaProducto.LISTA_GENERAL:
        return StreamBuilder(
          stream: productosBloc.productosPublicStream,
          builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return _crearGrid(snapshot. data);
              }else{
                return Container();
              }
            }else{
              return Container();
            }
          }, 
        );
      case TipoListaProducto.POR_CATEGORIA:
        return StreamBuilder(
          stream: productosBloc.productosPorCategoriaStream,
          builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return _crearGrid(snapshot.data);
              }else{
                return Container();
              }
            }else{
              return Container();
            }
          },
        );
      case  TipoListaProducto.BY_SEARCH:
        return StreamBuilder(
          stream: productosBloc.productosSearchStream,
          builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return _crearGrid(snapshot.data);
              }else{
                return Container();
              }
            }else{
              return Container();
            }
          },
        );
    }
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext appContext, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            
          }else{
            return Container();
          }
        }else{
          return Container();
        }
        
        
      },
    );
  }

  Widget _crearGrid(List<ProductoModel> productos){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * widget.horizontalMarginPercent),
      padding: EdgeInsets.symmetric(vertical: 0),
      //0.18 es el porcentaje de width de pantalla que tiene cada card (?).
      height: size.height * widget.heightPercent,
      width: size.width,     
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
      /**
       * En 2 casos lo necesito scrollable, en 1 no
       */
      child: GridView.count(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.035),
          crossAxisCount: 3,
          mainAxisSpacing: size.width * 0.028,
          crossAxisSpacing: size.height * 0.03,
          childAspectRatio: 0.58,
          children: productos.map((ProductoModel producto) => ProductoCardWidget(producto: producto,)).toList(),
      ),
    );
  }

  /*
  child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: size.width * 0.028,
          crossAxisSpacing: size.height * 0.03,
          childAspectRatio: 0.655,
        ),
        itemBuilder: (BuildContext context, int index){
          return ProductoCardWidget(producto: productosAMostrar[index]);
        },
        itemCount: productosAMostrar.length,
      ),
  */
}