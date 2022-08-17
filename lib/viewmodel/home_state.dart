import 'package:devnology/model/product_list_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeProductsLoaded extends HomeState {
  final ProductItemList productModel;

  HomeProductsLoaded(this.productModel);
}

class FavoritedItem extends HomeState {}

class ChangeItemShopList extends HomeState {
  bool isItemAdded;
  ChangeItemShopList(this.isItemAdded);
}

class ReviewAdded extends HomeState {}
