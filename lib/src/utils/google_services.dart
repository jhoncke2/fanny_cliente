import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';

final GoogleMapsGeocoding _geocoding = new GoogleMapsGeocoding(apiKey: 'AIzaSyDg08rC6Ek2BrH69UsVTfUSYLSBusfGQ-Q');

Future<LatLng> getUbicacionFromDireccionString(String direccion)async{
  final GeocodingResponse response = await _geocoding.searchByAddress(direccion);
  //Se escoge el primer elemento de una lista de posibles respuestas, entre las cuales no sabemos cuál sea la mejor
  final GeocodingResult choosedResult = response.results[0];
  final Location location = choosedResult.geometry.location;
  final LatLng position = LatLng(location.lat, location.lng);
  return position;
}

