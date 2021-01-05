import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:flutter/material.dart';
class ProductoTiendaCardWidget extends StatefulWidget {

  ProductoModel producto;
  ProductoTiendaCardWidget(this.producto);

  @override
  
  _ProductoTiendaCardWidgetState createState() => _ProductoTiendaCardWidgetState();
}

class _ProductoTiendaCardWidgetState extends State<ProductoTiendaCardWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.04
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: size.width * 0.001
          )
        )
      ),
      width: size.width * 0.7,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Row(
             children: <Widget>[
               FadeInImage(
                 placeholder: AssetImage('assets/placeholder_images/domicilio_icono.png'),
                 image: NetworkImage(widget.producto.photos[0]['url']),
                 height: size.height * 0.15,
                 width: size.width * 0.45,
                 fit: BoxFit.cover,
               )
             ],
           ),
           SizedBox(
             height: size.height * 0.005,
           ),
           Text(
             (widget.producto.tipo == 'normal')? 'Producto de venta diaria': widget.producto.tipo,
             style: TextStyle(
               fontSize: size.width * 0.047,
               color: Colors.black.withOpacity(0.9)
             ),
           ),
           Text(
             widget.producto.name,
             style: TextStyle(
               fontSize: size.width * 0.045,
               color: Colors.black.withOpacity(0.9)
             ),
           ),
           Text(
             'Cantidad disponible: ${(widget.producto.stock??10)}',
             style: TextStyle(
               fontSize: size.width * 0.041,
               color: Colors.black.withOpacity(0.9)
             ),
           )
         ],
       ),
    );
  }
}