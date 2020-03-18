import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/models/Product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({@required this.product});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        margin: EdgeInsets.only(left: 5, right: 5, bottom: 8),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            //back ground image
            Container(
              width: screenSize.width,
              height: 200,
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: product.image,
                  placeholder: (context, url) {
                    return Image(
                      image: AssetImage("assets/images/placeholder-image.png"),
                      fit: BoxFit.cover,
                    );
                  }),
            ),
            //bottom layer
            Container(
                alignment: Alignment.centerRight,
                height: 60,
                decoration: BoxDecoration(color: Colors.black45),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //product title
                      Text(
                        product.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Vazir"),
                      ),
                      //product description
                      RichText(
                        maxLines: 1,
                          text: TextSpan(
                        text: product.body,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Vazir"),
                      ))
                    ],
                  ),
                ))
          ],
        ));
  }
}
