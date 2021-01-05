import 'dart:ui';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/pages/login_page.dart';
import 'package:fanny_cliente/src/pages/pasos_confirmacion_celular_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static final String route = 'register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //String _nombreValue = 'Armando Casas';
  //String _emailVaue = 'oskrjag@gmail.com';
  //String _phoneValue = '3015377921';
  //String _passwordValue = '12345678';
  //String _confirmatedPasswordValue = '12345678';

  String _nombreValue = '';
  String _emailVaue = '';
  String _phoneValue = '';
  String _passwordValue = '';
  String _confirmatedPasswordValue = '';
  
  @override
  Widget build(BuildContext context) {
    final usuarioBloc = Provider.usuarioBloc(context);
    final lugaresBloc = Provider.lugaresBloc(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _crearElementos(context, size, usuarioBloc, lugaresBloc),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
  Widget _crearElementos(BuildContext context, Size size, UsuarioBloc usuarioBloc, LugaresBloc lugaresBloc){
    return Container(
      //padding: EdgeInsets.symmetric(horizontal:size.width * 0.15),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.08,
          ),
          _crearImgLogo(size),
          SizedBox(
            height: size.height * 0.075,
          ),
          Center(
            child: Text(
              'Registrate',
              style: TextStyle(
                fontSize: size.width * 0.067,
                color: Colors.black.withOpacity(0.75),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          _crearIngresoExterno(size),
          SizedBox(height: size.height * 0.025),
          Center(
            child: Text(
              'o',
              style: TextStyle(
                fontSize: size.width * 0.055,
                color: Colors.black.withOpacity(0.65),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          _crearRegisterForm(context, size, usuarioBloc),
          SizedBox(
            height: size.height * 0.05,
          ),
           _crearBotonSubmit(context, size, usuarioBloc, lugaresBloc),      
          SizedBox(height: size.height*0.045),
          FlatButton(
            child: Text(
              '¿Ya tienes una cuenta? Ingresa',
              style: TextStyle(
                fontSize: size.width * 0.055,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, LoginPage.route);
            },
          ),        
          SizedBox(
            height: size.height * 0.075,
          ),
        ],
      ),
    );
  }

  Widget _crearImgLogo(Size size){
    return Center(
      child: Image.asset(
        'assets/iconos/logo_fanny_1.png',
        fit: BoxFit.fill,
        width: size.width * 0.65,
        height: size.height * 0.165, 
      ),
    );
  }

  Widget _crearRegisterForm(BuildContext context, Size size, UsuarioBloc usuarioBloc){
    final size = MediaQuery.of(context).size;
    //para poder hacer scroll a todo lo que haya dentro.
    return Center(
      child: Container(
        width: size.width * 0.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.035),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.85),
              blurRadius: size.width * 0.062,
              spreadRadius: 2.0,
              offset: Offset(
                1.0, 
                1.0
              ),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            _crearInputNombre(),
            SizedBox(
              height: size.height * 0.001,
              child: Container(
                height: size.height * 0.001,
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            _crearInputEmail(),
            SizedBox(
              height: size.height * 0.001,
              child: Container(
                height: size.height * 0.001,
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            _crearInputNumeroCelular(),
            SizedBox(
              height: size.height * 0.001,
              child: Container(
                height: size.height * 0.001,
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            _crearInputPassword(),
            SizedBox(
              height: size.height * 0.001,
              child: Container(
                height: size.height * 0.001,
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            _crearInputConfirmarPassword(),  
          ],
        ),
      ),
    );
  }

  Widget _crearInputNombre(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20.0),
      child: TextFormField(
        initialValue: _nombreValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.0,
              style: BorderStyle.none         
            )
          ),
          icon: Icon(Icons.account_circle),
          hintText: 'Nombres'
          //labelText: 'Nombres y apellidos',
        ),
        onChanged: (String newValue){
          _nombreValue = newValue;
        },
      ),
    );
  }

  Widget _crearInputEmail(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        initialValue: _emailVaue,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(      
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.0,
              style: BorderStyle.none
            )
          ),
          icon: Icon(Icons.email),
          hintText: 'Email'
          //labelText: 'Correo electrónico',
        ),
        onChanged: (String newValue){
          _emailVaue = newValue;
        },
      ),
    );
  }

  Widget _crearInputNumeroCelular(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20.0),
      child: TextFormField(
        initialValue: _phoneValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.0,
              style: BorderStyle.none             
            )
          ),
          icon: Icon(Icons.phone_android),
          prefixText: '(+57) '
          //labelText: 'Número de celular'
        ),
        onChanged: (String newValue){
          _phoneValue = newValue;
        },
      ),
    );
  }

  Widget _crearInputPassword(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        initialValue: _passwordValue,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.0,
              style: BorderStyle.none          
            )
          ),
          icon: Icon(Icons.lock_outline),
          hintText: 'Contraseña'
          //labelText: 'Contraseña',
        ),
        onChanged: (String newValue){
          _passwordValue = newValue;
        },
      ),
    );
  }

  Widget _crearInputConfirmarPassword(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        initialValue: _confirmatedPasswordValue,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.0,
              style: BorderStyle.none
            )
          ),
          icon: Icon(Icons.lock),
          hintText: 'Confirmar contraseña'
          //labelText: 'Confirmar contraseña',
        ),
        onChanged: (String newValue){
          _confirmatedPasswordValue = newValue;
        },
      ),
    );
  }

  Widget _crearIngresoExterno(Size size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/placeholder_images/google/google_normal_icon.png',
          width: size.width * 0.07,
          height: size.height * 0.036,
          fit: BoxFit.fill,
        ),
        SizedBox(
          width: size.width * 0.05,
        ),
        Image.asset(
          'assets/placeholder_images/facebook/facebook_normal_right_icon.png',
          width: size.width * 0.07,
          height: size.height * 0.036,
          fit: BoxFit.fill,
        ),
      ]
    );
  }

  Widget _crearBotonSubmit(BuildContext context, Size size, UsuarioBloc usuarioBloc, LugaresBloc lugaresBloc){ 
    return Center(
      child: Container(
        width: size.width * 0.3,
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical:size.height * 0.013),
          color: Theme.of(context).primaryColor.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.075)
          ),
          child: Text(
            'Registrarse', 
            style: TextStyle(
              fontSize: size.width * 0.045,
              color: Colors.white.withOpacity(0.85)
            )
          ),
          onPressed: (){
            _registrar(context, usuarioBloc, lugaresBloc);
          },
        ),
      ),
    );
  }

  void _registrar(BuildContext context, UsuarioBloc usuarioBloc, LugaresBloc lugaresBloc)async{
    print(_passwordValue);
    print(_confirmatedPasswordValue);
    Map<String, dynamic> respuestaRegister = await usuarioBloc.register(_nombreValue, _emailVaue, _phoneValue, _passwordValue, _confirmatedPasswordValue);    
    if(respuestaRegister['status']=='ok'){
      Navigator.pushNamed(context, PasosConfirmacionCelularPage.route);
    }   
  }
  
}