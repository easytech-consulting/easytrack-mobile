import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/commons/layouts.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/customer_with_id.dart';
import 'package:easytrack/models/sale.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/models/user_with_id.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/notifications/all.dart';
import 'package:easytrack/screens/sales/manage.dart';
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
      if (sale['initiator']['id'] != user.id) {
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(myWidth(context) / 20,
            myHeight(context) / 80, myWidth(context) / 20, 0.0),
        child: Scaffold(
          body: Column(
            children: [
              header(context, _show2),
              FutureBuilder(
                  future: stats,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      _loadStats(snapshot.data);
                      return Scaffold(
                        backgroundColor: backgroundColor,
                        key: _scaffoldKey,
                        body: SafeArea(
                          child: Stack(
                            children: [
                              FutureBuilder(
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
                                      return Stack(
                                        children: [
                                          CustomScrollView(
                                            slivers: [
                                              SliverAppBar(
                                                expandedHeight:
                                                    myHeight(context) / 5.5,
                                                floating: true,
                                                pinned: true,
                                                automaticallyImplyLeading:
                                                    false,
                                                title: Container(
                                                  margin: EdgeInsets.only(
                                                      top: myHeight(context) /
                                                          55),
                                                ),
                                                bottom: PreferredSize(
                                                  preferredSize:
                                                      Size.fromHeight(
                                                          myHeight(context) /
                                                              14.3),
                                                  child: showAll
                                                      ? Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: myHeight(
                                                                      context) /
                                                                  50.0,
                                                              horizontal: myHeight(
                                                                      context) /
                                                                  40.0),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showAll =
                                                                        true;
                                                                    _sales = _checkAllSales(
                                                                            allSalesData)
                                                                        .map((sale) =>
                                                                            Sale.fromJson(sale))
                                                                        .toList();
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'Toutes les commandes',
                                                                  style: TextStyle(
                                                                      color:
                                                                          textSameModeColor,
                                                                      fontSize:
                                                                          myHeight(context) /
                                                                              40.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: myHeight(
                                                                        context) /
                                                                    30.0,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    showAll =
                                                                        false;
                                                                    _sales =
                                                                        _fetchMySales(
                                                                            allSalesData);
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'Mes commandes',
                                                                  style: TextStyle(
                                                                      color: textSameModeColor
                                                                          .withOpacity(
                                                                              .54),
                                                                      fontSize:
                                                                          myHeight(context) /
                                                                              50.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: myHeight(
                                                                      context) /
                                                                  50.0,
                                                              horizontal: myHeight(
                                                                      context) /
                                                                  40.0),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap:
                                                                    _sales ==
                                                                            null
                                                                        ? () {}
                                                                        : () {
                                                                            setState(() {
                                                                              showAll = false;
                                                                              _sales = _fetchMySales(allSalesData);
                                                                            });
                                                                          },
                                                                child: Text(
                                                                  'Mes commandes',
                                                                  style: TextStyle(
                                                                      color:
                                                                          textSameModeColor,
                                                                      fontSize:
                                                                          myHeight(context) /
                                                                              40.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: myHeight(
                                                                        context) /
                                                                    30.0,
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    _sales ==
                                                                            null
                                                                        ? () {}
                                                                        : () {
                                                                            setState(() {
                                                                              showAll = true;
                                                                              _sales = _checkAllSales(allSalesData).map((sale) => Sale.fromJson(sale)).toList();
                                                                            });
                                                                          },
                                                                child: Text(
                                                                  'Toutes les commandes',
                                                                  style: TextStyle(
                                                                      color: textSameModeColor
                                                                          .withOpacity(
                                                                              .54),
                                                                      fontSize:
                                                                          myHeight(context) /
                                                                              50.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                ),
                                                flexibleSpace: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                        gradient1,
                                                        gradient2
                                                      ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight)),
                                                ),
                                              ),
                                              _sales == null ||
                                                      _sales.length == 0
                                                  ? SliverAppBar(
                                                      automaticallyImplyLeading:
                                                          false,
                                                    )
                                                  : SliverList(
                                                      delegate:
                                                          SliverChildBuilderDelegate(
                                                              (context, index) {
                                                      return showAll
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          myHeight(context) /
                                                                              100),
                                                              child: InkWell(
                                                                  onTap: () {},
                                                                  child: Container(
                                                                      height: myHeight(context) / 5.8,
                                                                      margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            myWidth(context) /
                                                                                50.0,
                                                                      ),
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(right: Radius.circular(myHeight(context) / 110.0)), border: Border.all(color: Colors.black.withOpacity(.05))),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            border: Border(
                                                                                left: BorderSide(
                                                                          width:
                                                                              myWidth(context) / 100.0,
                                                                          color: _sales[index].status == 2
                                                                              ? Colors.green
                                                                              : _sales[index].status == 1 ? Colors.orange : gradient1,
                                                                        ))),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: myWidth(context) / 30.0,
                                                                              vertical: myHeight(context) / 70.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: <Widget>[
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    'S0-${_sales[index].code}',
                                                                                    style: TextStyle(fontSize: myHeight(context) / 30.0, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  Icon(
                                                                                    Icons.more_vert,
                                                                                    size: myWidth(context) / 16.0,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                width: myWidth(context),
                                                                                height: 30.0,
                                                                                child: ListView.builder(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: _productsOnSales[index].length,
                                                                                    itemBuilder: (context, ind) {
                                                                                      return Text(
                                                                                        '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']} ',
                                                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 45.0),
                                                                                      );
                                                                                    }),
                                                                              ),
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    _sales[index].status == 2 ? 'Paye' : _sales[index].status == 1 ? 'Servie' : 'En attente',
                                                                                    style: TextStyle(color: _sales[index].status == 2 ? Colors.green : _sales[index].status == 1 ? Colors.orange : gradient1, fontSize: screenSize(context).height / 53.0),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  Text(
                                                                                    'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                                    style: TextStyle(color: textInverseModeColor.withOpacity(.26), fontSize: screenSize(context).height / 60.0),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))),
                                                            )
                                                          : Container(
                                                              child: InkWell(
                                                                  onTap: () => Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ManageSales())),
                                                                  child: Container(
                                                                      height: myHeight(context) / 5.8,
                                                                      margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            myHeight(context) /
                                                                                100,
                                                                        vertical:
                                                                            myWidth(context) /
                                                                                50.0,
                                                                      ),
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.horizontal(right: Radius.circular(myHeight(context) / 110.0)), border: Border.all(color: Colors.black.withOpacity(.05))),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            border: Border(
                                                                                left: BorderSide(
                                                                          width:
                                                                              myWidth(context) / 100.0,
                                                                          color: _sales[index].status == 2
                                                                              ? Colors.green
                                                                              : _sales[index].status == 1 ? Colors.orange : gradient1,
                                                                        ))),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: myWidth(context) / 30.0,
                                                                              vertical: myHeight(context) / 70.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: <Widget>[
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    'S0-${_sales[index].code}',
                                                                                    style: TextStyle(fontSize: myHeight(context) / 30.0, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  Icon(
                                                                                    Icons.more_vert,
                                                                                    size: myWidth(context) / 16.0,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                width: myWidth(context),
                                                                                height: 30.0,
                                                                                child: ListView.builder(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: _productsOnSales[index].length,
                                                                                    itemBuilder: (context, ind) {
                                                                                      return Text(
                                                                                        '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']} ',
                                                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 45.0),
                                                                                      );
                                                                                    }),
                                                                              ),
                                                                              Row(
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    _sales[index].status == 2 ? 'Paye' : _sales[index].status == 1 ? 'Servie' : 'En attente',
                                                                                    style: TextStyle(color: _sales[index].status == 2 ? Colors.green : _sales[index].status == 1 ? Colors.orange : gradient1, fontSize: screenSize(context).height / 53.0),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  Text(
                                                                                    'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                                    style: TextStyle(color: textInverseModeColor.withOpacity(.26), fontSize: screenSize(context).height / 60.0),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))),
                                                            );
                                                    },
                                                              childCount: _sales
                                                                  .length)),
                                            ],
                                          ),
                                          _sales == null || _sales.length == 0
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  child:
                                                      Text('Aucune commande'),
                                                )
                                              : Container(
                                                  height: 0.0,
                                                ),
                                        ],
                                      );
                                    }
                                    return Stack(
                                      children: [
                                        CustomScrollView(
                                          slivers: [
                                            SliverAppBar(
                                              expandedHeight:
                                                  myHeight(context) / 5.5,
                                              floating: true,
                                              pinned: true,
                                              automaticallyImplyLeading: false,
                                              title: Container(
                                                margin: EdgeInsets.only(
                                                    top:
                                                        myHeight(context) / 55),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      width:
                                                          myWidth(context) / 3,
                                                      height:
                                                          myHeight(context) /
                                                              15.0,
                                                      child: Image.asset(
                                                        'img/logos/LogoWhiteWithText.png',
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      height: 46.0,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Hero(
                                                        tag: 'search',
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              searchMode = true;
                                                            });
                                                          },
                                                          child: Icon(
                                                            AmazingIcon
                                                                .search_2_line,
                                                            size: myHeight(
                                                                    context) /
                                                                30.0,
                                                            color:
                                                                textSameModeColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Container(
                                                      width: myWidth(context) /
                                                          7.5,
                                                      height: myWidth(context) /
                                                          7.5,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: () =>
                                                                _show2(),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: textSameModeColor
                                                                      .withOpacity(
                                                                          .38),
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .all(myHeight(
                                                                            context) /
                                                                        50.0),
                                                                child: Text(
                                                                  '${user.name.substring(0, 2).toUpperCase()}',
                                                                  style: TextStyle(
                                                                      color:
                                                                          textSameModeColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          myHeight(context) /
                                                                              50.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                bottom: myHeight(
                                                                        context) /
                                                                    100.0,
                                                                right: myHeight(
                                                                        context) /
                                                                    200.0,
                                                              ),
                                                              width: myHeight(
                                                                      context) /
                                                                  70.0,
                                                              height: myHeight(
                                                                      context) /
                                                                  70.0,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              bottom: PreferredSize(
                                                preferredSize: Size.fromHeight(
                                                    myHeight(context) / 14.3),
                                                child: showAll
                                                    ? Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: myHeight(
                                                                    context) /
                                                                50.0,
                                                            horizontal: myHeight(
                                                                    context) /
                                                                40.0),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  showAll =
                                                                      true;
                                                                  _sales = _checkAllSales(
                                                                          allSalesData)
                                                                      .map((sale) =>
                                                                          Sale.fromJson(
                                                                              sale))
                                                                      .toList();
                                                                });
                                                              },
                                                              child: Text(
                                                                'Toutes les commandes',
                                                                style: TextStyle(
                                                                    color:
                                                                        textSameModeColor,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            40.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: myHeight(
                                                                      context) /
                                                                  30.0,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  showAll =
                                                                      false;
                                                                  _sales =
                                                                      _fetchMySales(
                                                                          allSalesData);
                                                                });
                                                              },
                                                              child: Text(
                                                                'Mes commandes',
                                                                style: TextStyle(
                                                                    color: textSameModeColor
                                                                        .withOpacity(
                                                                            .54),
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            50.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: myHeight(
                                                                    context) /
                                                                50.0,
                                                            horizontal: myHeight(
                                                                    context) /
                                                                40.0),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:
                                                                  _sales == null
                                                                      ? () {}
                                                                      : () {
                                                                          setState(
                                                                              () {
                                                                            showAll =
                                                                                false;
                                                                            _sales =
                                                                                _fetchMySales(allSalesData);
                                                                          });
                                                                        },
                                                              child: Text(
                                                                'Mes commandes',
                                                                style: TextStyle(
                                                                    color:
                                                                        textSameModeColor,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            40.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: myHeight(
                                                                      context) /
                                                                  30.0,
                                                            ),
                                                            GestureDetector(
                                                              onTap:
                                                                  _sales == null
                                                                      ? () {}
                                                                      : () {
                                                                          setState(
                                                                              () {
                                                                            showAll =
                                                                                true;
                                                                            _sales =
                                                                                _checkAllSales(allSalesData).map((sale) => Sale.fromJson(sale)).toList();
                                                                          });
                                                                        },
                                                              child: Text(
                                                                'Toutes les commandes',
                                                                style: TextStyle(
                                                                    color: textSameModeColor
                                                                        .withOpacity(
                                                                            .54),
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            50.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                              flexibleSpace: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [
                                                      gradient1,
                                                      gradient2
                                                    ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                gradient1),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                              _isLoading
                                  ? Container(
                                      width: myWidth(context),
                                      height: myHeight(context),
                                      color: textSameModeColor.withOpacity(.89),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  gradient1),
                                        ),
                                      ))
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: otherHeader(context),
                        ),
                        Container(
                          height: myHeight(context) * .8,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(gradient1),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
