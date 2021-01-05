import 'package:fanny_cliente/src/bloc/polygons/polygons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/lugares_bloc.dart';
import 'package:fanny_cliente/src/pages/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fanny_cliente/src/bloc_old/navigation_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/shared_preferences_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/tienda_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/usuario_bloc.dart';
import 'package:fanny_cliente/src/models/lugares_model.dart';
import 'package:fanny_cliente/src/pages/pasos_confirmacion_celular_page.dart';
import 'package:fanny_cliente/src/pages/pasos_recuperar_password_page.dart';
import 'package:fanny_cliente/src/pages/register_page.dart';
import 'package:fanny_cliente/src/providers/push_notifications_provider.dart';
import 'package:fanny_cliente/src/utils/data_prueba/tienda_polygons.dart' as tiendaPolygons;


//clases locales

class LoginPage extends StatefulWidget {
  static final String route = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  BuildContext context;
  Size size;
  SharedPreferencesBloc sharedPreferencesBloc;
  UsuarioBloc usuarioBloc;
  TiendaBloc tiendaBloc;
  NavigationBloc navigationBloc;
  LugaresBloc lugaresBloc;
  bool widgetBuilded;

  String _emailValue = '';
  String _passwordValue = '';
  //String _emailValue = 'filledMoon@gmail.com';
  //String _passwordValue = '12345678';
  //String _emailValue = 'yonandres97@gmail.com';
  //String _passwordValue = '12345678';

  @override
  void initState() { 
    super.initState();
    widgetBuilded = false;
  }

  @override
  Widget build(BuildContext appContext) {
    _initInitialConfiguration(appContext);
    //sharedPreferencesBloc.deletePedidoTemporal();
    if(!widgetBuilded){
      _initSharedPreferences();
      widgetBuilded = true;
    }
    return Scaffold(
      key: _scaffoldKey,
      body: _crearElementos(context, size, usuarioBloc),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    context = appContext;
    size = MediaQuery.of(context).size;
    sharedPreferencesBloc = Provider.sharedPreferencesBloc(context);
    usuarioBloc = Provider.usuarioBloc(context);
    navigationBloc = Provider.navigationBloc(context);
    lugaresBloc = Provider.lugaresBloc(context);
    tiendaBloc = Provider.tiendaBloc(context);
  }

  void _initSharedPreferences()async{
    if(sharedPreferencesBloc.sharedPreferences == null){
      await sharedPreferencesBloc.initSharedPreferences();
      sharedPreferencesBloc.setDireccionTemporal(
        LugarModel(
          direccion: 'Av. calle 40 # 13 - 73, Bogotá',
          latitud: 30.5,
          longitud: 20.058,
          elegido: true,
          pais: 'Colombia',
          ciudad: 'Bogota',
          observaciones: 'primer piso',
        )
      );
    }
  }

  Widget _crearElementos(BuildContext context, Size size, UsuarioBloc usuarioBloc){
    return Container(
      //padding: EdgeInsets.symmetric(horizontal:size.width * 0.15),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.1,
          ),
          _crearImgLogo(size),
          SizedBox(
            height: size.height * 0.075,
          ),
          Center(
            child: Text(
              'Ingreso',
              style: TextStyle(
                fontSize: size.width * 0.07,
                color: Colors.black.withOpacity(0.75),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          _crearLoginForm(context, size, usuarioBloc),
          SizedBox(
            height: size.height * 0.05,
          ),
           _crearBotonSubmit(context, size, usuarioBloc),
          SizedBox(height: size.height * 0.03),
          _crearIngresoExterno(size),
          SizedBox(height: size.height*0.001),
          FlatButton(
            child: Text(
              '¿Olvidó contraseña?',
              style: TextStyle(
                fontSize: size.width * 0.049,
                //color: Color.fromRGBO(60, 120, 250, 1),
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            onPressed: (){
              Navigator.pushNamed(context, PasosRecuperarPasswordPage.route);
            },
          ),
          SizedBox(height: size.height * 0.01),
          FlatButton(
            child: Text(
              'Registrate',
              style: TextStyle(
                fontSize: size.width * 0.06,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, RegisterPage.route);
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
        height: size.height * 0.165      
      ),
    );
  }

  Widget _crearLoginForm(BuildContext context, Size size, UsuarioBloc usuarioBloc){
    //para poder hacer scroll a todo lo que haya dentro.
    return Center(
      child: Container(
        width: size.width * 0.72,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          //color: Colors.blueAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(size.width * 0.025),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.85),
              blurRadius: size.width * 0.06,
              offset: Offset(
                1.0,
                1.0
              )
            )
          ]
        ),
        child: Column(
          children: <Widget>[
            /**
             * El SingleCHildScrollView: Para que cuando salga el teclado no salga un 
             * error de overflow verticalmente.
             */
            //SizedBox(height: size.height * 0.01),
            _crearInputEmail(),
            //SizedBox(height: size.height * 0.01),
            SizedBox(
              height: size.height * 0.001,
              child: Container(
                height: size.height * 0.001,
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            _crearInputPassword(),
            
          ],
        ),
      ),
    );
  }

  Widget _crearInputEmail(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20.0),
      child: TextFormField(
        initialValue: _emailValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.0,
              style: BorderStyle.none          
            )
          ),
          icon: Icon(Icons.account_circle),
          //labelText: 'email',
        ),
        onChanged: (String newValue){
          _emailValue = newValue;
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
          icon: Icon(Icons.lock),
          //labelText: 'Contraseña',
        ),
        onChanged: (String newValue){
          _passwordValue = newValue;
        },
      ),
    );
  }

