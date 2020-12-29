import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/gradientIcon.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/customer_with_id.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/notifications/all.dart';
import 'package:easytrack/screens/purchases/all.dart';
import 'package:easytrack/screens/sales/add.dart';
import 'package:easytrack/screens/sales/manage.dart';
import 'package:easytrack/screens/site/all.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/services/homerService.dart';
import 'package:flutter/material.dart';
import '../../../styles/style.dart';

class StatsAdminPage extends StatefulWidget {
  @override
  _StatsAdminPageState createState() => _StatsAdminPageState();
}

class _StatsAdminPageState extends State<StatsAdminPage>
    with SingleTickerProviderStateMixin {
  bool searchMode;
  bool _isLoading;
  Future stats;
  OverlayEntry _overlayEntry;
  int _indexOfCurrentCard;

  bool showAll = true;
  List _sales, _customers, _productsOnSales;
  List allSalesData;
  AnimationController controller;
  CurvedAnimation curvedAnimation;
  Animation<Offset> _translationAnim;
  Animation<double> _scaleAnim;
  Animation<Offset> _moveAnim;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List list;
  @override
  void initState() {
    super.initState();
    stats = fetchStats();
    searchMode = false;
    _indexOfCurrentCard = 0;
    _isLoading = false;
    _customers = [];
    _productsOnSales = [];
    _sales = [];
    _indexOfCurrentCard = 0;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    _translationAnim = Tween(begin: Offset(0.0, 0.0), end: Offset(-1000.0, 0.0))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });
    _scaleAnim = Tween(begin: 0.965, end: 1.0).animate(curvedAnimation);
    _moveAnim = Tween(begin: Offset(0.0, 0.05), end: Offset(0.0, 0.0))
        .animate(curvedAnimation);
    list = [
      StatCards(
        index: 1,
        parentContext: context,
        scaffoldKey: _scaffoldKey,
        name: 'VENTES',
      ),
      StatCards(
        index: 2,
        parentContext: context,
        scaffoldKey: _scaffoldKey,
        name: 'ACHATS GLOBAUX',
      ),
      StatCards(
        index: 3,
        parentContext: context,
        scaffoldKey: _scaffoldKey,
        name: 'BENEFICE GLOBAL',
      ),
    ];
    _loadStats(globalStats);
    allSalesData = globalSales;
    _sales = _checkAllSales(allSalesData).toList();
  }

  OverlayEntry _overlaySales;

  _showSalesMenu() {
    setState(() {
      this._overlaySales = this._createOverlayEntrySalesMenu();
      Overlay.of(context).insert(this._overlaySales);
    });
  }

  _showAbonnement() {
    this._overlayEntry.remove();
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: myHeight(context) / 30,
                horizontal: myHeight(context) / 25),
            height: myHeight(context) * .65,
            width: myWidth(context) * .9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: myWidth(context) / 1.5,
                      child: Text(
                        'Mon Abonnement',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: myHeight(context) / 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(AmazingIcon.close_line))
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Row(
                  children: [
                    Icon(AmazingIcon.secure_payment_line, color: gradient1),
                    SizedBox(
                      width: myHeight(context) / 40.0,
                    ),
                    Container(
                        width: myWidth(context) / 2,
                        child: Text(
                          'Version d\'essaie',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: myHeight(context) / 40.0),
                        ))
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Text('Nov 02, 2020 / Jan 31, 2021'),
                SizedBox(
                  height: myHeight(context) / 60.0,
                ),
                LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Color(0xffEEEEEE),
                    minHeight: 5,
                    valueColor: AlwaysStoppedAnimation(gradient1)),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                OutlineButton(
                    onPressed: () => launchURL(url: websiteUrl),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: gradient1),
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 70)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: myHeight(context) / 70.0),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Payer une nouvelle licence',
                        style: TextStyle(
                            color: gradient1,
                            fontSize: myHeight(context) / 48.0),
                      ),
                    )),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Text('Historique',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: myHeight(context) / 40.0)),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: myHeight(context) / 100.0),
                  decoration: BoxDecoration(
                      color: Color(0xffEEEEEE).withOpacity(.6),
                      border:
                          Border(bottom: BorderSide(color: Colors.black54))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Abonnement',
                            style:
                                TextStyle(fontSize: myHeight(context) / 47.0),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        width: myWidth(context) / 6,
                        child: Text('Prix',
                            style:
                                TextStyle(fontSize: myHeight(context) / 47.0),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        width: myWidth(context) / 5,
                        child: Text('Date',
                            style:
                                TextStyle(fontSize: myHeight(context) / 47.0),
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Version d\'essaie',
                        style: TextStyle(fontSize: myHeight(context) / 51.0),
                      ),
                    ),
                    Container(
                      width: myWidth(context) / 6,
                      child: Text('0 XFA',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    ),
                    Container(
                      width: myWidth(context) / 5,
                      child: Text('15 Aout 2020',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    )
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text('Silver',
                            style:
                                TextStyle(fontSize: myHeight(context) / 51.0))),
                    Container(
                        width: myWidth(context) / 6,
                        child: Text('30000 XFA',
                            style:
                                TextStyle(fontSize: myHeight(context) / 51.0))),
                    Container(
                      width: myWidth(context) / 5,
                      child: Text('20 Septembre 2020',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    )
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Gold',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    ),
                    Container(
                      width: myWidth(context) / 6,
                      child: Text('50000 XFA',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    ),
                    Container(
                      width: myWidth(context) / 5,
                      child: Text('30 Octobre 2020',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  OverlayEntry _createOverlayEntrySalesMenu() {
    return OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0.0,
            height: myHeight(context),
            width: myWidth(context),
            child: Material(
              color: Colors.black38,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => this._overlaySales.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      height: myHeight(context) * .18,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(myHeight(context) / 70.0))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth(context) / 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: myWidth(context) / 7,
                                  height: myHeight(context) / 150.0,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(
                                          myHeight(context) / 100.0))),
                            ),
                            SizedBox(
                              height: myHeight(context) / 60,
                            ),
                            InkWell(
                              onTap: () {
                                this._overlaySales.remove();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddSalesPage()));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: myHeight(context) / 100.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      AmazingIcon.shopping_bag_3_line,
                                      size: myHeight(context) / 30.0,
                                      color: gradient1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: myHeight(context) / 25.0),
                                      child: Text(
                                        'Commande client',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: myHeight(context) / 40.0,
                                            color: textInverseModeColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                this._overlaySales.remove();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PurchasePage()));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: myHeight(context) / 100.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      size: myHeight(context) / 30.0,
                                      color: gradient1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: myHeight(context) / 25.0),
                                      child: Text(
                                        'Commande fournisseur',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: myHeight(context) / 40.0,
                                            color: textInverseModeColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }

  //Show Main Menu
  _show() {
    setState(() {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry);
    });
  }

  //Create Menu
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0.0,
            height: myHeight(context),
            width: myWidth(context),
            child: Material(
              color: Colors.black38,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => this._overlayEntry.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      height: myHeight(context) * .8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(myHeight(context) / 70.0))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth(context) / 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: myWidth(context) / 7,
                                  height: myHeight(context) / 150.0,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(
                                          myHeight(context) / 100.0))),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff267FC9),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        myHeight(context) / 50.0),
                                    child: Text(
                                      '${user.name.substring(0, 2).toUpperCase()}',
                                      style: TextStyle(
                                          color: textSameModeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: myHeight(context) / 50.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: myWidth(context) / 20.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${capitalize(user.name)}',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: myHeight(context) / 40.0),
                                    ),
                                    Text(
                                      '${capitalize(company.name.toLowerCase())} (${capitalize(userRole["name"])})',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.38),
                                          fontSize: myHeight(context) / 60.0),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: myHeight(context) / 20.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                this._overlayEntry.remove();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationsPage()));
                              },
                              child: Row(
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      Icon(
                                        AmazingIcon.notification_4_line,
                                        color: textInverseModeColor,
                                        size: myHeight(context) / 35.0,
                                      ),
                                      Positioned(
                                        top: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          width: myHeight(context) / 100.0,
                                          height: myHeight(context) / 100.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                this._overlayEntry.remove();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SitePage()));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.building_2_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Mes sites',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.bar_chart_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Rapports',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.settings_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Configurations',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: _showAbonnement,
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.money_dollar_circle_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Abonnement',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 20.0,
                            ),
                            Text(
                              'MENU',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.45),
                                  fontWeight: FontWeight.w500,
                                  fontSize: myHeight(context) / 45.0),
                            ),
                            SizedBox(
                              height: myHeight(context) / 35.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Politique de confidentialite',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Termes et conditions',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'A Propos',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Aide',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: myHeight(context) / 60.0),
                              child: GestureDetector(
                                onTap: () {
                                  this._overlayEntry.remove();
                                  _logoutUser();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      AmazingIcon.logout_box_line,
                                      color: textInverseModeColor,
                                      size: myHeight(context) / 30.0,
                                    ),
                                    SizedBox(
                                      width: myWidth(context) / 10.0,
                                    ),
                                    Text(
                                      'Deconnexion',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: myHeight(context) / 40.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }

  //Load Sales
  List _checkAllSales(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var sale in datas) {
        _productsOnSales.add(sale['products']);

        _customers.add(CustomerWithId.fromJson(sale['customer']));

        result.add(sale);
      }
    } else {
      for (var site in datas) {
        for (var sale in site['sales']) {
          if (!result.contains(sale)) {
            _productsOnSales.add(sale['products']);
            /* 
            _customers.add(Customer.fromJson(sale['customer'])); */

            result.add(sale);
          }
        }
      }
    }
    return result;
  }

  //Load Stats Data
  _loadStats(datas) {
    if (user.isAdmin == 1) {
      allSales = datas['allSales'];
      allPurchases = datas['allPurchases'];
      allIncomes = datas['allIncomes'];
      dailySales = datas['dailySales'];
      dailyPurchases = datas['dailyPurchases'];
      dailyIncomes = datas['dailyIncome'];
    } else {
      allSales = 0;
      allPurchases = 0;
      dailySales = 0;
      dailyPurchases = 0;
      allIncomes = 0;
      dailyIncomes = 0;

      for (var data in datas) {
        allSales += data['allSales'];
        allPurchases += data['allPurchases'];
        allIncomes += data['allIncomes'];
        dailySales += data['dailySales'];
        dailyPurchases += data['dailyPurchases'];
        dailyIncomes += data['dailyIncome'];
      }
    }
  }

  //Log user out
  _logoutUser() async {
    setState(() {
      _isLoading = true;
    });
    await logout().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

//Animation on Card
  Offset _getStackedCardOffset(StatCards card) {
    int diff = card.index - _indexOfCurrentCard;
    if (card.index == _indexOfCurrentCard + 1) {
      return _moveAnim.value;
    } else if (diff > 0 && diff <= 2) {
      return Offset(0.0, -0.005 * diff);
    } else {
      return Offset(0.0, 0.0);
    }
  }

  double _getStackedCardScale(StatCards card) {
    int diff = card.index - _indexOfCurrentCard;
    if (card.index == _indexOfCurrentCard) {
      return 1.0;
    } else if (card.index == _indexOfCurrentCard + 1) {
      return _scaleAnim.value;
    } else {
      return (1 - (0.035 * diff.abs()));
    }
  }

  Offset _getFlickTransformOffset(StatCards card) {
    if (card.index == _indexOfCurrentCard) {
      return _translationAnim.value;
    }
    return Offset(0.0, 0.0);
  }

  void _horizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity < 0) {
      controller.forward().whenComplete(() {
        setState(() {
          controller.reset();
          StatCards removedCard = list.removeAt(0);
          list.add(removedCard);
          _indexOfCurrentCard = list[0].index;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showSalesMenu(),
          backgroundColor: Colors.white,
          child: GradientIcon(
            Icons.add,
            myHeight(context) / 22,
            LinearGradient(
                colors: [gradient1, gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  header(context, _show, 0),
                  SizedBox(
                    height: myHeight(context) / 30,
                  ),
                  Stack(
                      overflow: Overflow.visible,
                      children: list.reversed.map((card) {
                        if (list.indexOf(card) <= 2) {
                          return GestureDetector(
                            onHorizontalDragEnd: _horizontalDragEnd,
                            child: Transform.translate(
                              offset: _getFlickTransformOffset(card),
                              child: FractionalTranslation(
                                translation: _getStackedCardOffset(card),
                                child: Transform.scale(
                                    scale: _getStackedCardScale(card),
                                    child: card),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList()),
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: myHeight(context) / 30.0),
                    child: Text(
                      'Commandes recentes',
                      style: mainPartTitleStyle,
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 60.0,
                  ),
                  Expanded(
                      child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('sales')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: myHeight(context) / 30.0),
                            child: _sales == null || _sales.length == 0
                                ? Center(child: Text('Aucune commande recente'))
                                : ListView.builder(
                                    itemCount:
                                        _sales.length > 10 ? 10 : _sales.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ManageSales(),
                                              )),
                                          child: Container(
                                              height: myHeight(context) / 6.4,
                                              margin: EdgeInsets.symmetric(
                                                vertical:
                                                    myWidth(context) / 50.0,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          myHeight(context) /
                                                              90.0)),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Colors.black
                                                          .withOpacity(.1))),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        myWidth(context) / 30.0,
                                                    vertical:
                                                        myHeight(context) /
                                                            70.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'S0-${_sales[index]["code"]}',
                                                          style: TextStyle(
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  33.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Spacer(),
                                                        Icon(
                                                          Icons.more_vert,
                                                          size:
                                                              myWidth(context) /
                                                                  16.0,
                                                        )
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            top: myHeight(
                                                                    context) /
                                                                62),
                                                        alignment:
                                                            Alignment.center,
                                                        child: ListView.builder(
                                                            physics: null,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: _productsOnSales[
                                                                            index]
                                                                        .length >
                                                                    1
                                                                ? 1
                                                                : _productsOnSales[
                                                                        index]
                                                                    .length,
                                                            itemBuilder:
                                                                (context, ind) {
                                                              return Text(
                                                                _productsOnSales[index]
                                                                            .length >
                                                                        1
                                                                    ? '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}...'
                                                                    : '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: textInverseModeColor
                                                                        .withOpacity(
                                                                            .54),
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            45.0),
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: myHeight(
                                                                  context) /
                                                              200.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            _sales[index][
                                                                        "status"] ==
                                                                    2
                                                                ? 'Paye'
                                                                : _sales[index][
                                                                            "status"] ==
                                                                        1
                                                                    ? 'Servie'
                                                                    : 'En attente',
                                                            style: TextStyle(
                                                                color: _sales[index]
                                                                            [
                                                                            "status"] ==
                                                                        2
                                                                    ? Colors
                                                                        .green
                                                                    : _sales[index]["status"] ==
                                                                            1
                                                                        ? Colors
                                                                            .orange
                                                                        : gradient1,
                                                                fontSize: screenSize(
                                                                            context)
                                                                        .height /
                                                                    53.0),
                                                          ),
                                                          Spacer(),
                                                           Text(
                                                            '${formatDate(DateTime.parse(_sales[index]["created_at"]))}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black26,
                                                                fontSize:
                                                                    screenSize(context)
                                                                            .height /
                                                                        60.0),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )));
                                    },
                                  ));
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(gradient1),
                      ));
                    },
                  ))
                ],
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
          ),
        ));
  }
}

