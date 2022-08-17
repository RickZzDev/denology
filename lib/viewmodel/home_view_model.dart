import 'dart:convert';

import 'package:devnology/model/product_list_model.dart';
import 'package:devnology/model/reviewd_items_model.dart';
import 'package:devnology/repository/products_repository.dart';
import 'package:devnology/service/home_service.dart';
import 'package:devnology/viewmodel/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel(HomeService service, ProductsRepository repository)
      : _service = service,
        _repository = repository,
        super(HomeInitialState());

  final HomeService _service;
  late ProductItemList localProducstVariable;
  final ProductsRepository _repository;

  late ReviewdItemsList reviewdItemsList;
  List<dynamic> cachedReviews = [];

  Future<void> getItems() async {
    try {
      localProducstVariable = await _service.getItems();
      localProducstVariable
          .setFavoriteStatus(await _repository.getFavoritedItemsId());
      await getShoppedItems();
      await getProductsReview(localProducstVariable);
      emit(HomeProductsLoaded(localProducstVariable));
    } catch (e) {
      print(e);
    }
  }

  Future<void> getShoppedItems() async {
    List<String> shoppedItems = await _repository.getShoppedItems();
    localProducstVariable.setShoppedItems(shoppedItems);
  }

  Future<void> getProductsReview(ProductItemList productListToAddReview) async {
    cachedReviews = await _repository.getReviews() ?? [];
    reviewdItemsList = ReviewdItemsList.fromJson(cachedReviews);
    productListToAddReview.addReviews(reviewdItemsList);
  }

  Future<void> updateReviewsInCache(ReviewdItems reviewdItem) async {
    reviewdItemsList =
        await _repository.updateReviewsInCache(reviewdItem, reviewdItemsList);
    emit(ReviewAdded());
  }

  int _getIndex(String id) => localProducstVariable.productList
      .indexWhere((element) => element.id == id);

  Future<void> addToShop(ProducstItem product) async {
    if (await _repository.isProductInChart(product)) {
      await _repository.removeFromChart(product);
      localProducstVariable.shoppedItems.remove(product);
      emit(ChangeItemShopList(false));
    } else {
      await _repository.addToChart(product);
      localProducstVariable.shoppedItems.add(product);
      emit(ChangeItemShopList(true));
    }
  }

  Future<void> favorite(ProducstItem product) async {
    if (await _repository.isProductFavorited(product)) {
      _repository.removeProductFromFavoriteds(product);
      localProducstVariable.productList[_getIndex(product.id)] = product;
      localProducstVariable.onlyFavoritedList.remove(product);
    } else {
      _repository.addProductToFavoriteds(product);
      localProducstVariable.productList[_getIndex(product.id)] = product;
      localProducstVariable.onlyFavoritedList.add(product);
    }
    emit(FavoritedItem());
  }

  void searchItem(String searchTerm) {
    searchTerm.isEmpty
        ? emit(HomeProductsLoaded(localProducstVariable))
        : DoNothingAction();
    ProductItemList filteredProducts = ProductItemList();

    filteredProducts.productList = localProducstVariable.productList
        .where((element) =>
            element.name!.toLowerCase().contains(searchTerm.toLowerCase()) ||
            element.description!.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ) ||
            element.description!
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            element.details.adjective.contains(searchTerm) ||
            element.discountValue.toString().contains(searchTerm) ||
            element.discountedValue.toString().contains((searchTerm)) ||
            element.price.toString().contains(searchTerm))
        .toList();
    emit(HomeProductsLoaded(filteredProducts));
  }
}
