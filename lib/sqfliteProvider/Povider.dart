import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Provider {
  Database db;
  String _path;

  Future open({String dbName: "whatsapp.db"}) async {
    String databasesPath = await getDatabasesPath();
    _path = join(databasesPath, dbName);

    db = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
                  create table products ( 
                      id integer primary key autoincrement, 
                      user_id integer not null,
                      title text not null,
                      body  text  not null,
                      image text not null,
                      price text not null,
                      created_at text not null,
                      updated_at text not null)
                   ''');

      await db.execute('''
                  create table users ( 
                      id integer primary key autoincrement, 
                      api_token text not null)
                  ''');
    });
  }

  Future close() => db.close();
}
