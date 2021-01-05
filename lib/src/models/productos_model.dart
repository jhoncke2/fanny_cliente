import 'dart:core';
import 'package:fanny_cliente/src/models/comentarios_model.dart';
import 'package:fanny_cliente/src/models/horarios_model.dart';
import 'package:fanny_cliente/src/models/tiendas_model.dart';

class ProductosModel{
  List<ProductoModel> productos = new List();
  ProductosModel.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    jsonList.forEach((actual){
      final productoActual = ProductoModel.fromJsonMap(actual);
      productos.add(productoActual);
    });
  }

}

class ProductoModel{
  int id;
  bool activo;
  String name;
  int precio;
  String tipo;
  String description;
  String owner;
  int tiempoDeEntrega;
  double calificacion;
  int tiendaId;
  List<ComentarioModel> comentarios;

  TiendaModel store;
  Map<String, dynamic> category;
  HorarioModel horario;
  List<Map<String, dynamic>> photos;

  //por desechar
  String imagenUrl;
  String categoria;

  //por agregar
  int stock;
  Map<String, dynamic> programado; 

  ProductoModel({
    this.id,
    this.activo,
    this.name,
    this.precio,
    this.tipo,
    this.description,
    this.owner,
    this.calificacion,
    this.tiempoDeEntrega,
    this.tiendaId,

    this.store,
    this.category,
    this.horario,
    this.photos,

    this.imagenUrl,
    this.categoria,
  });

  ProductoModel.fromJsonFrontTest(Map<String, dynamic> json){
    name = json['name'];
    description = json['description'];
    precio = json['precio'];
    tipo = json['tipo'];
    if(json['tiempo_de_entrega'] != null)
      tiempoDeEntrega = int.parse( json['tiempo_de_entrega'] );
    List<Map<String, dynamic>> photosMap = (json['photos'] as List).cast<Map<String, dynamic>>().toList();
    photos = [];
    photosMap.forEach((Map<String, dynamic> photo){
      photos.add(
        {
          'id':photo['id'],
          'producto_id':photo['producto_id'],
          'url': photo['url']
        }
      );
    });
  }

  ProductoModel.fromForFrontJsonMap(Map<String, dynamic> json){
    name = json['name'];
    description = json['description'];
    precio = json['precio'];
    tipo = json['tipo'];
    if(json['tiempo_de_entrega'] != null)
      tiempoDeEntrega = int.parse( json['tiempo_de_entrega'] );
    List<Map<String, dynamic>> photosMap = (json['photos'] as List).cast<Map<String, dynamic>>().toList();
    photos = [];
    photosMap.forEach((Map<String, dynamic> photo){
      photos.add(
        {
          'id':photo['id'],
          'producto_id':photo['producto_id'],
          'url':_formatPhotoUrl( photo['url'] )
        }
      );
    });
  }

  ProductoModel.fromJsonMap(Map<String, dynamic> json){
    id              = json['id'];
    activo          = (json['activo'] == 1)? true : false;
    name            = json['name'];
    
    tipo            = json['tipo'];
    description     = json['description'];
    owner           = json['owner'];
    category        = json['category'];
    _formatCalification(json['calificacion'], json['num_calificacion'] );

    if(json['precio'] != null)
      precio = json['precio'];
    if(json['tiempo_de_entrega'] != null)
      tiempoDeEntrega = int.parse(json['tiempo_de_entrega']);
    if(json['tienda_id'] != null)
      tiendaId = json['tienda_id'];
    if(json['store']!= null)
      store = TiendaModel.fromJsonMap(json['store']);
    if(json['horario'] != null)
      horario = json['horario'];
    if(json['programado'] != null)
      programado =  json['programado'].cast<String, dynamic>() ;
    //para evitar problema de compatibilidad entre List<dynamic>(lista vacia) y List<Map<String, dynamic>>
    photos = [];
    List<Map<String, dynamic>> photosMap = (json['photos'] as List).cast<Map<String, dynamic>>().toList();
    
    photosMap.forEach((Map<String, dynamic> photo){
      photos.add(
        {
          'id':photo['id'],
          'producto_id':photo['producto_id'],
          'url':_formatPhotoUrl( photo['url'] )
        }
      );
    });

    comentarios = (ComentariosModel.fromJsonList(json['califications']) ).comentarios;
    print(comentarios);
  }

  Map<String, dynamic> toForBackJson(){
    Map<String, dynamic> json = {};
    json['name'] = name;
    json['description'] = description;
    json['precio'] = precio;
    json['tipo'] = tipo;
    if(tiempoDeEntrega != null)
      json['tiempo_de_entrega'] = tiempoDeEntrega.toString();
    return json;
  }

  Map<String, dynamic> toForFrontJson(){
    Map<String, dynamic> json = {};
    json['name'] = name;
    json['description'] = description;
    json['precio'] = precio;
    json['tipo'] = tipo;
    if(tiempoDeEntrega != null)
      json['tiempo_de_entrega'] = tiempoDeEntrega.toString();
    json['activo'] = activo;
    json['owner'] = owner;
    json['category'] = category;
    json['photos'] = photos;
    return json;
  }

  String _formatPhotoUrl(String photoUrl){
    String url = 'https://codecloud.xyz$photoUrl';
    return url;
  }

  bool get listoParaCrear{
    return (name != null && description != null && tipo != null && ( tipo == 'programado' || precio != null ));
  }

  void _formatCalification(var indefinedTypeCalification, int numCalifications){
    if(numCalifications > 0){
      double doubleCalification;
      String doubleCalificationString = (indefinedTypeCalification / numCalifications).toString();
      List<String> doubCalifStringParts = doubleCalificationString.split('.');
      doubleCalification = double.parse('${doubCalifStringParts[0]}.${doubCalifStringParts[1][0]}');
      calificacion = doubleCalification;
    }
      
  }
}