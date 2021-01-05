import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:fanny_cliente/src/utils/menu_categorias.dart';
import 'package:fanny_cliente/src/widgets/productos/producto_card_widget.dart';
import 'package:flutter/material.dart';
class ProductosPorCategoriasWidget extends StatefulWidget {

  @override
  _ProductosPorCategoriasWidgetState createState() => _ProductosPorCategoriasWidgetState();
}

class _ProductosPorCategoriasWidgetState extends State<ProductosPorCategoriasWidget> with MenuCategorias{
  ProductosModel _productosModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.761,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        children: categorias.map((categoria){
          return _crearListaPorCategoria(context, size, categoria['nombre']);
        }).toList(),
      ),
    );
  }

  Widget _crearListaPorCategoria(BuildContext context, Size size, String nombreCategoria){
    List<ProductoModel> productosPorCategoria = [];
    List<Widget> productosWidgets = [];
    for(int i = 0; i < productosPorCategoria.length; i++){
      productosWidgets.add(
        Container(
          //el primer elemento no tiene padding left y el último no tiene padding right
          padding: (i>0 && i < productosPorCategoria.length -1 )?
            EdgeInsets.symmetric(horizontal: size.width * 0.031)
            :(i==0)? EdgeInsets.only(right: size.width * 0.031)
            : EdgeInsets.only(left: size.width * 0.031),
          child: ProductoCardWidget(producto: productosPorCategoria[i])
        )
      );
      
    }
    return Container(
      height: size.height * 0.3,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            nombreCategoria,
            style: TextStyle(
              fontSize: size.width * 0.055,
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            height: size.height * 0.22,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: productosWidgets,
            ),
          ),
          SizedBox(
            height: size.height * 0.025,
          )

        ],
      ),
    );
  }
}