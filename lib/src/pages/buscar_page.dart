import 'package:fanny_cliente/src/widgets/bottom_bar/bottom_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fanny_cliente/src/bloc_old/productos_bloc.dart';
import 'package:fanny_cliente/src/bloc_old/provider.dart';
import 'package:fanny_cliente/src/bloc_old/size_bloc.dart';
import 'package:fanny_cliente/src/widgets/data_search_widget.dart';
import 'package:fanny_cliente/src/widgets/header/header_widget.dart';
import 'package:fanny_cliente/src/widgets/productos/productos_widget.dart';
class BuscarPage extends StatefulWidget {
  static final route = 'buscar';
  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  BuildContext context;
  Size size;
  SizeBloc sizeBloc;
  ProductosBloc productosBloc;

  TextEditingController _searchEditingController;

  @override
  void initState() { 
    super.initState();
    _searchEditingController = new TextEditingController();
  }

  @override
  Widget build(BuildContext appContext) {
    context = appContext;
    size = MediaQuery.of(context).size;
    sizeBloc = Provider.sizeBloc(context);
    productosBloc = Provider.productosBloc(context);
    return Scaffold(
      body: _crearElementos(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _crearElementos(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: sizeBloc.largeSizedBoxHeigh,
            ),
            HeaderWidget(),
            SizedBox(
              height: sizeBloc.normalSizedBoxHeigh * 0.5
            ),
            _crearSearchBarRow(),
            SizedBox(
              height: sizeBloc.normalSizedBoxHeigh * 0.5
            ),
            ProductosWidget(
              tipoListaProducto: TipoListaProducto.BY_SEARCH,
              heightPercent: 0.6,
            )
          ],
        ),
      ),
    );
  }

  Widget _crearSearchBarRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          color: Colors.black.withOpacity(0.8),
          icon: Icon(
            Icons.arrow_back_ios
          ),
          onPressed: (){
            productosBloc.disposeProductosSearchController();
            Navigator.of(context).pop();
          },
        ),   
        Container(
          height: sizeBloc.xasisSobreYasis * 0.085,
          width: sizeBloc.xasisSobreYasis * 0.415,
          padding: EdgeInsets.symmetric(
            horizontal: sizeBloc.xasisSobreYasis * 0.005,
            vertical: sizeBloc.xasisSobreYasis * 0.001
          ),
          child: TextFormField(
            controller: _searchEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: sizeBloc.xasisSobreYasis * 0.019,
                vertical: sizeBloc.xasisSobreYasis * 0.0038
                
              ),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.25),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.001,
                  color: Colors.green.withOpacity(0.9),
                ),
                borderRadius: BorderRadius.circular(
                  sizeBloc.xasisSobreYasis * 0.08
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  sizeBloc.xasisSobreYasis * 0.08
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.85),
                  width: size.width * 0.0001
                ),
                borderRadius: BorderRadius.circular(
                  sizeBloc.xasisSobreYasis * 0.08
                ),
              )
            ),
            onEditingComplete: (){
              print('text edited');
              FocusScope.of(context).requestFocus(new FocusNode());
              print(_searchEditingController.value.text);
              Provider.productosBloc(context).cargarProductosBySearch(_searchEditingController.value.text);
            },
          ),
        ),
        IconButton(
          color: Colors.black.withOpacity(0.8),
          icon: Icon(
            Icons.clear
          ),
          onPressed: (){
            _searchEditingController.text = '';
          },
        ),
      ],
    );
  }

  Future<void> _disposeProductosSearch()async{
    await productosBloc.disposeProductosSearchController();
    productosBloc.initProductosSearchController();
  }

  Widget _crearBarRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          color: Colors.black.withOpacity(0.8),
          icon: Icon(
            Icons.arrow_back
          ),
          onPressed: (){
            _disposeProductosSearch();
            Provider.navigationBloc(context).index = 0;
            Navigator.of(context).pop();
          },
        ),
        SizedBox(
          width: size.width * 0.05,
        ),
        FlatButton(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1,
            vertical: size.height * 0.02
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.075)
          ),
          child: Container(
            height: size.height * 0.01,
            width: size.width * 0.45,
          ),
          color: Colors.grey.withOpacity(0.15),
          onPressed: (){
            showSearch(
              context: context, 
              delegate: DataSearchWidget()
            );
          },
        )
      ],
    );
  }
}