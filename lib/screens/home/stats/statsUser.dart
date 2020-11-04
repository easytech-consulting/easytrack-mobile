import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/customer_with_id.dart';
import 'package:easytrack/models/sale.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/models/user_with_id.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/notifications/all.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/homerService.dart';
import 'package:easytrack/services/saleService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class StatEmployee extends StatefulWidget {
  @override
  _StatEmployeeState createState() => _StatEmployeeState();
}

class _StatEmployeeState extends State<StatEmployee> {
  bool searchMode;
  bool _isLoading;
  Future stats;
  OverlayEntry _overlayEntry2;
  bool showAll = true;
  Future _futureSales;
  List _sales, _customers, _initiators, _validators, _sites, _productsOnSales;
  List allSalesData;

  @override
  void initState() {
    super.initState();
    stats = fetchStats();
    searchMode = false;
    _isLoading = false;
    _customers = [];
    _initiators = [];
    _validators = [];
    _productsOnSales = [];
    _sales = [];
    _sites = [];
    _futureSales = fetchSales();
  }

  //Show Menu
  _show2() {
    setState(() {
      this._overlayEntry2 = this._createOverlayEntry2();
      Overlay.of(context).insert(this._overlayEntry2);
    });
  }

  //Menu
  OverlayEntry _createOverlayEntry2() {
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
                      onTap: () => this._overlayEntry2.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      height: myHeight(context) * .67,
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
                                      '${capitalize(site.street.toLowerCase())} (${capitalize(userRole["name"])})',
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
                                this._overlayEntry2.remove();
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
                            Row(
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
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            Row(
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
                              height: myHeight(context) / 55.0,
                            ),
                            Text(
                              'Politique de confidentialite',
                              style: TextStyle(
                                  color: textInverseModeColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: myHeight(context) / 45.0),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            Text(
                              'Termes et conditions',
                              style: TextStyle(
                                  color: textInverseModeColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: myHeight(context) / 45.0),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            Text(
                              'A Propos',
                              style: TextStyle(
                                  color: textInverseModeColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: myHeight(context) / 45.0),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            Text(
                              'Aide',
                              style: TextStyle(
                                  color: textInverseModeColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: myHeight(context) / 45.0),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: myHeight(context) / 60.0),
                              child: GestureDetector(
                                onTap: () {
                                  this._overlayEntry2.remove();
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

  //Get Sales of the user
  List _fetchMySales(List sales) {
    List result = [];
    for (var sale in sales) {
      if (sale['initiator']['id'] == user.id) {
        if (!result.contains(sale)) {
          result.add(sale);
        }
      }
    }
    return result.map((e) => Sale.fromJson(e)).toList();
  }

  // Check all the sales
  List _checkAllSales(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var sale in datas) {
        _initiators.add(UserWithId.fromJson(sale['initiator']));
        _validators.add(sale['validator'] == null
            ? null
            : UserWithId.fromJson(sale['validator']));
        _productsOnSales.add(sale['products']);
        if (!_sites.contains(site)) {
          _sites.add(site);
        }
        _customers.add(CustomerWithId.fromJson(sale['customer']));

        result.add(sale);
      }
    } else {
      for (var site in datas) {
        for (var sale in site['sales']) {
          if (!result.contains(sale)) {
            _initiators.add(UserWithId.fromJson(sale['initiator']));
            _productsOnSales.add(sale['products']);
            _validators.add(sale['validator'] == null
                ? null
                : UserWithId.fromJson(sale['validator']));
            _sites.add(SiteWithId.fromJson(site));
            result.add(sale);
          }
        }
      }
    }
    return result;
  }

  //Field All datas
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

  // Log user out
  _logoutUser() async {
    setState(() {
      _isLoading = true;
    });
    await logout().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                header(context, _show2),
                FutureBuilder(
                    future: stats,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        _loadStats(snapshot.data);
                        return FutureBuilder(
                            future: _futureSales,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                if (allSalesData == null) {
                                  allSalesData = snapshot.data;
                                  _sales = _checkAllSales(allSalesData)
                                      .map((sale) => Sale.fromJson(sale))
                                      .toList();
                                }
                                return Expanded(
                                  child: Column(
                                    children: [
                                      showAll
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      myHeight(context) / 50.0,
                                                  horizontal:
                                                      myHeight(context) / 40.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showAll = true;
                                                        _sales = _checkAllSales(
                                                                allSalesData)
                                                            .map((sale) =>
                                                                Sale.fromJson(
                                                                    sale))
                                                            .toList();
                                                      });
                                                    },
                                                    child: Text(
                                                      'Commandes',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              35.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        myWidth(context) / 30.0,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showAll = false;
                                                        _sales = _fetchMySales(
                                                            allSalesData);
                                                      });
                                                    },
                                                    child: Text(
                                                      'Utilisateur',
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              45.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      myHeight(context) / 50.0,
                                                  horizontal:
                                                      myHeight(context) / 40.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: _sales == null
                                                        ? () {}
                                                        : () {
                                                            setState(() {
                                                              showAll = false;
                                                              _sales =
                                                                  _fetchMySales(
                                                                      allSalesData);
                                                            });
                                                          },
                                                    child: Text(
                                                      'Utilisateur',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              35.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        myWidth(context) / 30.0,
                                                  ),
                                                  GestureDetector(
                                                    onTap: _sales == null
                                                        ? () {}
                                                        : () {
                                                            setState(() {
                                                              showAll = true;
                                                              _sales = _checkAllSales(
                                                                      allSalesData)
                                                                  .map((sale) =>
                                                                      Sale.fromJson(
                                                                          sale))
                                                                  .toList();
                                                            });
                                                          },
                                                    child: Text(
                                                      'Commandes',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              45.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      Expanded(
                                          child:
                                              _sales == null ||
                                                      _sales.length == 0
                                                  ? Center(
                                                      child: Text(
                                                          'Aucune commande'),
                                                    )
                                                  : ListView.builder(
                                                      itemCount: _sales.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      myWidth(context) /
                                                                          30.0),
                                                          child: showAll
                                                              ? Container(
                                                                  child: InkWell(
                                                                      child: Container(
                                                                          height: myHeight(context) / 6.4,
                                                                          margin: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                myWidth(context) / 50.0,
                                                                          ),
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(myHeight(context) / 90.0)), border: Border.all(width: 1.0, color: Colors.black.withOpacity(.1))),
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: myWidth(context) / 30.0, vertical: myHeight(context) / 70.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      'S0-${_sales[index].code}',
                                                                                      style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Icon(
                                                                                      Icons.more_vert,
                                                                                      size: myWidth(context) / 16.0,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: myHeight(context) / 62),
                                                                                  child: Container(
                                                                                    width: myWidth(context),
                                                                                    height: 30.0,
                                                                                    child: ListView.builder(
                                                                                        physics: null,
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        itemCount: _productsOnSales[index].length > 1 ? 1 : _productsOnSales[index].length,
                                                                                        itemBuilder: (context, ind) {
                                                                                          return Text(
                                                                                            _productsOnSales[index].length > 1 ? '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}...' : '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}',
                                                                                            style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 45.0),
                                                                                          );
                                                                                        }),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(bottom: myHeight(context) / 200.0),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        _sales[index].status == 2 ? 'Paye' : _sales[index].status == 1 ? 'Servie' : 'En attente',
                                                                                        style: TextStyle(color: _sales[index].status == 2 ? Colors.green : _sales[index].status == 1 ? Colors.orange : gradient1, fontSize: screenSize(context).height / 53.0),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      Text(
                                                                                        'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                                        style: TextStyle(color: Colors.black26, fontSize: screenSize(context).height / 60.0),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ))),
                                                                )
                                                              : Container(
                                                                  child: InkWell(
                                                                      child: Container(
                                                                          height: myHeight(context) / 6.4,
                                                                          margin: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                myWidth(context) / 50.0,
                                                                          ),
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(myHeight(context) / 90.0)), border: Border.all(width: 1.0, color: Colors.black.withOpacity(.1))),
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: myWidth(context) / 30.0, vertical: myHeight(context) / 70.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      'S0-${_sales[index].code}',
                                                                                      style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Icon(
                                                                                      Icons.more_vert,
                                                                                      size: myWidth(context) / 16.0,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: myHeight(context) / 62),
                                                                                  child: Container(
                                                                                    width: myWidth(context),
                                                                                    height: 30.0,
                                                                                    child: ListView.builder(
                                                                                        physics: null,
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        itemCount: _productsOnSales[index].length > 1 ? 1 : _productsOnSales[index].length,
                                                                                        itemBuilder: (context, ind) {
                                                                                          return Text(
                                                                                            _productsOnSales[index].length > 1 ? '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}...' : '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}',
                                                                                            style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 45.0),
                                                                                          );
                                                                                        }),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(bottom: myHeight(context) / 200.0),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        _sales[index].status == 2 ? 'Paye' : _sales[index].status == 1 ? 'Servie' : 'En attente',
                                                                                        style: TextStyle(color: _sales[index].status == 2 ? Colors.green : _sales[index].status == 1 ? Colors.orange : gradient1, fontSize: screenSize(context).height / 53.0),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      Text(
                                                                                        'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                                        style: TextStyle(color: Colors.black26, fontSize: screenSize(context).height / 60.0),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ))),
                                                                ),
                                                        );
                                                      },
                                                    ))
                                    ],
                                  ),
                                );
                              }
                              return Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        gradient1),
                                  ),
                                ),
                              );
                            });
                      }
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(gradient1),
                          ),
                        ),
                      );
                    }),
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
      ),
    );
  }
}
