import 'package:flutter/material.dart';
class SplashScreenPage extends StatefulWidget {
  static final route = 'splash_screen';
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: _crearAnimacion(size)
      )
    );

  }

  Widget _crearAnimacion(Size size){
    return Container(
      child: Image.asset(
        'assets/splash_screen/splash_screen.gif'
      ),
    );
  }
}