  Widget _crearIngresoExterno(Size size){
    return Column(
      children: <Widget>[
        Text(
          'O ingresa con',
          style: TextStyle(
            fontSize: size.width * 0.05,
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(
          height: size.height * 0.02
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[            
            IconButton(
              iconSize: size.width * 0.07,
              color: Theme.of(context).primaryColor,
              icon: Icon(
                FontAwesomeIcons.facebook,
              ),
              onPressed: (){
                //_loginExterno(LoginProviders.FACEBOOK);
              },
            ),
          ]
        )
      ],
    );
  }

  /*
  Mientras agregamos login externo por facebook y/o google
  Future<void> _loginExterno(LoginProviders loginProvider)async{
    Map<String, dynamic> response = await Provider.usuarioBloc(context).generalLogin(LoginProviders.FACEBOOK);
    Map<String, dynamic> validarEmailResponse = await Provider.usuarioBloc(context).validarEmail(response['user'].email);
    if(validarEmailResponse['status'] == 'invalid_credentials'){
      Navigator.of(context).pushNamed(RegisterPage.route, arguments: {
        'user':response['user'],
        'login_provider':loginProvider
      });
    }
    else if(validarEmailResponse['status'] == 'ok'){
      await Provider.usuarioBloc(context).cargarUsuario(validarEmailResponse['token']);
      Navigator.of(context).pushNamed(HomePage.route);
    }
  }
  */

  Widget _crearBotonSubmit(BuildContext context, Size size, UsuarioBloc usuarioBloc){
    return Center(
      child: Container(
        width: size.width * 0.25,
        child: FlatButton(   
          padding: EdgeInsets.symmetric(vertical:size.height * 0.013),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.075)
          ),
          child: Text(
            'Ingresa', 
            style: TextStyle(
              fontSize: size.width * 0.045,
              color: Colors.white.withOpacity(0.9)
            )
          ),
          onPressed: (){
            _clickSubmit(context, usuarioBloc);
          },
        ),
      ),
    );
  }

  void _clickSubmit(BuildContext context, UsuarioBloc usuarioBloc)async{
    Map<String, dynamic> loginResponse = await usuarioBloc.login(_emailValue, _passwordValue);   
    if(usuarioBloc.usuario.phoneVerify){
      List<Map<String, dynamic>> pedidoActual = await sharedPreferencesBloc.getPedidoTemporal();   
      await lugaresBloc.cargarLugares(usuarioBloc.token);
      final PolygonsBloc polygonsBloc = BlocProvider.of<PolygonsBloc>(context);
      polygonsBloc.add(AddPolygons(polygons: tiendaPolygons.tiendaPolygons));
      await _doMobileTokenValidations();
    } 
    else
      Navigator.pushNamed(context, PasosConfirmacionCelularPage.route);
  }

  Future<void> _doMobileTokenValidations()async{
    final String newMobileToken = await PushNotificationsProvider.getMobileToken();
    if(newMobileToken != usuarioBloc.usuario.mobileToken){
      Map<String, dynamic> mobileResponse = await usuarioBloc.updateMobileToken(usuarioBloc.token, newMobileToken, usuarioBloc.usuario.id);
      //falta implementar if(!cliente_tiene_direcciones){vayase_a_crear_direccion}
      if(mobileResponse['status'] == 'ok'){
        usuarioBloc.usuario.mobileToken = newMobileToken;
        await _doLoginValidations();
      }
    }else{
      await _doLoginValidations();       
    }
  }

  Future<void> _doLoginValidations()async{
    await tiendaBloc.cargarTienda(usuarioBloc.token);
    await Provider.pedidosBloc(context).cargarPedidosAnterioresPorClienteOTienda(usuarioBloc.token, 'cliente', null);
    Provider.navigationBloc(context).reiniciarIndex();
    Provider.sharedPreferencesBloc(context).deleteDireccionTemporalInicial();
    Provider.sharedPreferencesBloc(context).normalLogIn(_emailValue, _passwordValue);      
    navigationBloc.reiniciarIndex();
    Navigator.pushReplacementNamed(context, HomePage.route);
  }
}