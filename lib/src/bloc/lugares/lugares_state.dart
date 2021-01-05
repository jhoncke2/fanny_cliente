part of 'lugares_bloc.dart';

@immutable
class LugaresState {
  final bool lugaresCargados;
  final List<LugarModel> lugares;
  final LugarModel elegido;

  LugaresState({
    bool lugaresCargados,
    List<LugarModel> lugares,
    LugarModel elegido
  }):
    this.lugaresCargados = lugaresCargados?? false,
    this.lugares = lugares?? null,
    this.elegido = elegido?? null
  ;

  LugaresState copyWith({
    bool lugaresCargados,
    List<LugarModel> lugares,
    LugarModel elegido
  }) => LugaresState(
    lugaresCargados: lugaresCargados ?? this.lugaresCargados,
    lugares: lugares ?? this.lugares,
    elegido: elegido ?? this.elegido
  );

  LugaresState reset() => LugaresState();
}

