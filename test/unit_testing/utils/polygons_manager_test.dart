import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fanny_cliente/src/utils/polygons_manager.dart' as pM;

final String _testGroupDescription = 'Se probará primero el método de sacar la lista de coordenadas X y Y de un polygon, y luego el método que nos indica si un punto se encuentra dentro de un polígono';
final String _getCoordenadasXAndYDePuntosDePolygonDescription = 'Se probará el método que convierte un polygon en una lista de coordenadas X y Y';
final String _thereIsOddNumberOfCornersDescription = 'Se probará el método que indica si un punto dado está dentro del polygon.';
final String _hallarSiPuntoEstaDentroDePolygonsDescription = 'Se probará el método que recorre todos los polygons para hallar si el punto testeado está dentro de alguno de ellos.';

final Polygon _polygonCuadrado = Polygon(
  polygonId: PolygonId('1'),
  points: [
    LatLng(4, -74),
    LatLng(4.35, -74),
    LatLng(4.35, -73),
    LatLng(4, -73)
  ]
);

final Polygon _polygonTriangular = Polygon(
  polygonId: PolygonId('2'),
  points: [
    LatLng(3, -70),
    LatLng(3, -70.5),
    LatLng(3.5, -70.25)
  ]
);

final Polygon _polygonIrregular1 = Polygon(
  polygonId: PolygonId('3'),
  points: [
    LatLng(3, -67),
    LatLng(3.2, -67),
    LatLng(3.28, -66.5),
    LatLng(3.2, -66.58),
    LatLng(3.16, -66.25),
    LatLng(3.08, -66.25),
    LatLng(3, -66.58),
    LatLng(3.08, -66.58)
  ]
);

//Estos son puntos revisados manualmente en googlemaps
final LatLng _innerPolygonCuadradoPoint1 = LatLng(4.00001, -73.5);
final LatLng _outerPolygonCuadradoPoint1 = LatLng(3.99999, -73.5);
final LatLng _innerPolygonTriangularPoint1 = LatLng(3.25, -70.32);
final LatLng _outerPolygonTriangularPoint1 = LatLng(3.25, -70.43);
final LatLng _innerIrregularPolygonPoint1 = LatLng(3.1, -66.8);
final LatLng _outerIrregularPolygonPoint1 = LatLng(3.29988, -66.52);
final LatLng _innerIrregularPolygonPoint2 = LatLng(3.19989, -66.5798);
final LatLng _outerIrregularPolygonPoint2 = LatLng(3.19998, -66.5798);

Map<String, Map<String, List<double>>> _xAndYPolygonsCoordinates = {};

void main(){
  group(_testGroupDescription, (){
    _testGetCoordenadasXAndYDePuntosDePolygon();
    _testThereIsOddNumberOfCorners();
    _testHallarSiPuntoEstaDentroDePolygons();
  });
}
  

void _testGetCoordenadasXAndYDePuntosDePolygon(){
  test(_getCoordenadasXAndYDePuntosDePolygonDescription, (){
    try{
      _executeGetCoordenadasXAndYDePuntosDePolygonValidations();
    }catch(err){
      fail('No debería haber ocurrido un error: $err');
    }
  });
}

void _executeGetCoordenadasXAndYDePuntosDePolygonValidations(){
  Map<String, List<double>> xAndYCoordinates;
  xAndYCoordinates = pM.getCoordenadasXAndYDePuntosDePolygon(_polygonCuadrado);
  _verificarCurrentXAndYCoordinates(xAndYCoordinates, _polygonCuadrado);
  _xAndYPolygonsCoordinates['cuadrado_coordenadas'] = xAndYCoordinates;
  xAndYCoordinates = pM.getCoordenadasXAndYDePuntosDePolygon(_polygonTriangular);
  _verificarCurrentXAndYCoordinates(xAndYCoordinates, _polygonTriangular);
  _xAndYPolygonsCoordinates['triangulo_coordenadas'] = xAndYCoordinates;
  xAndYCoordinates = pM.getCoordenadasXAndYDePuntosDePolygon(_polygonIrregular1);
  _verificarCurrentXAndYCoordinates(xAndYCoordinates, _polygonIrregular1);
  _xAndYPolygonsCoordinates['irregular_coordenadas'] = xAndYCoordinates;
}

