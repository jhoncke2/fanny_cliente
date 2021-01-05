import 'package:fanny_cliente/src/bloc_old/confirmation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/widgets/pasos_recuperar_password/introducir_codigo_recuperacion_widget.dart';
import 'package:fanny_cliente/src/widgets/pasos_recuperar_password/introducir_email_recuperacion_widget.dart';
import 'package:fanny_cliente/src/widgets/pasos_recuperar_password/nuevo_password_recuperacion_widget.dart';
import 'package:flutter/material.dart';
class PasosRecuperarPasswordPage extends StatefulWidget{
  static final route = 'pasos_recuperar_password';
  @override
  _PasosRecuperarPasswordPageState createState() => _PasosRecuperarPasswordPageState();
}

class _PasosRecuperarPasswordPageState extends State<PasosRecuperarPasswordPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ConfirmationBloc confirmationBloc = Provider.confirmationBloc(context);
    return Scaffold(
      body: StreamBuilder(
        stream: confirmationBloc.pasoPasswordSuperadoStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          
          if(snapshot.hasData){
            print('tiene data');
            if(snapshot.data=='email')
              return IntroducirCodigoRecuperacionWidget();
            else if(snapshot.data=='code')
              return NuevoPasswordRecuperacionWidget();
              
            return IntroducirEmailRecuperacionWidget();
          }
          else{
            print('no tiene data');
            return IntroducirEmailRecuperacionWidget();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.withOpacity(0.8),
        child: Icon(
          Icons.arrow_back_ios,
          size: size.width * 0.065,
          color: Colors.black.withOpacity(0.5),
        ),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
    );
  }
}