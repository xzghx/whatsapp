import 'package:whatsapp/models/User.dart';
import 'package:whatsapp/sqfliteProvider/user_provider.dart';

class UserService {
  //insert user in sqlite
  static Future<bool> storeUser(Map<String, dynamic> user) async {
    try {
      var db = new UserProvider();
      await db.open();
      await db.insert(new User.fromJson(user));
      await db.close();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //getUser user from sqlite
  static Future<User> getUser(int id) async {
    try {
      var db = new UserProvider();
      await db.open();
      User u = await db.getUser(id);
      await db.close();

      return u;
    } catch (e) {
      return null;
    }
  }
}
