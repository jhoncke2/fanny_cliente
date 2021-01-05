class ComentariosModel {
  List<ComentarioModel> _comentarios = new List();
   
  ComentariosModel.fromJsonList(List<dynamic> jsonList){
    if(jsonList==null)
      return;
    jsonList.forEach((element) {
      final domiciliarioActual = ComentarioModel.fromJsonMap(element);
      _comentarios.add(domiciliarioActual);
    });
  }

  List<ComentarioModel> get comentarios{
    return _comentarios;
  }

}

class ComentarioModel{
  int id;
  double calificacion;
  String descripcion;
  Map<String, dynamic> cliente;
  String date;

  ComentarioModel({
    this.id,  
    this.calificacion,
    this.descripcion,
    this.cliente,
    this.date
  });

  ComentarioModel.fromJsonMap(Map<String, dynamic> jsonObject){
    id = jsonObject['id'];
    calificacion = double.parse( jsonObject['calification'].toString() );
    descripcion = jsonObject['comment'];
    cliente = jsonObject['owner'];
    cliente['avatar'] = _formatPhotoUrl(cliente['avatar']);
    date = jsonObject['date'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> jsonObject = {};
    //jsonObject['nombre'] = nombre;
    //jsonObject['email'] = email;
    jsonObject['cliente'] = cliente;
    jsonObject['calification'] = calificacion;
    jsonObject['comment'] = descripcion;
    return jsonObject;
  }

  String _formatPhotoUrl(String photoUrl){
    String url = (photoUrl != null)? 'https://codecloud.xyz$photoUrl' : null;
    return url;
  }
}
