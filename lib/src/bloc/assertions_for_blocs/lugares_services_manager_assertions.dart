import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';

class LugaresServicesManagerAssertions{

  final LugaresBloc _lugaresBloc;

  LugaresServicesManagerAssertions({
    LugaresBloc lugaresBloc
  }):
    _lugaresBloc = lugaresBloc
  ;

  void assertsCreateLugar(Map<String, dynamic> serviceResponse){
    final LugarModel recienCreado = LugarModel.fromJsonMap(serviceResponse['direccion']);
    assert(recienCreado != null, 'el lugar del serviceResponse debe existir');
    final LugarModel elegido = _lugaresBloc.state.elegido;
    assert(elegido.id == recienCreado.id, 'La El lugar que aparece como recién creado en el bloc debe tener el id del lugar recién creado');
  }

  void assertsLoadLugares(){
    final List<LugarModel> lugares = _lugaresBloc.state.lugares;
    final LugarModel elegido = _lugaresBloc.state.elegido;
    assert(lugares!=null, 'Los lugares del bloc deben estar recién cargados');
    assert(lugares.length > 0, 'Los lugares no deben estar vacíos');
    assert(elegido != null, 'Debe existir un elegido en el bloc');
  }

  void assertElegirLugar(Map<String, dynamic> serviceResponse, int lugarAElegirId){
    final LugarModel lugarElegido = LugarModel.fromJsonMap(serviceResponse['direccion']);
    assert(lugarElegido != null, 'El lugar del serviceResponse recibido no debería ser null');
    assert(lugarElegido.id == lugarAElegirId, 'El id del lugar del serviceResopnse debería ser igual al id del lugar que se eligió');
  }
}