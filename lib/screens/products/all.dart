import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
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
    if (widget.category == null) {
      _companyProducts = fetchProductsOfSnack();
    } else {
      _companyProducts = fetchProductsOfCategory(widget.category.id);
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

  _filterData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: myHeight(context) / 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Trier par',
                  style: TextStyle(fontSize: myHeight(context) / 40.0)),
              SizedBox(
                height: myHeight(context) / 50.0,
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Nom',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Quantite',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Prix',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Date',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              Divider(
                thickness: 2.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _companyProducts = fetchProductsOfSnack();
                  });
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  leading: Icon(AmazingIcon.refresh_line),
                  title: Text('Actualiser',
                      style: TextStyle(
                          fontSize: myHeight(context) / 40.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: backgroundColor,
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: myHeight(context) / 30.0,
                        vertical: myHeight(context) / 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'img/logos/LogoWithText.png',
                          width: myHeight(context) / 5.2,
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: myHeight(context) / 50.0),
                          child: Icon(
                            AmazingIcon.search_2_line,
                            size: myHeight(context) / 30.0,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: textInverseModeColor.withOpacity(.12), shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '${user.name.substring(0, 2).toUpperCase()}',
                              style:
                                  TextStyle(fontSize: myHeight(context) / 45.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: myHeight(context) / 30.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back)),
                        SizedBox(
                          width: myHeight(context) / 40.0,
                        ),
                        Text(
                          'Produits',
                          style: TextStyle(
                              fontSize: myHeight(context) / 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () => _filterData(),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                AmazingIcon.list_settings_fill,
                                size: myHeight(context) / 30.0,
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 40.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: myHeight(context) / 60.0),
                    width: myWidth(context),
                    height: myHeight(context) * .78,
                    child: FutureBuilder(
                        future: _companyProducts,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            _products = _fieldValues(snapshot.data);
                            return _products == null || _products.length == 0
                                ? Center(
                                    child: Text('Aucun produit'),
                                  )
                                : ListView.builder(
                                    itemCount: _products.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                              height: myHeight(context) / 5.7,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  border: Border.all(
                                                      color: textInverseModeColor
                                                          .withOpacity(.05))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: screenSize(
                                                                        context)
                                                                    .width /
                                                                80),
                                                        child: InkWell(
                                                          child: Text(
                                                            '${_products[index].name}',
                                                            style: TextStyle(
                                                                fontSize: screenSize(
                                                                            context)
                                                                        .height /
                                                                    30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  '${_products[index].qty}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          38.0),
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    '  EN STOCK',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xffbA2A2A2),
                                                                    fontSize: screenSize(context)
                                                                            .height /
                                                                        42.0)),
                                                          ])),
                                                      RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  '${_products[index].price}',
                                                              style: TextStyle(
                                                                  color:
                                                                      gradient1,
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          38.0),
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    '  A LA VENTE',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xffbA2A2A2),
                                                                    fontSize: screenSize(context)
                                                                            .height /
                                                                        42.0)),
                                                          ])),
                                                    ],
                                                  ),
                                                ),
                                              )));
                                    });
                          }
                          return Container(
                            height: myHeight(context) * .86,
                            color: Colors.transparent,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    new AlwaysStoppedAnimation(gradient1),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              _isLoading
                  ? Container(
                      height: myHeight(context),
                      color: textSameModeColor.withOpacity(.9),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation(gradient1),
                        ),
                      ),
                    )
                  : Container(
                      height: 0.0,
                    )
            ],
          ),
        ));
  }
}
