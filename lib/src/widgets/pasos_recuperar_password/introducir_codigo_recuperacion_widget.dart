import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/confirmation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
class IntroducirCodigoRecuperacionWidget extends StatefulWidget {

  @override
  _IntroducirCodigoRecuperacionWidgetState createState() => _IntroducirCodigoRecuperacionWidgetState();
}

class _IntroducirCodigoRecuperacionWidgetState extends State<IntroducirCodigoRecuperacionWidget> {
  String _codigoValue = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final usuarioBloc = Provider.usuarioBloc(context);
    final confirmationBloc = Provider.confirmationBloc(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Introduce el código de verificación que te llegó al móvil',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.054,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          SizedBox(
            height: size.height * 0.045,
          ),
          _crearInputCodigo(size),
          SizedBox(
            height: size.height * 0.045,
          ),
          _crearBotonEnviar(size, confirmationBloc),
          SizedBox(
            height: size.height * 0.12,
          ),
          Text(
            'Si aún no te ha llegado el código, clickea aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.052,
              color: Colors.black.withOpacity(0.67),
            ),
          ),
          SizedBox(
            height: size.height * 0.035,
          ),
          _crearBotonReenviarCodigo(size, usuarioBloc, confirmationBloc)
        ],
      ),
    );
  }

  Widget _crearInputCodigo(Size size){
    return Container(
      width: size.width * 0.65,
      child: TextFormField( 
        initialValue: _codigoValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: Icon(Icons.confirmation_number),
          labelText: 'código de verificación',
        ),
        onChanged: (String newValue){
          _codigoValue = newValue;
        },
      ),
    );
  }

  Widget _crearBotonEnviar(Size size, ConfirmationBloc confirmationBloc){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.085, vertical: size.height * 0.0075),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05),
      ),
      color: Colors.grey.withOpacity(0.75),
      child: Text(
        'Confirmar',
        style: TextStyle(
          fontSize: size.width * 0.065,
          color: Colors.black.withOpacity(0.65)
        ),
      ),
      onPressed: (){
        confirmationBloc.enviarCodigoRecuperarPassword(confirmationBloc.emailPasswordConfirmation, _codigoValue);
      },
    );
  }

  Widget _crearBotonReenviarCodigo(Size size, UsuarioBloc usuarioBloc, ConfirmationBloc confirmationBloc){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.085, vertical: size.height * 0.0075),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05),
      ),
      color: Colors.grey.withOpacity(0.75),
      child: Text(
        'Reenviar código',
        style: TextStyle(
          fontSize: size.width * 0.054,
          color: Colors.black.withOpacity(0.65)
        ),
      ),
      onPressed: (){
        confirmationBloc.resetCode(usuarioBloc.token, 'password', confirmationBloc.emailPasswordConfirmation);
      },
    );
  }
}