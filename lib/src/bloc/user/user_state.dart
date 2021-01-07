part of 'user_bloc.dart';

@immutable
class UserState {
  final String authorizationToken;
  final UsuarioModel userInformation;
  final String mobileToken;
  UserState({
    String authorizationToken,
    UsuarioModel userInformation,
    String mobileToken
  })
  : this.authorizationToken = authorizationToken??null,
    this.userInformation = userInformation??null,
    this.mobileToken = mobileToken??null
  ;

  UserState copyWith({
    String authorizationToken,
    UsuarioModel userInformation,
    String mobileToken
  }) => UserState(
    authorizationToken: authorizationToken??this.authorizationToken,
    userInformation: userInformation??this.userInformation,
    mobileToken: mobileToken??this.mobileToken
  );

  UserState reset() => UserState();
}
