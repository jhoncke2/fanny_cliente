import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
//Importaciones locales
import 'package:fanny_cliente/src/pages/producto_detail_page.dart';
// ignore: must_be_immutable
class ProductoCardWidget extends StatelessWidget {
  BuildContext context;
  Size size;

  ProductoModel producto;
  final percentageWidthScreen;

  ProductoCardWidget({
    this.producto,
    this.percentageWidthScreen
  });

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    FadeInImage fadeInImage;
    try{
       fadeInImage = FadeInImage(
        fit: BoxFit.fill,
        image: NetworkImage(producto.photos[0]['url']),
        placeholder: AssetImage('assets/placeholder_images/productos_gifs/gif_cargando_4.gif'),
      );
    }catch(err){
      print('error: $err');
    }
    return GestureDetector(
      child: Container(
        width: size.width * 0.27,
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: size.height * 0.12,
              width: size.width * 0.27,
              child: fadeInImage??Container(height: 0.05,),
            ),
            
            SizedBox(
              height: size.height * 0.005,
            ),
            _crearTextoEnConstrainedBox(producto.name),
            _crearTextoEnConstrainedBox(producto.category['name']),
            SizedBox(
              height: size.height * 0.003,
            ),
            ((producto.calificacion != null)?
              _crearBadge()
            : _crearTextoEnConstrainedBox('sin calificar', color: Colors.black.withOpacity(0.75), width: size.width * 0.03)
            ),
            
          ],
        ),
      ),
      onTap: (){
        Navigator.pushNamed(
          context, 
          ProductoDetailPage.route, 
          arguments: {
            'tipo':'normal', 
            'value':producto
          }
        );
      },
    );
  }

  Widget _crearTextoEnConstrainedBox(String texto, {Color color, double width}){
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width  * 0.27),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: width??size.width * 0.033,
          color: color?? Colors.black,
          fontWeight: FontWeight.normal,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _crearBadge(){
    return Container(
      width: size.width * 0.102,
      child: Center(
        child: Badge(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.003,
            horizontal: size.width * 0.015
          ),
          shape: BadgeShape.square,
          badgeColor: Colors.grey,
          borderRadius: size.width * 0.012,
          badgeContent: Row(
            children: [
              Text(
                '${producto.calificacion}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.027
                ),
              ),
              Icon(
                Icons.star,
                size: size.width * 0.029,
                color: Colors.orange[300],
              )
            ],
          ),
        ),
      ),
    );
  }
}