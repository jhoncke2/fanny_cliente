import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool hallarSiPuntoEstaDentroDePolygons(List<Polygon> polygons, LatLng point){
  for(int i = 0; i < polygons.length; i++){
    final Polygon polygon = polygons[i];
    final int pointsLength = polygon.points.length;
    final Map<String, List<double>> xAndYCoordinatesOfPolygon = getCoordenadasXAndYDePuntosDePolygon(polygon);
    final bool puntoEstaDentroDePolygon = thereIsOddNumberOfCorners(pointsLength, xAndYCoordinatesOfPolygon, point);
    if(puntoEstaDentroDePolygon){
      return true;
    }
  }
  return false;
}

@protected
Map<String, List<double>> getCoordenadasXAndYDePuntosDePolygon(Polygon polygon){
    Map<String, List<double>> coordenadas;
    final List<double> xCoordinates = [];
    final List<double> yCoordinates = [];
    polygon.points.forEach((LatLng point) {
      xCoordinates.add(point.latitude);
      yCoordinates.add(point.longitude);
    });
    coordenadas = {
      'X':xCoordinates,
      'Y':yCoordinates
    };
    return coordenadas;
  }


/**
   * basado en el algoritmo de trazar una línea horizontal en la coordenada y del punto a testear y contar 
   * los lados del polígono que se cruzan con esa línea. Si a la izquierda del punto se cruza una cantidad impar de lados,
   * y a la derecha también, el punto está dentro del polígono.
   * @params:
   *  nCorners: número de puntos(esquinas) del polígono
   *  polyX: coordenadas x de las esquinas del polígono
   *  polyY: coordenadas y de las esquinas del polígono
   *  x, y: coordenadas x and y del punto a testear
   * 
   * obtained from Darel Rex Finley on http://alienryderflex.com/polygon/?fbclid=IwAR00rOmDPStQch8YIpIaplKqXwVuzcrYiLJFggwO9Ekg6n0xcKo-ivCCkic
   */
  @protected
  bool thereIsOddNumberOfCorners(int nCorners, Map<String, List<double>> xAndYCoordinatesOfPolygon, LatLng testedPoint) {
    int j = nCorners-1 ;
    final List<double> polyX = xAndYCoordinatesOfPolygon['X'];
    final List<double> polyY = xAndYCoordinatesOfPolygon['Y'];
    final double x = testedPoint.latitude;
    final double y = testedPoint.longitude;
    bool  oddNodes = false;

    for (int i=0; i<nCorners; i++) {
      double x_i = polyX[i];
      double y_i = polyY[i];
      double x_j = polyX[j];
      double y_j = polyY[j];
      if (y_i<y && y_j>=y
      ||  y_j<y && y_i>=y
      &&  (x_i<=x || x_j<=x)) {
        if (x_i+(y-y_i)/(y_j-y_i)*(x_j-x_i)<x) {
          oddNodes=!oddNodes; 
        }}
      j=i; 
    }

    return oddNodes;
  }