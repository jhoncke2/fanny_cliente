part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class SetCategories extends ProductsEvent{
  final List<CategoriaModel> categories;
  SetCategories({
    @required this.categories
  });
}

class SetProducts extends ProductsEvent{
  final List<ProductoModel> products;
  SetProducts({
    @required this.products
  });
}

class SelectProduct extends ProductsEvent{
  final ProductoModel selected;
  SelectProduct({
    @required this.selected
  });
}

class SetProductsByCategory extends ProductsEvent{
  final CategoriaModel category;
  final List<ProductoModel> products;
  SetProductsByCategory({
    @required this.category,
    @required this.products
  });
}

class SetProductsBySearch extends ProductsEvent{
  final String search;
  final List<ProductoModel> products;
  SetProductsBySearch({
    @required this.search,
    @required this.products
  });
}


