import 'package:fanny_cliente/src/bloc_old/productos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/tienda_bloc.dart';
import 'package:fanny_cliente/src/models/productos_model.dart';
import 'package:fanny_cliente/src/models/tiendas_model.dart';
import 'package:fanny_cliente/src/pages/producto_detail_page.dart';
import 'package:fanny_cliente/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:fanny_cliente/src/widgets/header/header_widget.dart';
import 'package:flutter/material.dart';
class FavoritosPage extends StatefulWidget {
  static final route = 'favoritos';
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  BuildContext context;
  Size size;
  ProductosBloc productosBloc;
  TiendaBloc tiendaBloc;

  bool widgetBuilded;
  @override
  void initState() { 
    super.initState();
    widgetBuilded = false;
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    productosBloc = Provider.productosBloc(context);
    tiendaBloc = Provider.tiendaBloc(context);
    if(!widgetBuilded){
      widgetBuilded = true;
      _cargarProductosFavoritos();
    }
    return Scaffold(
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.064,
          ),
          HeaderWidget(),
          SizedBox(
            height: size.height * 0.01,
          ),
          _crearTitulo(),
          _crearListViewFavoritos(),
        ],
      ),
    );
  }

  Future<void> _cargarProductosFavoritos()async{
    Map<String, dynamic> cargarFavoritosResponse = await productosBloc.cargarFavoritos(Provider.usuarioBloc(context).token);
    if(cargarFavoritosResponse['status'] == 'ok'){
      List<TiendaModel> tiendasNames = [];
      cargarFavoritosResponse['favoritos'].forEach((Map<String, dynamic> favorito){
       // Map<String, dynamic> tiendaOfProduct = await tiendaBloc.cargarTiendaPublic(token, tiendaId);
      });
    }
  }

  Widget _crearTitulo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: size.width * 0.05,
            color: Colors.black.withOpacity(0.6),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        Text(
          'Favoritos',
          style: TextStyle(
            fontSize: size.width * 0.067,
            color: Colors.black.withOpacity(0.65),
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(
          width: size.width * 0.05,
        )
      ],
    );
  }

  Widget _crearListViewFavoritos(){   
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: productosBloc.favoritosStream,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData){
          List<Widget> listViewItems = [];
          snapshot.data.forEach((Map<String, dynamic> favorito){
            listViewItems.add(
              _crearProductoFavorito(size, favorito)
            );
            
            listViewItems.add(
              Divider(
                color: Colors.grey.withOpacity(0.275),
                height: size.height * 0.045,
                thickness: size.height * 0.0028,
                indent: size.width * 0.15,
                endIndent: size.width * 0.15,
              )
            );
            listViewItems.add(
              SizedBox(
                height: size.height * 0.022,
              )
            );
            
          });
          return Container(
            height: size.height * 0.67,
            child: ListView(
              padding: EdgeInsets.only(top:size.height * 0.045, bottom: size.height * 0.02),
              children: listViewItems,
            ),
          );
        }
        else{
          return CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          );
        }
          
      }
    );
  }

  Widget _crearProductoFavorito(Size size, Map<String, dynamic> favorito){
    ProductoModel producto = favorito['product'];
    return GestureDetector(
      child: Container(
        child: Row(
          children: <Widget>[
            FadeInImage(
              width: size.width * 0.3,
              height: size.height * 0.115,
              fit: BoxFit.fill,
              placeholder: AssetImage('assets/placeholder_images/productos_gifs/gif_cargando_1.gif'),
              image: NetworkImage(producto.photos[0]['url']),
            ),
            SizedBox(
              width: size.width * 0.038,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width  * 0.47),
                  child: Text(
                    producto.name,
                    style: TextStyle(
                      fontSize: size.width * 0.048,
                      color: Colors.black.withOpacity(0.75)
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                //Completar después:
                Text(
                  favorito['product'].owner,
                  style: TextStyle(
                    fontSize: size.width * 0.041,
                    color: Colors.black.withOpacity(0.75)
                  ),
                ),
                Icon(
                  Icons.favorite,
                  size: size.width * 0.073,
                  color: Colors.red,
                )
              ],
            )
          ],
        )
      ),
      onTap: (){
        print(favorito);
        Navigator.of(context).pushNamed(
          ProductoDetailPage.route, 
          arguments: {
            'tipo':'favorito',
            'value':favorito
          }
        );
      },
    );
  }
}