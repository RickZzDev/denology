import 'dart:convert';

import 'package:devnology/model/product_list_model.dart';
import 'package:devnology/model/reviewd_items_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsRepository {
  Future<List<String>> getShoppedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("shopped_items") ?? [];
  }

  Future<List<String>> getFavoritedItemsId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("favorited_items") ?? [];
  }

  Future<List<dynamic>?> getReviews() async {
    final prefs = await SharedPreferences.getInstance();
    String? _reviewsFromCache = prefs.getString('reviewdItems');
    if (_reviewsFromCache != null) {
      Map<String, dynamic> valueConvertedToJson = jsonDecode(_reviewsFromCache);
      return valueConvertedToJson['reviewdItems'];
    }
    return null;
  }

  Future<bool> isProductInChart(ProducstItem product) async {
    final prefs = await SharedPreferences.getInstance();
    var shoppedList = prefs.getStringList('shopped_items') ?? [];

    return shoppedList.contains(product.id);
  }

  Future<ProducstItem> addToChart(ProducstItem product) async {
    final prefs = await SharedPreferences.getInstance();
    var shoppedList = prefs.getStringList('shopped_items') ?? [];
    shoppedList.add(product.id);
    product.isShopped = true;
    await prefs.setStringList('shopped_items', shoppedList);

    return product;
  }

  Future<ProducstItem> removeFromChart(ProducstItem product) async {
    _removeFromChartCacheList(product.id);
    product.isShopped = false;
    return product;
  }

  void _removeFromChartCacheList(String id) async {
    final prefs = await SharedPreferences.getInstance();
    var shoppedList = prefs.getStringList('shopped_items') ?? [];
    shoppedList.remove(id);
    await prefs.setStringList('shopped_items', shoppedList);
  }

  Future<bool> isProductFavorited(ProducstItem product) async {
    final prefs = await SharedPreferences.getInstance();
    var savedList = prefs.getStringList('favorited_items') ?? [];
    await prefs.setStringList('favorited_items', savedList);
    return savedList.contains(product.id);
  }

  Future<ProducstItem> removeProductFromFavoriteds(ProducstItem product) async {
    final prefs = await SharedPreferences.getInstance();
    var savedList = prefs.getStringList('favorited_items') ?? [];
    savedList.remove(product.id);
    product.isFavorite = false;
    await prefs.setStringList('favorited_items', savedList);

    return product;
  }

  Future<ProducstItem> addProductToFavoriteds(ProducstItem product) async {
    final prefs = await SharedPreferences.getInstance();
    var savedList = prefs.getStringList('favorited_items') ?? [];
    savedList.add(product.id);
    product.isFavorite = true;
    await prefs.setStringList('favorited_items', savedList);
    return product;
  }

  Future<ReviewdItemsList> updateReviewsInCache(
      ReviewdItems reviewdItem, ReviewdItemsList actualReviewList) async {
    final prefs = await SharedPreferences.getInstance();
    int index = actualReviewList.items.indexOf(reviewdItem);
    if (index == -1) {
      actualReviewList.items.add(reviewdItem);
      prefs.setString("reviewdItems", jsonEncode(actualReviewList.toJson()));
    } else {
      actualReviewList.items[index] = reviewdItem;
      prefs.setString("reviewdItems", jsonEncode(actualReviewList.toJson()));
    }

    return actualReviewList;
  }
}
