import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';

final _equivalenciasComponentes = {
  'pais':'country',
  'departamento':'administrative_area',
  'ciudad':'locality',
  'via_principal':'route',
  //'via_secundaria':'route',
  'numero_casa':'route'
};

final _geoCoding = new GoogleMapsGeocoding(apiKey: 'AIzaSyDg08rC6Ek2BrH69UsVTfUSYLSBusfGQ-Q');

Future<LatLng> getUbicacionConComponentesDireccion(List<Map<String, dynamic>> componentes)async{
  //final _geoCoding = new GoogleMapsGeocoding(apiKey: 'AIzaSyDg08rC6Ek2BrH69UsVTfUSYLSBusfGQ-Q');
  List<Component> googleComponents = _fromMapToComponent(componentes);
  GeocodingResponse response = await _geoCoding.searchByComponents(_fromMapToComponent(componentes));
  List<GeocodingResult> results = response.results;
  if(results != null && results.length > 0){
    return LatLng(
      results[0].geometry.location.lat,
      results[0].geometry.location.lng
    );
  }
  return null;
}

List<Component> _fromMapToComponent(List<Map<String,dynamic>> mapComponents){
  List<Component> componentes = [];
  String streetNumber = '#';
  mapComponents.forEach((element) {
    String nombre = element['nombre'];
    String valor = element['valor'];
    Component componente;
    if( !(['via_secundaria', 'numero_casa'].contains(nombre)) ){
      componente = Component(
        _equivalenciasComponentes[nombre],
        valor
      );
      componentes.add(componente);
    }else if(nombre == 'via_secundaria'){
      streetNumber += '$valor - ';
    }else if(nombre == 'numero_casa'){
      streetNumber += valor;
      componente = Component(
        _equivalenciasComponentes[nombre],
        streetNumber
      );
      componentes.add(componente);
    }
    
  });
  return componentes;
}

Future<String> getDireccionByLatLng(LatLng latLng)async{
  Location location = Location(latLng.latitude, latLng.longitude);
  GeocodingResponse response = await _geoCoding.searchByLocation(location);
  List<GeocodingResult> results = response.results;
  if(results != null && results.length > 0){
    String direccion = results[0].formattedAddress;
    return direccion;
  }
  return null;
}

