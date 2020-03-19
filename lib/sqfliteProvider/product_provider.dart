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
    //we don't use foreach because it's not Future
    //but map is of type Future
    //and we need it because the work being done will take time
    await Future.wait(lstProducts.map((product) async {
      await this.insert(product);
    }));
  }
}
