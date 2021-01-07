class CategoriasModel {
  List<CategoriaModel> categories = new List();
   
  CategoriasModel.fromJsonList(List<dynamic> jsonList){
    if(jsonList==null)
      return;
    jsonList.forEach((element) {
      final currentCategory = CategoriaModel.fromJsonMap(element);
      categories.add(currentCategory);
    });
  }

  List<CategoriaModel> getLugares(){
    return categories;
  }
}

class CategoriaModel{
  int id;
  String name;
  int icon;  

  CategoriaModel({
    this.id,   
    this.name,
    this.icon
  });

  CategoriaModel.fromJsonMap(Map<String, dynamic> jsonObject){
    //el .toString() es porque no sé si viene en formato double o String, creo que difiere dependiendo del tipo de petición
    id  = int.parse(jsonObject['id'].toString());
    name = jsonObject['name'];
    icon = int.parse(jsonObject['icon'].toString());
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> jsonObject = {};
    if(id != null)
      jsonObject['id'] = '${this.id}';
    jsonObject['name'] = this.name;
    jsonObject['icon'] = this.icon;
    return jsonObject;
  }
}
