import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  Future<Map> checkLogin(Map body) async {
    final response = await http
        .post('http://roocket.org/api/login', body: body);

//    final response = await http
//        .post("http://10.0.3.2:80/testFlutterApi/checkUser.php", body: body);
    //response :{ status:"status"   data:{api_key:     user_id:}   }
    var responseDecoded = json.decode(response.body);

    return responseDecoded;
  }

  static Future<bool> checkUserApi(String userToken) async {
    final result = await http.get(
        "http://roocket.org/api/user?api_token=$userToken",
        headers: {'Accept': 'application/json'});

    return result.statusCode == 200;
    //200-->ok successful
    //401-->Unauthorized
    //403-->forbidden
  }
}
