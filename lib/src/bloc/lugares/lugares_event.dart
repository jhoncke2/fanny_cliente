part of 'lugares_bloc.dart';

@immutable
abstract class LugaresEvent {}

class SetLugares extends LugaresEvent{
  final List<LugarModel> lugares;
  SetLugares({
    @required this.lugares,
  });
}

class ResetLugares extends LugaresEvent{
  ResetLugares();
}
