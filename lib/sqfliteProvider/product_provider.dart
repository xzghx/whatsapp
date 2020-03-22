import 'package:sqflite/sqflite.dart';
import 'package:whatsapp/models/Product.dart';
import 'package:whatsapp/sqfliteProvider/Povider.dart';

class ProductProvider extends Provider {
  String tableName = 'products';

  Future<Product> insert(Product product,
      {conflictAlgorithm: ConflictAlgorithm.ignore}) async {
    product.id = await db.insert(tableName, product.toMap(),
        conflictAlgorithm: conflictAlgorithm);
    return product;
  }

  Future<bool> insertAll(List<Product> lstProducts) async {
    /*
//this is bad way  according to https://flutter-academy.com/async-in-flutter-advanced-futures-api/
        Future.forEach(lstProducts, (product) async {
      await db.insert(product);
    });
    */

    //we don't use foreach because it's not Future
    //but map is of type Future
    //and we need it because the work being done will take time
    await Future.wait(lstProducts.map((product) async {
      await this.insert(product);
    }));
    return true;
  }

  //
  /// get each page Products
  /// /
  Future<List<Product>> paginate(int page, {int limit: 8}) async {
    //read each page from db and return
    List<Map<String, dynamic>> maps = await db.query(tableName,
        columns: ["id", "user_id", "title", "body", "image"],
        limit: limit,
        offset: page == 1 ? 0 : ((page - 1) * limit));

    if (maps.length > 0) {
      List<Product> lst = [];
      maps.forEach((product) {
        if (product != null) lst.add(new Product.fromJson(product));
      });

      return lst;
    }
    return null;
  }
}