void _verificarCurrentXAndYCoordinates(Map<String, List<double>> xAndYCoordinates, Polygon currentTestedPolygon){
  expect(xAndYCoordinates, isNotNull);
  final List<double> xCoordinates = xAndYCoordinates['X'];
  expect(xCoordinates, isNotNull);
  expect(xCoordinates.length, currentTestedPolygon.points.length);
  final List<double> yCoordinates = xAndYCoordinates['Y'];
  expect(yCoordinates, isNotNull);
  final int currentTestedPolygonPointsLength = currentTestedPolygon.points.length;
  expect(yCoordinates.length, currentTestedPolygonPointsLength);
}


void _testThereIsOddNumberOfCorners(){
  test(_thereIsOddNumberOfCornersDescription, (){
    try{
      _executeThereIsOddNumberOfCornersValidation();
    }catch(err){
      fail('No debería haber ocurrido un error: $err');
    }
  });
}

void _executeThereIsOddNumberOfCornersValidation(){
  bool isInnerPoint;
  Map<String, List<double>> currentXAndYCoordinates;
  int currentPointsLength;

  currentPointsLength = _polygonCuadrado.points.length;
  currentXAndYCoordinates = _xAndYPolygonsCoordinates['cuadrado_coordenadas'];
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _innerPolygonCuadradoPoint1);
  expect(isInnerPoint, true);
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _outerPolygonCuadradoPoint1);
  expect(isInnerPoint, false);

  currentPointsLength = _polygonTriangular.points.length;  
  currentXAndYCoordinates = _xAndYPolygonsCoordinates['triangulo_coordenadas'];  
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _innerPolygonTriangularPoint1);
  expect(isInnerPoint, true);
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _outerPolygonTriangularPoint1);
  expect(isInnerPoint, false);

  currentPointsLength = _polygonIrregular1.points.length;
  currentXAndYCoordinates = _xAndYPolygonsCoordinates['irregular_coordenadas'];  
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _innerIrregularPolygonPoint1);
  expect(isInnerPoint, true);
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _outerIrregularPolygonPoint1);
  expect(isInnerPoint, false);
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _innerIrregularPolygonPoint2);
  expect(isInnerPoint, true);
  isInnerPoint = pM.thereIsOddNumberOfCorners(currentPointsLength, currentXAndYCoordinates, _outerIrregularPolygonPoint2);
  expect(isInnerPoint, false); 
}

void _testHallarSiPuntoEstaDentroDePolygons(){
  test(_hallarSiPuntoEstaDentroDePolygonsDescription, (){
    try{
      _executeHallarSiPuntoEstaDentroDePolygonsValidations();
    }catch(err){
      fail('No debería haber ocurrido un error: $err');
    }
  });
}

void _executeHallarSiPuntoEstaDentroDePolygonsValidations(){
  final List<Polygon> polygons = [
    _polygonCuadrado,
    _polygonTriangular,
    _polygonIrregular1
  ];
  bool estaEnAlgunPolygon;

  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _innerPolygonCuadradoPoint1);
  expect(estaEnAlgunPolygon, true);
  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _outerPolygonCuadradoPoint1);
  expect(estaEnAlgunPolygon, false);
  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _innerPolygonTriangularPoint1);
  expect(estaEnAlgunPolygon, true);
  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _outerPolygonTriangularPoint1);
  expect(estaEnAlgunPolygon, false);
  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _innerIrregularPolygonPoint1);
  expect(estaEnAlgunPolygon, true);
  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _outerIrregularPolygonPoint1);
  expect(estaEnAlgunPolygon, false);
  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _innerIrregularPolygonPoint2);
  expect(estaEnAlgunPolygon, true);
  estaEnAlgunPolygon = pM.hallarSiPuntoEstaDentroDePolygons(polygons, _outerIrregularPolygonPoint2);
  expect(estaEnAlgunPolygon, false);
}
