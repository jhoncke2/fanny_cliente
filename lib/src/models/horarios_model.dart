
class HorariosModel {
  List<HorarioModel> lugares = new List();

  /* ***********************************************
   *    Pruebas
   *********************************************** */

   /* ***********************************************
   *    fin datos prueba
   *********************************************** */
   
  HorariosModel.fromJsonList(List<dynamic> jsonList){
    if(jsonList==null)
      return;
    jsonList.forEach((element) {
      final lugarActual = HorarioModel.fromJsonMap(element);
      lugares.add(lugarActual);
    });
  }

  List<HorarioModel> getLugares(){
    return lugares;
  }

}

class HorarioModel{
  int id;
  String lunesInicio;
  String lunesFinal;
  String martesInicio;
  String martesFinal;
  String miercolesInicio;
  String miercolesFinal;
  String juevesInicio;
  String juevesFinal;
  String viernesInicio;
  String viernesFinal;
  String sabadoInicio;
  String sabadoFinal;
  String domingoInicio;
  String domingoFinal;
  String festivosInicio;
  String festivosFinal;

  HorarioModel({
    this.id,
    this.lunesInicio,
    this.lunesFinal,
    this.martesInicio,
    this.martesFinal,
    this.miercolesInicio,
    this.miercolesFinal,
    this.juevesInicio,
    this.juevesFinal,
    this.viernesInicio,
    this.viernesFinal,
    this.sabadoInicio,
    this.sabadoFinal,
    this.domingoInicio,
    this.domingoFinal,
    this.festivosInicio,
    this.festivosFinal
  });

  HorarioModel.fromJsonMap(Map<String, dynamic> jsonObject){
    id = jsonObject['id'];
    lunesInicio = jsonObject['lunes_inicio'];
    lunesFinal = jsonObject['lunes_final'];
    martesInicio = jsonObject['martes_inicio'];
    martesFinal = jsonObject['martes_final'];
    miercolesInicio = jsonObject['miercoles_inicio'];
    miercolesFinal = jsonObject['miercoles_final'];
    juevesInicio = jsonObject['jueves_inicio'];
    juevesFinal = jsonObject['jueves_final'];
    viernesInicio = jsonObject['viernes_inicio'];
    viernesFinal = jsonObject['viernes_final'];
    sabadoInicio = jsonObject['sabado_inicio'];
    sabadoFinal = jsonObject['sabado_final'];
    domingoInicio = jsonObject['domingo_inicio'];
    domingoFinal = jsonObject['domingo_final'];
    festivosInicio = jsonObject['festivos_inicio'];
    festivosFinal = jsonObject['festivos_final'];
  } 

  Map<String, dynamic> toJson(){
    Map<String, dynamic> jsonObject = {};
    if(id != null)
      jsonObject['id'] = '$id';
    if(lunesInicio != null)
      jsonObject['lunes_inicio']      = lunesInicio;
    if(lunesFinal != null)
      jsonObject['lunes_final']       = lunesFinal;
    if(martesInicio != null)
      jsonObject['martes_inicio']     = martesInicio;
    if(martesFinal != null)
      jsonObject['martes_final']      = martesFinal;
    if(miercolesInicio != null)
      jsonObject['miercoles_inicio']  = miercolesInicio;
    if(miercolesFinal != null)
      jsonObject['miercoles_final']   = miercolesFinal;
    if(juevesInicio != null)
      jsonObject['jueves_inicio']     = juevesInicio;
    if(juevesFinal != null)
      jsonObject['jueves_final']      = juevesFinal;
    if(viernesInicio != null)
      jsonObject['viernes_inicio']    = viernesInicio;
    if(viernesFinal != null)
      jsonObject['viernes_final']     = viernesFinal;
    if(sabadoInicio != null)
      jsonObject['sabado_inicio']     = sabadoInicio;
    if(sabadoFinal != null)
      jsonObject['sabado_final']      = sabadoFinal;
    if(domingoInicio != null)
      jsonObject['domingo_inicio']    = domingoInicio;
    if(domingoFinal != null)
      jsonObject['domingo_final']     = domingoFinal;
    if(festivosInicio != null)
      jsonObject['festivos_inicio']   = festivosInicio;
    if(festivosFinal != null)
      jsonObject['festivos_final']    = festivosFinal;
    return jsonObject;
  }

}
