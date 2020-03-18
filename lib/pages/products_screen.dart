import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/components/ProductCard.dart';
import 'package:whatsapp/models/Product.dart';
import 'package:whatsapp/services/ProductService.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  //when switching between tabs ,when you coma back to product tab ,you will see that it's again downloading
  //the list. so to avoid re downloading just use " with AutomaticKeepAliveClientMixin"in this state
  //and return true in overridden method
  @override
  bool get wantKeepAlive => true;
  List<Product> _lstProducts = [];
  int _currentPage = 1;
  bool _viewStream = true;
  bool _isLoading = true;

  //to implement Infinitive Scroll
  ScrollController _listScrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _listScrollController.addListener(() {
      //first: get total scroll length
      double maxScroll = _listScrollController.position.maxScrollExtent;
      double currentPosition = _listScrollController.position.pixels;
      if (maxScroll - currentPosition < 200) {
        if (!_isLoading) getProducts(page: _currentPage + 1);
      }
    });
    getProducts();
  }

  getProducts({int page = 1, bool refresh: false}) async {
    setState(() {
      _isLoading = true;
    });

    //response is a map: {products:[{p1},{p2},.. ]    current_page: }
    Map response = await ProductService.getProducts(page);
    _lstProducts.addAll(response['products']);

    setState(() {
      if (refresh) _lstProducts.clear();
      _lstProducts.addAll(response['products']);
      _currentPage = response['current_page'];
      _isLoading = false;
    });
  }

  Widget viewLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget emptyList() {
    return Center(
      child: Text("محصولی برای نمایش وجود ندارد."),
    );
  }

  Future<void> refreshHandle() async {
    await getProducts(refresh: true);
//    return null;
  }

  Widget streamListView() {
    return _lstProducts.length == 0 && _isLoading
        ? viewLoading()
        : _lstProducts.length == 0
            ? emptyList()
            : RefreshIndicator(
                onRefresh: refreshHandle,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: _lstProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: _lstProducts[index],
                      );
                    }),
              );
  }

  Widget moduleListView() {
    return RefreshIndicator(
      onRefresh: refreshHandle,
      child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          padding: EdgeInsets.only(top: 0),
          itemBuilder: (context, index) {
            return ProductCard(
              product: _lstProducts[index],
            );
          },
          itemCount: _lstProducts.length),
    );
  }

  Widget headList() {
    return SliverAppBar(
      primary: false,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        GestureDetector(
          child: new Icon(
            Icons.view_module,
            color: _viewStream ? Colors.grey[500] : Colors.grey[900],
          ),
          onTap: () {
            setState(() {
              _viewStream = false;
            });
          },
        ),
        GestureDetector(
          child: new Icon(
            Icons.view_stream,
            color: _viewStream ? Colors.grey[900] : Colors.grey[500],
          ),
          onTap: () {
            setState(() {
              _viewStream = true;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _listScrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return _lstProducts.length != 0
            ? <Widget>[
                //header showing in top of list with two buttons switching between  module and stream mode
                headList()
              ]
            : [];
      },
      body: _viewStream ? streamListView() : moduleListView(),
    );
  }
}
