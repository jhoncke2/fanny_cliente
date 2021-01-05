part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SetAuthorizationToken extends UserEvent{
  final String authorizationToken;
  SetAuthorizationToken({
    @required this.authorizationToken
  });
}

class SetUserInformation extends UserEvent{
  final UsuarioModel user;
  SetUserInformation({
    this.user
  });
}

class Logout extends UserEvent{

}