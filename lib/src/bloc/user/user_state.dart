part of 'user_bloc.dart';

@immutable
class UserState {
  final UsuarioModel userInformation;
  final String authorizationToken;
  final String mobileToken;
  UserState({
    UsuarioModel userInformation,
    String authorizationToken,
    String mobileToken
  })
  : this.userInformation = userInformation??null,
    this.authorizationToken = authorizationToken??null,
    this.mobileToken = mobileToken??null
  ;

  UserState reset() => UserState();

  UserState copyWith({
    UsuarioModel userInformation,
    String authorizationToken,
    String mobileToken
  }) => UserState(
    userInformation: userInformation??null,
    authorizationToken: authorizationToken??null,
    mobileToken: mobileToken??null
  );
}
