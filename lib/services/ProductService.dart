import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whatsapp/models/Product.dart';

class ProductService {
  static Future<Map> getProducts(int page) async {
    List<Product> lstProducts = [];

    var response = await http.get("http://roocket.org/api/products?page=$page");

    var responseBody = json.decode(response.body)['data'];

    responseBody['data'].forEach((item) {
      //each item has Product fields but it's a map not a Product instance
      lstProducts.add(Product.fromJson(item));
    });

    return {
      "current_page": responseBody['current_page'],
      "products": lstProducts,
    };
  }
}

///responseBody:{data:{data:[
///                         {Product}
///                         {Product}
///                         {Product}
///                         ...
///                         ]
///                    current_page:
///                    .
///                    .
///                    .
///                   }
///               status:
///             }
