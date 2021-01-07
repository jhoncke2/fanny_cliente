part of 'products_bloc.dart';

@immutable
class ProductsState {
  final bool productosCargados;
  final List<CategoriaModel> categories;
  final List<ProductoModel> products;
  final ProductoModel currentSelectedProduct;
  final CategoriaModel currentSelectedCategory;
  final List<ProductoModel> currentProductsByCategory;
  final String currentSearch;
  final List<ProductoModel> currentProductsBySearch;

  ProductsState({
    bool productosCargados,
    List<CategoriaModel> categories,
    List<ProductoModel> products,
    ProductoModel currentSelectedProduct,
    CategoriaModel currentSelectedCategory,
    List<ProductoModel> currentProductsByCategory,
    String currentSearch,
    List<ProductoModel> currentProductsBySearch
  }):
    this.productosCargados = productosCargados??false,
    this.categories = categories??null,
    this.products = products??false,
    this.currentSelectedProduct = currentSelectedProduct??null,
    this.currentSelectedCategory = currentSelectedCategory??null,
    this.currentProductsByCategory = currentProductsByCategory??null,
    this.currentSearch = currentSearch??null,
    this.currentProductsBySearch = currentProductsBySearch??null
    ;

  ProductsState copyWith({
    bool productosCargados,
    List<CategoriaModel> categories,
    List<ProductoModel> products,
    ProductoModel currentSelectedProduct,
    CategoriaModel currentSelectedCategory,
    List<ProductoModel> currentProductsByCategory,
    String currentSearch,
    List<ProductoModel> currentProductsBySearch
  }) => ProductsState(
    productosCargados: productosCargados??this.productosCargados,
    categories: categories??this.categories,
    products: products??this.products,
    currentSelectedProduct: currentSelectedProduct??this.currentSelectedProduct,
    currentSelectedCategory: currentSelectedCategory??this.currentSelectedCategory,
    currentProductsByCategory: currentProductsByCategory??this.currentProductsByCategory,
    currentSearch: currentSearch??this.currentSearch,
    currentProductsBySearch: currentProductsBySearch??this.currentProductsBySearch
  );

  ProductsState reset() => ProductsState();
}


