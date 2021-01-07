import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:meta/meta.dart';

part 'lugares_event.dart';
part 'lugares_state.dart';

class LugaresBloc extends Bloc<LugaresEvent, LugaresState> {
  @protected
  LugaresState currentYieldedState;

  LugaresBloc() : super(LugaresState());

  @override
  Stream<LugaresState> mapEventToState(
    LugaresEvent event,
  ) async* {
    switch(event.runtimeType){
      case SetLugares:
        _setLugares(event as SetLugares);
      break;
      case ResetLugares:
        _resetLugares();   
      break;
    }
    yield currentYieldedState;
  }

  void _setLugares(SetLugares event){
    final List<LugarModel> lugares = event.lugares;
    LugarModel elegido;
    for(int i = 0; i < lugares.length; i++){
      final LugarModel lugar = lugares[i];
      if(lugar.elegido){
        elegido = lugar;
        break;
      }
    }
    currentYieldedState = state.copyWith(lugaresCargados:true, lugares: lugares, elegido: elegido);
  }

  void _resetLugares(){
    currentYieldedState = state.reset();
  }
}