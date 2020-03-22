class User {
  int id;
  String apiToken;

  User.fromJson(Map<String, dynamic> mapUserInfo) {
    id = mapUserInfo['user_id'];
    apiToken = mapUserInfo['api_token'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'api_Token': apiToken};
  }
}
