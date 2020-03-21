import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whatsapp/helper.dart';
import 'package:whatsapp/models/Product.dart';
import 'package:whatsapp/sqfliteProvider/product_provider.dart';

class ProductService {
  static Future<Map> getProducts(int page) async {
    if (await checkInternetConnection())
      return await _getAllProductsFromNetwork(page);
    else
      return await _getAllProductsFromSqlite(page);
  }

  static Future<Map> _getAllProductsFromNetwork(int page) async {
    var response = await http.get("http://roocket.org/api/products?page=$page");

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body)['data'];

      List<Product> lstProducts = [];
      responseBody['data'].forEach((item) {
        //each item has Product fields but it's a map not a Product instance
        lstProducts.add(Product.fromJson(item));
      });
      //after getting all Products from server , save them in local sqlite
      await _saveAllProductsIntoSqlite(lstProducts);

      return {
        "current_page": responseBody['current_page'],
        "products": lstProducts,
      };
    }
    return null;
  }

  static Future _saveAllProductsIntoSqlite(List<Product> lstProducts) async {
    var db = new ProductProvider();
    await db.open();

    await db.insertAll(lstProducts);

    await db.close();
  }

  static Future<Map> _getAllProductsFromSqlite(int page) async {
    var db = new ProductProvider();
    await db.open();
    List<Product> products = await db.paginate(page);
    await db.close();
    return {"current_page": page, "products": products};
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
///                    some other  fields
///                    .
///                    .
///                    .
///                   }
///               status:
///             }
