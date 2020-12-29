import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/models/category.dart';
import 'package:easytrack/models/product.dart';
import 'package:easytrack/services/productService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final Category category;

  const ProductPage({Key key, this.category}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future _companyProducts;
  List _products;
  bool _isLoading;

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _companyProducts = fetchProductsOfCategory(widget.category.id);
    } else {
      _products = _fieldValues(globalProducts);
    }
    _scaffoldKey = GlobalKey();
    _isLoading = false;
  }

  List _fieldValues(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var product in datas) {
        if (!result.contains(Product.fromJson(product))) {
          result.add(Product.fromJson(product));
        }
      }
    } else {
      for (var site in datas) {
        for (var product in site['products']) {
          if (!result.contains(Product.fromJson(product))) {
            result.add(Product.fromJson(product));
          }
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
            backgroundColor: backgroundColor,
            key: _scaffoldKey,
            body: Stack(
              children: [
                widget.category == null
                    ? CustomScrollView(
                        slivers: [
                          sliverHeader(
                              context,
                              'Gestion',
                              widget.category == null
                                  ? 'Produits'
                                  : widget.category.name,
                              2,
                              canAdd: false,
                              onClick: () {}),
                          _products == null || _products.length == 0
                              ? SliverList(
                                  delegate: SliverChildListDelegate.fixed([
                                    Container(
                                      height: myHeight(context) / 1.5,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Aucun produit',
                                        style: TextStyle(
                                            fontSize: myHeight(context) / 50.0),
                                      ),
                                    )
                                  ]),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: index == 0
                                                ? myHeight(context) / 50.0
                                                : myHeight(context) / 100.0,
                                            horizontal:
                                                myHeight(context) / 40.0),
                                        child: Container(
                                            height: myHeight(context) / 6.5,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        myHeight(context) /
                                                            70.0)),
                                                border: Border.all(
                                                    color: Colors.black12)),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  myHeight(context) / 60.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width:
                                                            myWidth(context) /
                                                                1.4,
                                                        child: Text(
                                                          '${_products[index].name}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: screenSize(
                                                                          context)
                                                                      .height /
                                                                  35,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width:
                                                        myWidth(context) / 1.3,
                                                    child: Text(
                                                      '${_products[index].qty} EN STOCK',
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: screenSize(
                                                                      context)
                                                                  .height /
                                                              42.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        myWidth(context) / 1.3,
                                                    child: Text(
                                                      '${_products[index].price} XAF  A LA VENTE',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: screenSize(
                                                                      context)
                                                                  .height /
                                                              42.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )));
                                  }, childCount: _products.length),
                                )
                        ],
                      )
                    : FutureBuilder(
                        future: _companyProducts,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            _products = _fieldValues(snapshot.data);
                            return CustomScrollView(
                              slivers: [
                                sliverHeader(
                                    context,
                                    'Gestion',
                                    widget.category == null
                                        ? 'Produits'
                                        : widget.category.name,
                                    2,
                                    canAdd: false,
                                    onClick: () {}),
                                _products == null || _products.length == 0
                                    ? SliverList(
                                        delegate:
                                            SliverChildListDelegate.fixed([
                                          Container(
                                            height: myHeight(context) / 1.5,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Aucun produit',
                                              style: TextStyle(
                                                  fontSize:
                                                      myHeight(context) / 50.0),
                                            ),
                                          )
                                        ]),
                                      )
                                    : SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                          return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: index == 0
                                                      ? myHeight(context) / 50.0
                                                      : myHeight(context) /
                                                          100.0,
                                                  horizontal:
                                                      myHeight(context) / 40.0),
                                              child: Container(
                                                  height:
                                                      myHeight(context) / 6.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              myHeight(context) /
                                                                  70.0)),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black12)),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        myHeight(context) /
                                                            60.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              width: myWidth(
                                                                      context) /
                                                                  1.4,
                                                              child: Text(
                                                                '${_products[index].name}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenSize(context).height /
                                                                            35,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          width:
                                                              myWidth(context) /
                                                                  1.3,
                                                          child: Text(
                                                            '${_products[index].qty} EN STOCK',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: screenSize(
                                                                            context)
                                                                        .height /
                                                                    42.0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              myWidth(context) /
                                                                  1.3,
                                                          child: Text(
                                                            '${_products[index].price} XAF  A LA VENTE',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: screenSize(
                                                                            context)
                                                                        .height /
                                                                    42.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )));
                                        }, childCount: _products.length),
                                      )
                              ],
                            );
                          }
                          return Stack(
                            children: [
                              CustomScrollView(
                                slivers: [
                                  sliverHeader(
                                      context,
                                      'Gestion',
                                      widget.category == null
                                          ? 'Produits'
                                          : widget.category.name,
                                      2,
                                      canAdd: false,
                                      onClick: () {}),
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(gradient1),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                _isLoading
                    ? Container(
                        width: myWidth(context),
                        height: myHeight(context),
                        color: textSameModeColor.withOpacity(.89),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(gradient1),
                          ),
                        ))
                    : Container(),
              ],
            )));
  }
}
