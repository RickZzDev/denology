import 'package:devnology/model/reviewd_items_model.dart';

class ProductItemList {
  List<ProducstItem> productList = [];
  List<ProducstItem> onlyFavoritedList = [];
  List<ProducstItem> shoppedItems = [];

  ProductItemList.fromJson(List<dynamic> items) {
    for (var item in items) {
      productList.add(ProducstItem.fromJson(item));
    }
  }

  void addReviews(ReviewdItemsList reviewdItemsList) {
    for (var review in reviewdItemsList.items) {
      int index = productList.indexWhere((element) => element.id == review.id);
      productList[index].review.addAll(review.reviews ?? []);
    }
  }

  void setFavoriteStatus(List<String> favoritedItemsId) {
    for (var item in productList) {
      if (favoritedItemsId.contains(item.id)) {
        item.isFavorite = true;
        onlyFavoritedList.add(item);
      }
    }
  }

  void setShoppedItems(List<String> shoppedIdItems) {
    for (var item in productList) {
      if (shoppedIdItems.contains(item.id)) {
        item.isShopped = true;
        shoppedItems.add(item);
      }
    }
  }

  ProductItemList();
}

class ProducstItem {
  bool hasDiscount = false;
  String? name;
  List<String>? gallery;
  String? description;
  double? price;
  double? discountValue;
  double? discountedValue;
  late Details details;
  late String id;
  bool isFavorite = false;
  bool isShopped = false;

  List<String> review = [];

  ProducstItem({
    required this.hasDiscount,
    required this.id,
    this.name = '',
    this.gallery = const [''],
    this.description = '',
    this.price = 0,
    this.discountValue = 0,
    required this.details,
  });

  ProducstItem.fromJson(Map<String, dynamic> json) {
    hasDiscount = json['hasDiscount'];
    name = json['name'];
    gallery = json['gallery'].cast<String>();
    description = json['description'];
    price = double.parse(json['price']);
    discountValue = double.parse(json['discountValue']);
    details = Details.fromJson(json['details']);
    id = json['id'];
    discountedValue = hasDiscount ? price! - discountValue! : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['hasDiscount'] = hasDiscount;
    data['name'] = name;
    data['gallery'] = gallery;
    data['description'] = description;
    data['price'] = price;
    data['discountValue'] = discountValue;
    data['details'] = details.toJson();
    data['id'] = id;
    return data;
  }

  void setFavorite() {
    isFavorite = true;
  }
}

class Details {
  late String adjective;
  late String material;

  Details({required this.adjective, required this.material});

  Details.fromJson(Map<String, dynamic> json) {
    adjective = json['adjective'];
    material = json['material'];
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_new
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adjective'] = adjective;
    data['material'] = material;
    return data;
  }
}
