import 'dart:convert';
import 'package:devnology/model/product_list_model.dart';
import 'package:http/http.dart' as http;

abstract class HomeService {
  Future<ProductItemList> getItems();
}

class RestHomeService implements HomeService {
  var _httpClient = http.Client();
  var url = Uri.https(
      '616d6bdb6dacbb001794ca17.mockapi.io', '/devnology/european_provider');
  @override
  Future<ProductItemList> getItems() async {
    var response = await _httpClient.get(url);
    return ProductItemList.fromJson(json.decode(response.body));
  }
}
