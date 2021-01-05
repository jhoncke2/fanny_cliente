import 'package:fanny_cliente/src/pages/carrito_page.dart';
//importaciones locales
import 'package:fanny_cliente/src/utils/menu_categorias.dart';
import 'package:fanny_cliente/src/widgets/productos/productos_widget.dart';
import 'package:flutter/material.dart';

class ProductosCatalogoPage extends StatelessWidget with MenuCategorias{
  static final route = 'productos_catalogo';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 12.5,
        title: Container(
          padding: EdgeInsets.only(left: size.width * 0.025, bottom: 0.0),
          margin: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.02),
          height: size.height * 0.055,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white
          ),
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search, 
              ),
              hintText: 'Buscar',
            ),
            onChanged: (String value){
              
            },
          ),
        ),
        actions: <Widget>[
          FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            child: Icon(Icons.shopping_cart),
            onPressed: (){
              Navigator.pushNamed(context, CarritoPage.route);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          _crearFondo(context, size),
          _crearElementos(context, size),
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context, Size size){
    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
    );
  }

  Widget _crearElementos(BuildContext context, Size size){
    return Row(
      children: <Widget>[
        _crearBarraVertical(context, size),
        _crearCatalogo(context, size),
      ],
    );
  }

  Widget _crearBarraVertical(BuildContext context, Size size){
    double categoriaFontSize = size.width * 0.037;
    List<Widget> barraCategorias = categorias.map((actual){
      return _crearCardCategoria(size, categoriaFontSize, actual,  );
    }).toList();
    final categoriaTodas = {
      'nombre':'todas',
      'icono': Icons.all_inclusive,
      'color': Colors.indigo,
    };
    barraCategorias.add(_crearCardCategoria( size, categoriaFontSize, categoriaTodas));

    return Container(
      //padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        //color: Color.fromRGBO(181, 198, 205, 1),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4.5,
            spreadRadius: 1.0,
            offset: Offset(
              2.0,
              0.0
            ),
          ),
        ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: barraCategorias,
        ),
      )
    );
  }

  Widget _crearCardCategoria(Size size, double categoriaFontSize, categoria ){
    return Container(
      margin: EdgeInsets.symmetric(),
      padding: EdgeInsets.symmetric(vertical: 3.0),
      width: size.width * 0.2,
      height: size.height * 0.09,
      decoration: BoxDecoration(
        color: Colors.white,
        //color: Color.fromRGBO(193, 210, 216, 1),
        border: Border(bottom: BorderSide(color: Colors.black45)),
        
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 3.0,
          ),
          Icon(
            categoria['icono'],
            color: categoria['color'],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            categoria['nombre'],
            style: TextStyle(
              fontSize: categoriaFontSize
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearCatalogo(BuildContext context, Size size){
    return ProductosWidget(
      heightPercent: 0.87,
    );
  }


}