import 'package:sqflite/sqflite.dart';
import 'package:whatsapp/models/User.dart';
import 'package:whatsapp/sqfliteProvider/Povider.dart';

class UserProvider extends Provider {
  String tableName = 'users';

  Future<int> insert(User user) async {
    int insertId = await db.insert(tableName, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return insertId;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> map = await db.query(tableName,
        columns: ['id', 'api_token'], where: 'id=?', whereArgs: [id]);

    if (map.length > 0) return new User.fromJson(map.first);

    return null;
  }

  Future<int> delete(int id) async {
    int result = await db.delete(tableName, where: 'id=?', whereArgs: [id]);
    return result;
  }

  Future<int> update(User user) async {
    return await db
        .update(tableName, user.toMap(), where: 'id=?', whereArgs: [user.id]);
  }
}
