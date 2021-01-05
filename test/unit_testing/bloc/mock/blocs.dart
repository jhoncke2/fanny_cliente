import 'package:fanny_cliente/src/bloc/lugares/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc/user/user_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:mockito/mockito.dart';

class MockUserBloc extends Mock implements UserBloc{
  UserState _mockState;
  MockUserBloc() 
  : super(){
    _mockState = UserState();
  }
  @override
  void add(UserEvent event) {
    // TODO: implement add
    switch(event.runtimeType){
      case SetAuthorizationToken:
        _setAuthorizationToken(event as SetAuthorizationToken);
      break;
      case SetUserInformation:
        _setUserInformation(event as SetUserInformation);
      break;
      case Logout:
        _logout();
      break;
    }
  }

  @override
  void _setAuthorizationToken(SetAuthorizationToken event){
    this._mockState = this._mockState.copyWith(authorizationToken: event.authorizationToken);
  }

  @override
  void _setUserInformation(SetUserInformation event){
    this._mockState = this._mockState.copyWith(userInformation: event.user);
  }

  @override
  void _logout(){
    this._mockState = this._mockState.reset();
  }

  @override
  UserState get state => this._mockState;
}

class MockLugaresBloc extends Mock implements LugaresBloc{
  LugaresState _mockState;
  MockLugaresBloc() 
  : super(){
    _mockState = LugaresState();
  }
  @override
  void add(LugaresEvent event) {
    switch(event.runtimeType){
      case SetLugares:
        _setLugares(event as SetLugares);
      break;
      case ResetLugares:
        _resetLugares();
      break;
    }
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
    _mockState = _mockState.copyWith(lugaresCargados:true, lugares: lugares, elegido: elegido);
  }

  void _resetLugares(){
    _mockState = _mockState.reset();
  }

  @override
  LugaresState get state => this._mockState;
}