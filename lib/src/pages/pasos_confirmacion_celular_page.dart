import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/confirmation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';

class PasosConfirmacionCelularPage extends StatefulWidget {
  static final route = 'pasosConfirmacionCelular';

  @override
  _PasosConfirmacionCelularPageState createState() => _PasosConfirmacionCelularPageState();
}

class _PasosConfirmacionCelularPageState extends State<PasosConfirmacionCelularPage> {
  String _codigoValue = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final confirmationBloc = Provider.confirmationBloc(context);
    final usuarioBloc = Provider.usuarioBloc(context);
    if(confirmationBloc.newPhoneConfirmation == null)
      confirmationBloc.newPhoneConfirmation = usuarioBloc.usuario.phone;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.08,
            ),
            _crearTitulo(size),
            _crearElementosContenido(size, confirmationBloc, usuarioBloc),
          ],
        ),
      ),
    );
  }

  Widget _crearTitulo(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey.withOpacity(0.9),
          ),
          iconSize: size.width * 0.065,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        Text(
          'Confirmar celular',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.7),
            fontSize: size.width * 0.062
          ),
        ),
        SizedBox(
          width: size.width * 0.1,
        )
      ],
    );
  }

  Widget _crearElementosContenido(Size size, ConfirmationBloc confirmationBloc, UsuarioBloc usuarioBloc){
    return Expanded(   
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Introdue el código que te llegó al celular',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black.withOpacity(0.8),
                fontSize: size.width * 0.057
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            _crearInputIntroducirCodigo(size),
            SizedBox(
              height: size.height * 0.035,
            ),
            _crearBotonSubmit(size, confirmationBloc, usuarioBloc),
            SizedBox(
              height: size.height * 0.11,
            ),
            Text(
              'Si no te ha llegado el código escribe aquí',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black.withOpacity(0.8),
                fontSize: size.width * 0.057
              ),
            ),
            SizedBox(
              height: size.height * 0.042,
            ),
            _crearBotonReenviarCodigo(size, usuarioBloc, confirmationBloc),
            SizedBox(
              height: size.height * 0.05,
            )
          ],
        ),
      )
    );
  }

  Widget _crearInputIntroducirCodigo(Size size){
    return Container(
      width: size.width * 0.7,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Código',
          icon: Icon(
            Icons.confirmation_number,
          ),
        ),
        onChanged: (String newValue){
          _codigoValue = newValue;
        },
      ),
    );
  }

  Widget _crearBotonSubmit(Size size, ConfirmationBloc confirmationBloc, UsuarioBloc usuarioBloc){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.075, vertical: size.height * 0.008),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05)
      ),
      //color: Colors.grey.withOpacity(0.5),
      color: Theme.of(context).primaryColor,
      child: Text(
        'Enviar',
        style: TextStyle(
          fontSize: size.width * 0.048,
          color: Colors.white.withOpacity(0.95)
        ),
      ),
      onPressed: ()=> _verificarCodigo(confirmationBloc, usuarioBloc),
    );
  }

  void _verificarCodigo(ConfirmationBloc confirmationBloc, UsuarioBloc usuarioBloc)async{
    Map<String, dynamic> enviarCodigoResultado = await confirmationBloc.enviarCodigoConfirmarPhone(usuarioBloc.token, usuarioBloc.usuario.id, _codigoValue);
    if(enviarCodigoResultado['status'] == 'ok'){
      //String newMobileToken = await PushNotificationsProvider.getMobileToken();
      //Map<String, dynamic> mobileResponse = await usuarioBloc.updateMobileToken(usuarioBloc.token, newMobileToken, usuarioBloc.usuario.id);
      Map<String, dynamic> mobileResponse = {'status':'ok'};
      if(mobileResponse['status'] == 'ok'){
        //usuarioBloc.usuario.mobileToken = newMobileToken;
        Provider.navigationBloc(context).reiniciarIndex();
        Navigator.pushReplacementNamed(context, HomePage.route, arguments: 'cliente_nuevo');
      }
    }
      
  }

  Widget _crearBotonReenviarCodigo(Size size, UsuarioBloc usuarioBloc, ConfirmationBloc confirmationBloc){
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.067, vertical: size.height * 0.0085),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05)
      ),
      //color: Colors.grey.withOpacity(0.5),
      color: Theme.of(context).primaryColor,
      child: Text(
        'Reenviar código',
        style: TextStyle(
          fontSize: size.width * 0.048,
          color: Colors.white.withOpacity(0.95)
        ),
      ),
      onPressed: (){
        confirmationBloc.resetCode(usuarioBloc.token, 'phone', usuarioBloc.usuario.id.toString());
      },
    );
  }
}