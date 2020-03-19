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
}
