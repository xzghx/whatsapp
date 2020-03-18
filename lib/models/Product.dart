class Product {
  int id;
  int userId;
  String title;
  String body;
  String image;
  String price;
  DateTime createdAt;
  DateTime updatedAt;

  //this is called namedConstructor
  //we can give name to each constructor ☺ like Product.myName1(String s) , Product.myName2(int i) ...
  Product.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    userId = parsedJson['userId'];
    title = parsedJson['title'];
    body = parsedJson['body'];
    image = parsedJson['image'];
    price = parsedJson['price'];
    createdAt = parsedJson['createdAt'];
    updatedAt = parsedJson['updatedAt'];
  }
}
