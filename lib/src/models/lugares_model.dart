import 'package:google_maps_flutter/google_maps_flutter.dart';

class LugaresModel {
  List<LugarModel> lugares = new List();
   
  LugaresModel.fromJsonList(List<dynamic> jsonList){
    if(jsonList==null)
      return;
    jsonList.forEach((element) {
      final lugarActual = LugarModel.fromJsonMap(element);
      lugares.add(lugarActual);
    });
  }

  List<LugarModel> getLugares(){
    return lugares;
  }
}

class LugarModel{
  int id;
  double latitud;
  double longitud;
  String direccion;
  String pais;
  String ciudad;
  String observaciones;
  String tipo;
  int rango;
  bool elegido;
  

  LugarModel({
    this.id,   
    this.latitud,
    this.longitud,
    this.direccion,
    this.pais,
    this.ciudad,
    this.observaciones,
    this.tipo,
    this.rango,
    this.elegido,
    
  });

  LugarModel.fromJsonMap(Map<String, dynamic> jsonObject){
    //el .toString() es porque no sé si viene en formato double o String, creo que difiere dependiendo del tipo de petición
    id                            = int.parse(jsonObject['id'].toString());
    latitud                       = double.parse( jsonObject['latitud'].toString() );
    longitud                      = double.parse( jsonObject['longitud'].toString() );
    direccion                     = jsonObject['direccion'];
    pais                          = jsonObject['pais'];
    ciudad                        = jsonObject['ciudad'];
    observaciones                 = jsonObject['observaciones'];
    tipo                          = jsonObject['tipo'];
    rango                         = int.parse((jsonObject['rango']??'0').toString());
    elegido                       = (jsonObject['elegido'] == 1 )? true : false ;
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> jsonObject = {};
    if(id != null)
      jsonObject['id'] = '$id';
    jsonObject['latitud'] = '$latitud';
    jsonObject['longitud'] = '$longitud';
    jsonObject['direccion'] = direccion;
    if(pais!=null)
      jsonObject['pais'] = pais;
    jsonObject['ciudad'] = ciudad;
    jsonObject['observaciones'] = observaciones;
    jsonObject['tipo'] = tipo;
    if(rango!=null)
      jsonObject['rango'] = '$rango';
    if(elegido != null)
      jsonObject['elegido'] = '$elegido';
    return jsonObject;
  }

  LatLng get latLng{
    return LatLng(latitud, longitud);
  }

  @override
  String toString(){
    String respuesta = '';
    respuesta += '{id:$id\ndireccion:$direccion\nlatitud:$latitud\nlongitud:$longitud\nelegido:$elegido\n';
    respuesta += '}';
    
    return respuesta;
  }
}
