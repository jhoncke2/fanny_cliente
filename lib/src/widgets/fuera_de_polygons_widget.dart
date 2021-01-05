import 'package:fanny_cliente/src/utils/size_utils.dart';
import 'package:fanny_cliente/src/widgets/header/header_widget.dart';
import 'package:fanny_cliente/src/widgets/maps/map_with_polygons_information_widget.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class FueraDePolygonsWidget extends StatelessWidget {

  final String _textoPrincipal = 'Tu dirección se encuentra fuera del alcance de distrubución de nuestra tienda. Si quieres recibir nuestros productos, por favor utiliza una dirección que esté dentro de alguna de las áreas rojas en el mapa ';

  BuildContext _context;
  SizeUtils _sizeUtils;

  @override
  Widget build(BuildContext appContext) {
    _initInitialConfiguration(appContext);
    return Scaffold(
      body: Container(      
        child: Column(
          children: [
            _crearHeader(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _crearTextoPrincipal(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            MapWithPolygonsInformationWidget()
          ],
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    if(_sizeUtils.xasisSobreYasis == null){
      final Size screenSize = MediaQuery.of(_context).size;
      _sizeUtils.initUtil(screenSize);
    }
  }

  Widget _crearHeader(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.0475),
      child: SafeArea(             
        child: HeaderWidget()
      ),
    );
  }

  Widget _crearTextoPrincipal(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.03),
      child: Text(
        _textoPrincipal,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: _sizeUtils.littleTitleSize,
          color: Colors.black87
        ),
      ),
    );
  }
  
}