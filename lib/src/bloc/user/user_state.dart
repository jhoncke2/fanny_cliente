part of 'user_bloc.dart';

@immutable
class UserState {
  final String authorizationToken;
  final UsuarioModel userInformation;
  UserState({
    String authorizationToken,
    UsuarioModel userInformation,
  })
  : this.authorizationToken = authorizationToken??null,
    this.userInformation = userInformation??null
  ;

  UserState copyWith({
    String authorizationToken,
    UsuarioModel userInformation,
  }) => UserState(
    authorizationToken: authorizationToken??this.authorizationToken,
    userInformation: userInformation??this.userInformation,
  );

  UserState reset() => UserState();
}