class StatCards extends StatefulWidget {
  final int index;
  final String name;
  final GlobalKey scaffoldKey;
  final BuildContext parentContext;
  const StatCards({
    @required this.index,
    Key key,
    @required this.parentContext,
    @required this.scaffoldKey,
    this.name,
  }) : super(key: key);

  @override
  _StatsCardsState createState() => _StatsCardsState();
}

class _StatsCardsState extends State<StatCards> {
  OverlayEntry _overlay;

  _show(_key, index) {
    setState(() {
      this._overlay = this._createOverlayEntry(_key, index);
      Overlay.of(context).insert(this._overlay);
    });
  }

  OverlayEntry _createOverlayEntry(_key, index) {
    return OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0.0,
            height: myHeight(context),
            width: myWidth(context),
            child: Material(
              color: Colors.black38,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => this._overlay.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      height: myHeight(context) * .18,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(myHeight(context) / 70.0))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth(context) / 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: myWidth(context) / 7,
                                  height: myHeight(context) / 150.0,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(
                                          myHeight(context) / 100.0))),
                            ),
                            SizedBox(
                              height: myHeight(context) / 60,
                            ),
                            InkWell(
                              onTap: () {
                                this._overlay.remove();
                                setState(() {
                                  if (index == 1) {
                                    _priceCard1 = allSales;
                                    _labelCard1 = 'Global';
                                  } else if (index == 2) {
                                    _priceCard2 = allPurchases;
                                    _labelCard2 = 'Global';
                                  } else {
                                    _priceCard3 = allIncomes;
                                    _labelCard3 = 'Global';
                                  }
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      AmazingIcon.calendar_line,
                                      size: myHeight(context) / 30.0,
                                      color: gradient1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: myHeight(context) / 25.0),
                                      child: Text(
                                        'Global',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: myHeight(context) / 40.0,
                                            color: textInverseModeColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                this._overlay.remove();
                                setState(() {
                                  if (index == 1) {
                                    _priceCard1 = dailySales;
                                    _labelCard1 = 'Auj.';
                                  } else if (index == 2) {
                                    _priceCard2 = dailyPurchases;
                                    _labelCard2 = 'Auj.';
                                  } else {
                                    _priceCard3 = dailyIncomes;
                                    _labelCard3 = 'Auj.';
                                  }
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      AmazingIcon.calendar_line,
                                      size: myHeight(context) / 30.0,
                                      color: gradient1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: myHeight(context) / 25.0),
                                      child: Text(
                                        'Aujourd\'hui',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: myHeight(context) / 40.0,
                                            color: textInverseModeColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }

  int _priceCard1, _priceCard2, _priceCard3;
  String _labelCard1, _labelCard2, _labelCard3;

  @override
  void initState() {
    super.initState();
    _labelCard1 = _labelCard2 = _labelCard3 = 'Global';
    _priceCard1 = allSales;
    _priceCard2 = allPurchases;
    _priceCard3 = allIncomes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: myHeight(context) / 30.0),
      child: Column(
        children: [
          Container(
            height: myHeight(context) / 4.5,
            child: Card(
              elevation: 10.0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  side:
                      BorderSide(color: textInverseModeColor.withOpacity(.05)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 19.5, vertical: 15.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('${widget.name}',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: myHeight(context) / 50.0)),
                        Spacer(),
                        GestureDetector(
                          onTap: () => _show(widget.scaffoldKey, widget.index),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.index == 1
                                    ? _labelCard1
                                    : widget.index == 2
                                        ? _labelCard2
                                        : _labelCard3,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: myHeight(context) / 50.0),
                              ),
                              SizedBox(width: myWidth(context) / 40),
                              Icon(
                                AmazingIcon.arrow_down_s_line,
                                color: Colors.black87,
                                size: myHeight(context) / 40.0,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.index == 1
                              ? formatPrice(_priceCard1)
                              : widget.index == 2
                                  ? formatPrice(_priceCard2)
                                  : formatPrice(_priceCard3),
                          style: TextStyle(
                              color: textInverseModeColor,
                              fontSize: myHeight(context) / 20.0),
                        ),
                        Text(
                          ' Fcfa',
                          style: TextStyle(
                              color: textInverseModeColor,
                              fontSize: myHeight(context) / 20.0),
                        ),
                      ],
                    ),
                    Container(
                        height: myHeight(context) / 13.5,
                        width: double.infinity,
                        child: Image.asset('img/charts.png', fit: BoxFit.cover))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
