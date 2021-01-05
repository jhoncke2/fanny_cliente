import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fanny_cliente/src/models/usuarios_model.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState());
  @protected
  UserState currentYieldedState;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    // TODO: implement mapEventToState
    switch(event.runtimeType){
      case SetAuthorizationToken:
        _setAuthorizationToken(event as SetAuthorizationToken);
        yield currentYieldedState;
      break;
      case SetUserInformation:
        _setUserInformation(event as SetUserInformation);
        yield currentYieldedState;
      break;
      case Logout:
        _logout();
        yield currentYieldedState;
      break;
    }
  }

  void _setAuthorizationToken(SetAuthorizationToken event){
    currentYieldedState = state.copyWith(authorizationToken: event.authorizationToken);
  }

  void _setUserInformation(SetUserInformation event){
    currentYieldedState = state.copyWith(userInformation: event.user);
  }

  void _logout(){
    currentYieldedState = state.reset();
  }
}
