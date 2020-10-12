import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/category.dart';
import 'package:easytrack/screens/products/all.dart';
import 'package:easytrack/screens/purchases/all.dart';
import 'package:easytrack/screens/sales/all.dart';
import 'package:easytrack/screens/sales/manage.dart';
import 'package:easytrack/services/categoryService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  Future _futureCategories;
  List _categories;

  @override
  void initState() {
    super.initState();
    _futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header2(context, user.isAdmin == 1 ? 'Mon Site' : 'Mon Snack', (){}),
                SizedBox(
                  height: 10.0,
                ),
                FutureBuilder(
                  future: _futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.hasData) {
                      if (snapshot.data != null) {
                        _categories = snapshot.data
                            .map((cat) => Category.fromJson(cat))
                            .toList();
                        _categories.insert(
                            0, Category(id: 0, name: 'Produits'));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Categories',
                              style: TextStyle(
                                  fontSize: myHeight(context) / 40.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              decoration: BoxDecoration(),
                              height: myHeight(context) / 23.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: index == _categories.length - 1
                                            ? 0.0
                                            : myHeight(context) / 40),
                                    child: GestureDetector(
                                      onTap: () => index == 0
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductPage()))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductPage(
                                                        category:
                                                            _categories[index],
                                                      ))),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: gradient2.withOpacity(.2),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: myHeight(context) / 40,
                                          ),
                                          child: index == 0
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(
                                                      AmazingIcon.archive_line,
                                                      size: myHeight(context) /
                                                          40.0,
                                                      color: gradient1,
                                                    ),
                                                    SizedBox(
                                                      width: myHeight(context) /
                                                          65.0,
                                                    ),
                                                    Text(
                                                      '${_categories[index].name}',
                                                      style: TextStyle(
                                                          fontSize: myHeight(
                                                                  context) /
                                                              50.0,
                                                          color: gradient1,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  '${_categories[index].name}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          myHeight(context) /
                                                              50.0,
                                                      color: gradient1,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            Container(
                              height: myHeight(context) / 3.5,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    height: myHeight(context) / 4.5,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: gradient1,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(
                                                  text: allSales == null
                                                      ? '0'
                                                      : '${formatPrice(allSales)}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          myHeight(context) /
                                                              20.0),
                                                  children: [
                                                TextSpan(
                                                    text: ' Ventes',
                                                    style: TextStyle(
                                                        fontSize:
                                                            myHeight(context) /
                                                                30.0)),
                                                TextSpan(
                                                    text:
                                                        '\n${months[DateTime.now().month - 1]} ${DateTime.now().year}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            myHeight(context) /
                                                                45.0,
                                                        color: Colors.white38))
                                              ])),
                                          SizedBox(
                                              height:
                                                  myHeight(context) / 100.0),
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SalePage())),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Voir toutes les ventes',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        myHeight(context) /
                                                            45.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      myHeight(context) / 100.0,
                                                ),
                                                Icon(
                                                  AmazingIcon
                                                      .arrow_right_s_line,
                                                  color: Colors.white,
                                                  size:
                                                      myHeight(context) / 35.0,
                                                )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ManageSales())),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Gerer les ventes',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        myHeight(context) /
                                                            45.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      myHeight(context) / 100.0,
                                                ),
                                                Icon(
                                                  AmazingIcon
                                                      .arrow_right_s_line,
                                                  color: Colors.white,
                                                  size:
                                                      myHeight(context) / 35.0,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    child: Container(
                                      height: myHeight(context) / 3.5,
                                      child: Image.asset(
                                        'img/boy.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 50.0,
                            ),
                            Container(
                              height: myHeight(context) / 3.8,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
                                    height: myHeight(context) / 5.2,
                                    decoration: BoxDecoration(
                                        color: textInverseModeColor
                                            .withOpacity(.12),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Spacer(),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                RichText(
                                                    text: TextSpan(
                                                        text: allPurchases ==
                                                                null
                                                            ? "0"
                                                            : '${formatPrice(allPurchases)}',
                                                        style: TextStyle(
                                                            color: gradient1,
                                                            fontSize: myHeight(
                                                                    context) /
                                                                20.0),
                                                        children: [
                                                      TextSpan(
                                                          text: ' Achats',
                                                          style: TextStyle(
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  30.0)),
                                                      TextSpan(
                                                          text:
                                                              '\n${months[DateTime.now().month - 1]} ${DateTime.now().year}',
                                                          style: TextStyle(
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  45.0,
                                                              color: Colors
                                                                  .black38))
                                                    ])),
                                                GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PurchasePage())),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Voir tous les achats',
                                                        style: TextStyle(
                                                          color:
                                                              textInverseModeColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              45.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            myHeight(context) /
                                                                100.0,
                                                      ),
                                                      Icon(
                                                        AmazingIcon
                                                            .arrow_right_s_line,
                                                        color:
                                                            textInverseModeColor,
                                                        size:
                                                            myHeight(context) /
                                                                35.0,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0.0,
                                    bottom: 0.0,
                                    child: Container(
                                      height: myHeight(context) / 4,
                                      child: Image.asset(
                                        'img/girl.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          height: myHeight(context) * .8,
                          child: Center(
                            child: Text(
                                'Une erreur est survenue. Veuillez reessayer plutard.'),
                          ),
                        );
                      }
                    }
                    return Container(
                      height: myHeight(context) * .8,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(gradient1),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
