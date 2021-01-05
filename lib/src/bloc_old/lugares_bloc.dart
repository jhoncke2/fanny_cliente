import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

//importaciones locales
import 'package:fanny_cliente/src/providers/lugares_provider.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';

class LugaresBloc{
  Location _locationController = new Location();

  final _lugaresProvider = new LugaresProvider();
  final _lugaresController = new BehaviorSubject<List<LugarModel>>();
  final _elegidoController = new BehaviorSubject<LugarModel>();
  //final _cargandoController = new BehaviorSubject<bool>();

  Stream<List<LugarModel>> get lugaresStream => _lugaresController.stream;
  Stream<LugarModel> get elegidoStream => _elegidoController.stream;
  //Stream<bool> get cargandoStream => _cargandoController.stream;

  //Stream<Lugar> get lugaresStream => _lugaresController.stream;

  /*
   * Falta implementar el parámetro usuarioId
   */
  Future<Map<String, dynamic>> cargarLugares(String token)async{
    Map<String, dynamic> response = await _lugaresProvider.cargarLugares(token);
    if(response['status'] == 'ok'){
      LugaresModel lugares = LugaresModel.fromJsonList(response['direcciones']);
      if(lugares.getLugares().length == 0){
        return {
          'status':'no_direcciones'
        };
      }
      _lugaresController.sink.add(lugares.getLugares());
      //elegirLugar(lugares.getLugares()[0].id, token);
      LugarModel elegido = lugares.getLugares().singleWhere((element) => element.elegido)?? null;
      _elegidoController.sink.add(elegido);
    }
    return response;
  }

  LugarModel get actualElegido{
    return _elegidoController.value;
  }

  Future<void> editarLugar(LugarModel lugar, String token)async{
    await _lugaresProvider.editarLugar(lugar, token);
  }
  
  Future<LugarModel> elegirLugar(int idLugar, String token)async{
    final Map<String, dynamic> response = await _lugaresProvider.elegirLugar(idLugar, token);
    await cargarLugares(token);
    return LugarModel.fromJsonMap(response['direccion']);
  }

  Future<Map<String, dynamic>> latLong(int idLugar, String token, double latitud, double longitud)async{
    Map<String, dynamic> respuesta = await _lugaresProvider.latLong(idLugar, token, latitud, longitud);
    return respuesta;
  }

  Future<void> eliminarLugar(int idLugar)async{
    _lugaresProvider.eliminarLugar(idLugar);
  }

  Future<Map<String, dynamic>> crearLugar(LugarModel lugar, String token)async{
    Map<String, dynamic> response = await _lugaresProvider.crearLugar(lugar, token);
    if(response['status'] == 'ok'){
      await cargarLugares(token);
      response['content'] = LugarModel.fromJsonMap(response['content']);
    }
    return response;
    
  }

  Future<void> addDireccionInicialActual(LugarModel lugar){
    _lugaresController.sink.add([lugar]);
    _elegidoController.sink.add(lugar);
  }

  /**
   * Falta actualizar ahora con las peticiones
   * 
   */
  Future<void> elegirUbicacionActual(int idLugar, String token)async{
    //elegirLugar(0, token);
    //final lugares = await _lugaresProvider.cargarLugares(token);
    LocationData currentLocation = await _locationController.getLocation();
    //LugarModel lugarActual = lugares.singleWhere((element) => element.nombre == 'Tu ubicación');
    //lugarActual.latitud = currentLocation.latitude;
    //lugarActual.longitud = currentLocation.longitude;
    await latLong(idLugar, token, currentLocation.latitude, currentLocation.longitude);
    await elegirLugar(idLugar, token);
    //cargarLugares(token);
  }

  void dispose(){
    _lugaresController.close();
    _elegidoController.close();
  }
}