import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/confirmation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/pages/login_page.dart';

class NuevoPasswordRecuperacionWidget extends StatefulWidget {
  @override
  _NuevoPasswordRecuperacionWidgetState createState() => _NuevoPasswordRecuperacionWidgetState();
}

class _NuevoPasswordRecuperacionWidgetState extends State<NuevoPasswordRecuperacionWidget> {
  String _passwordValue = '';
  String _confirmedPasswordValue = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ConfirmationBloc confirmationBloc = Provider.confirmationBloc(context);
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Introduce la nueva contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.057,
              color: Colors.black.withOpacity(0.85),
            ),
          ),
          SizedBox(
            height: size.height * 0.045,
          ),
          _crearInputPassword(size),
          SizedBox(
            height: size.height * 0.045,
          ),
          _crearInputConfirmarPassword(size),
          SizedBox(
            height: size.height * 0.075,
          ),
          _crearBotonCambiar(size, confirmationBloc),

        ],
      ),
    );
  }

  Widget _crearInputPassword(Size size){
    return Container(
      width: size.width * 0.65,
      child: TextFormField(   
        initialValue: _passwordValue,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: 'Contraseña',
        ),
        onChanged: (String newValue){
          _passwordValue = newValue;
        },
      ),
    );
  }

  Widget _crearInputConfirmarPassword(Size size){
    return Container(
      width: size.width * 0.65,
      child: TextFormField(   
        initialValue: _confirmedPasswordValue,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline),
          labelText: 'Confirmar contraseña',
        ),
        onChanged: (String newValue){
          _confirmedPasswordValue = newValue;
        },
      ),
    );
  }

  Widget _crearBotonCambiar(Size size, ConfirmationBloc confirmationBloc){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.085, vertical: size.height * 0.0075),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05),
      ),
      color: Colors.grey.withOpacity(0.75),
      child: Text(
        'Cambiar',
        style: TextStyle(
          fontSize: size.width * 0.065,
          color: Colors.black.withOpacity(0.65)
        ),
      ),
      onPressed: (){
        confirmationBloc.enviarPasswordRecuperarPassword(confirmationBloc.emailPasswordConfirmation, _passwordValue, _confirmedPasswordValue);
        Navigator.pushReplacementNamed(context, LoginPage.route);
      },
    );
  }
}