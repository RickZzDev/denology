class ReviewdItemsList {
  List<ReviewdItems> items = [];
  ReviewdItemsList();
  ReviewdItemsList.fromJson(List<dynamic> json) {
    for (var item in json) {
      items.add(ReviewdItems.fromJson(item));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['reviewdItems'] = items.map((v) => v.toJson()).toList();
    return data;
  }
}

class ReviewdItems {
  String? id;
  List<String>? reviews;

  ReviewdItems({this.id, this.reviews});

  ReviewdItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviews = json['reviews'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['reviews'] = reviews;
    return data;
  }
}
