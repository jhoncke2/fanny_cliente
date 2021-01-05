import 'package:fanny_cliente/src/widgets/productos/productos_widget.dart';
import 'package:flutter/material.dart';

class CarritoPage extends StatefulWidget {
  static final route = 'carrito';
  double valor = 318000.0;

  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Carrito Page'),),
      ),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.1,
            ),
            Container(
              margin: EdgeInsets.only(left: size.width * 0.1),
              height: size.height * 0.3,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                //color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage('assets/placeholder_images/carrito_icono.png'),
                )
              ),
            ),
            SizedBox(
              height: size.height * 0.08,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 0.25,
                    spreadRadius: 2.5,
                    offset: Offset(
                      2.0,
                      1.5
                    )
                  )
                ]
              ),
              child: ProductosWidget(
                scrollable: false,
                widthPercent: 0.75,
                horizontalMarginPercent: 0.0,
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Center(
              child: Text(
                '\$${widget.valor}',
                style: TextStyle(
                  fontSize: size.width * 0.075
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.2, vertical: size.height * 0.015),
                color: Colors.deepOrangeAccent,
                child: Text(
                  'Pagar',
                  style: TextStyle(
                    fontSize: size.width * 0.085,
                    color: Colors.white60,
                  ),
                ),
                onPressed: (){

                },
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}