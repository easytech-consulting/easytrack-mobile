import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/layouts.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/customer_with_id.dart';
import 'package:easytrack/models/sale.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/models/user_with_id.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/sales/manage.dart';
import 'package:easytrack/screens/site/all.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/homerService.dart';
import 'package:easytrack/services/saleService.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool searchMode;
  bool _isLoading;
  Future stats;

  bool showAll = true;
  Future _futureSales;
  List _sales, _customers, _initiators, _validators, _sites, _productsOnSales;
  List allSalesData;

  TextEditingController _controller = TextEditingController();
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

  _showAdminSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: textSameModeColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: textInverseModeColor.withOpacity(.05)),
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(myHeight(context) / 70.0))),
      content: Container(
          height: myHeight(context) * .7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: myWidth(context) / 5,
                    height: myHeight(context) / 150.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.3),
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 100.0))),
              ),
              SizedBox(
                height: myHeight(context) / 35.0,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff267FC9), shape: BoxShape.circle),
                    child: Padding(
                      padding: EdgeInsets.all(myHeight(context) / 50.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${capitalize(user.name)}',
                        style: TextStyle(
                            color: textInverseModeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: myHeight(context) / 45.0),
                      ),
                      Text(
                        '${capitalize(company.name.toLowerCase())} (${capitalize(userRole["name"])})',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.38),
                            fontSize: myHeight(context) / 65.0),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: myHeight(context) / 25.0,
              ),
              Row(
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
                              color: Colors.red, shape: BoxShape.circle),
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
              SizedBox(
                height: myHeight(context) / 55.0,
              ),
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SitePage()));
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
                height: myHeight(context) / 55.0,
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
                height: myHeight(context) / 55.0,
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
                height: myHeight(context) / 55.0,
              ),
              Row(
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
              SizedBox(
                height: myHeight(context) / 25.0,
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
                padding: EdgeInsets.only(bottom: myHeight(context) / 60.0),
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.hideCurrentSnackBar();
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
          )),
    ));
  }

  _showUserSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: textSameModeColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: textInverseModeColor.withOpacity(.05)),
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(myHeight(context) / 70.0))),
      content: Container(
          height: myHeight(context) * .65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: myWidth(context) / 5,
                    height: myHeight(context) / 150.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.3),
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 100.0))),
              ),
              SizedBox(
                height: myHeight(context) / 35.0,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff267FC9), shape: BoxShape.circle),
                    child: Padding(
                      padding: EdgeInsets.all(myHeight(context) / 50.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${capitalize(user.name)}',
                        style: TextStyle(
                            color: textInverseModeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: myHeight(context) / 45.0),
                      ),
                      Text(
                        '${capitalize(site.street.toLowerCase())} (${capitalize(userRole["name"])})',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.38),
                            fontSize: myHeight(context) / 65.0),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: myHeight(context) / 25.0,
              ),
              Row(
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
                              color: Colors.red, shape: BoxShape.circle),
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
              SizedBox(
                height: myHeight(context) / 55.0,
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
                height: myHeight(context) / 55.0,
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
                height: myHeight(context) / 55.0,
              ),
              Row(
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
              SizedBox(
                height: myHeight(context) / 25.0,
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
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
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
            ],
          )),
    ));
  }

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
            /* 
            _customers.add(Customer.fromJson(sale['customer'])); */

            result.add(sale);
          }
        }
      }
    }
    return result;
  }

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

  _logoutUser() async {
    setState(() {
      _isLoading = true;
    });
    await logout().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  buildContent() {
    return user.isAdmin == 1
        ? Scaffold(
            backgroundColor: backgroundColor,
            key: _scaffoldKey,
            body: SafeArea(
              child: Stack(
                children: [
                  FutureBuilder(
                      future: _futureSales,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
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
                                    expandedHeight: myHeight(context) / 5.5,
                                    floating: true,
                                    pinned: true,
                                    automaticallyImplyLeading: false,
                                    title: Container(
                                      margin: EdgeInsets.only(
                                          top: myHeight(context) / 55),
                                      child: searchMode
                                          ? Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Container(
                                                    height: myHeight(context) /
                                                        17.0,
                                                    decoration:
                                                        buildTextFormFieldContainer(
                                                            decorationColor),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Hero(
                                                    tag: 'search',
                                                    child: Container(
                                                      height:
                                                          myHeight(context) /
                                                              17.0,
                                                      child: TextFormField(
                                                        onFieldSubmitted: (_) {
                                                          setState(() {
                                                            searchMode = false;
                                                          });
                                                        },
                                                        controller: _controller,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffffffff)),
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0,
                                                                        left:
                                                                            50.0),
                                                                prefixIcon: Icon(
                                                                    AmazingIcon
                                                                        .search_2_line,
                                                                    color: Color(
                                                                        0xffffffff),
                                                                    size: 20.0),
                                                                suffixIcon:
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            searchMode =
                                                                                false;
                                                                          });
                                                                        },
                                                                        icon: Icon(
                                                                            AmazingIcon
                                                                                .close_fill,
                                                                            color: Color(
                                                                                0xffffffff),
                                                                            size:
                                                                                20.0)),
                                                                hintText:
                                                                    'Recherche...',
                                                                hintStyle: TextStyle(
                                                                    color: Color(
                                                                            0xffffffff)
                                                                        .withOpacity(
                                                                            .35),
                                                                    fontSize:
                                                                        18.0),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none,
                                                                )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  width: myWidth(context) / 3,
                                                  height:
                                                      myHeight(context) / 15.0,
                                                  child: Image.asset(
                                                    'img/logos/LogoWhiteWithText.png',
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  height: 46.0,
                                                  alignment: Alignment.center,
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
                                                        size:
                                                            myHeight(context) /
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
                                                  width: myWidth(context) / 7.5,
                                                  height:
                                                      myWidth(context) / 7.5,
                                                  alignment: Alignment.center,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _showUserSnackBar(),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white38,
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
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      myHeight(
                                                                              context) /
                                                                          50.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
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
                                                          decoration:
                                                              BoxDecoration(
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
                                                  vertical:
                                                      myHeight(context) / 50.0,
                                                  horizontal:
                                                      myHeight(context) / 40.0),
                                              child: Row(
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
                                                      'Toutes les commandes',
                                                      style: TextStyle(
                                                          color:
                                                              textSameModeColor,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              40.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: myHeight(context) /
                                                        30.0,
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
                                                      'Mes commandes',
                                                      style: TextStyle(
                                                          color:
                                                              textSameModeColor
                                                                  .withOpacity(
                                                                      .54),
                                                          fontSize: myHeight(
                                                                  context) /
                                                              50.0,
                                                          fontWeight:
                                                              FontWeight.w600),
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
                                                      'Mes commandes',
                                                      style: TextStyle(
                                                          color:
                                                              textSameModeColor,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              40.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: myHeight(context) /
                                                        30.0,
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
                                                      'Toutes les commandes',
                                                      style: TextStyle(
                                                          color:
                                                              textSameModeColor
                                                                  .withOpacity(
                                                                      .54),
                                                          fontSize: myHeight(
                                                                  context) /
                                                              50.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                    flexibleSpace: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [gradient1, gradient2],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)),
                                    ),
                                  ),
                                  _sales == null || _sales.length == 0
                                      ? SliverAppBar(
                                          automaticallyImplyLeading: false,
                                        )
                                      : SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                          return showAll
                                              ? Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          myHeight(context) /
                                                              100),
                                                  child: InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                          height: myHeight(context) /
                                                              5.8,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            vertical: myWidth(
                                                                    context) /
                                                                50.0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.horizontal(
                                                                  right: Radius.circular(
                                                                      myHeight(context) /
                                                                          110.0)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .05))),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    left: BorderSide(
                                                              width: myWidth(
                                                                      context) /
                                                                  100.0,
                                                              color: _sales[index]
                                                                          .status ==
                                                                      2
                                                                  ? Colors.green
                                                                  : _sales[index]
                                                                              .status ==
                                                                          1
                                                                      ? Colors
                                                                          .orange
                                                                      : gradient1,
                                                            ))),
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      myWidth(context) /
                                                                          30.0,
                                                                  vertical:
                                                                      myHeight(
                                                                              context) /
                                                                          70.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        'S0-${_sales[index].code}',
                                                                        style: TextStyle(
                                                                            fontSize: myHeight(context) /
                                                                                30.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      Spacer(),
                                                                      Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        size: myWidth(context) /
                                                                            16.0,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    width: myWidth(
                                                                        context),
                                                                    height:
                                                                        30.0,
                                                                    child: ListView.builder(
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: _productsOnSales[index].length,
                                                                        itemBuilder: (context, ind) {
                                                                          return Text(
                                                                            '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']} ',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 45.0),
                                                                          );
                                                                        }),
                                                                  ),
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        _sales[index].status ==
                                                                                2
                                                                            ? 'Paye'
                                                                            : _sales[index].status == 1
                                                                                ? 'Servie'
                                                                                : 'En attente',
                                                                        style: TextStyle(
                                                                            color: _sales[index].status == 2
                                                                                ? Colors.green
                                                                                : _sales[index].status == 1 ? Colors.orange : gradient1,
                                                                            fontSize: screenSize(context).height / 53.0),
                                                                      ),
                                                                      Spacer(),
                                                                      Text(
                                                                        'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                textInverseModeColor.withOpacity(.26),
                                                                            fontSize: screenSize(context).height / 60.0),
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
                                                          height: myHeight(context) /
                                                              5.8,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            horizontal: myHeight(
                                                                    context) /
                                                                100,
                                                            vertical: myWidth(
                                                                    context) /
                                                                50.0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.horizontal(
                                                                  right: Radius.circular(
                                                                      myHeight(context) /
                                                                          110.0)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .05))),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    left: BorderSide(
                                                              width: myWidth(
                                                                      context) /
                                                                  100.0,
                                                              color: _sales[index]
                                                                          .status ==
                                                                      2
                                                                  ? Colors.green
                                                                  : _sales[index]
                                                                              .status ==
                                                                          1
                                                                      ? Colors
                                                                          .orange
                                                                      : gradient1,
                                                            ))),
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      myWidth(context) /
                                                                          30.0,
                                                                  vertical:
                                                                      myHeight(
                                                                              context) /
                                                                          70.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        'S0-${_sales[index].code}',
                                                                        style: TextStyle(
                                                                            fontSize: myHeight(context) /
                                                                                30.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      Spacer(),
                                                                      Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        size: myWidth(context) /
                                                                            16.0,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    width: myWidth(
                                                                        context),
                                                                    height:
                                                                        30.0,
                                                                    child: ListView.builder(
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: _productsOnSales[index].length,
                                                                        itemBuilder: (context, ind) {
                                                                          return Text(
                                                                            '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']} ',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 45.0),
                                                                          );
                                                                        }),
                                                                  ),
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        _sales[index].status ==
                                                                                2
                                                                            ? 'Paye'
                                                                            : _sales[index].status == 1
                                                                                ? 'Servie'
                                                                                : 'En attente',
                                                                        style: TextStyle(
                                                                            color: _sales[index].status == 2
                                                                                ? Colors.green
                                                                                : _sales[index].status == 1 ? Colors.orange : gradient1,
                                                                            fontSize: screenSize(context).height / 53.0),
                                                                      ),
                                                                      Spacer(),
                                                                      Text(
                                                                        'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                textInverseModeColor.withOpacity(.26),
                                                                            fontSize: screenSize(context).height / 60.0),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ))),
                                                );
                                        }, childCount: _sales.length)),
                                ],
                              ),
                              _sales == null || _sales.length == 0
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Text('Aucune commande'),
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
                                  expandedHeight: myHeight(context) / 5.5,
                                  floating: true,
                                  pinned: true,
                                  automaticallyImplyLeading: false,
                                  title: Container(
                                    margin: EdgeInsets.only(
                                        top: myHeight(context) / 55),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: myWidth(context) / 3,
                                          height: myHeight(context) / 15.0,
                                          child: Image.asset(
                                            'img/logos/LogoWhiteWithText.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 46.0,
                                          alignment: Alignment.center,
                                          child: Hero(
                                            tag: 'search',
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  searchMode = true;
                                                });
                                              },
                                              child: Icon(
                                                AmazingIcon.search_2_line,
                                                size: myHeight(context) / 30.0,
                                                color: textSameModeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Container(
                                          width: myWidth(context) / 7.5,
                                          height: myWidth(context) / 7.5,
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () =>
                                                    _showUserSnackBar(),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: textSameModeColor
                                                          .withOpacity(.38),
                                                      shape: BoxShape.circle),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        myHeight(context) /
                                                            50.0),
                                                    child: Text(
                                                      '${user.name.substring(0, 2).toUpperCase()}',
                                                      style: TextStyle(
                                                          color:
                                                              textSameModeColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              50.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: myHeight(context) /
                                                        100.0,
                                                    right: myHeight(context) /
                                                        200.0,
                                                  ),
                                                  width:
                                                      myHeight(context) / 70.0,
                                                  height:
                                                      myHeight(context) / 70.0,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle),
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
                                                vertical:
                                                    myHeight(context) / 50.0,
                                                horizontal:
                                                    myHeight(context) / 40.0),
                                            child: Row(
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
                                                    'Toutes les commandes',
                                                    style: TextStyle(
                                                        color:
                                                            textSameModeColor,
                                                        fontSize:
                                                            myHeight(context) /
                                                                40.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      myHeight(context) / 30.0,
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
                                                    'Mes commandes',
                                                    style: TextStyle(
                                                        color: textSameModeColor
                                                            .withOpacity(.54),
                                                        fontSize:
                                                            myHeight(context) /
                                                                50.0,
                                                        fontWeight:
                                                            FontWeight.w600),
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
                                                    'Mes commandes',
                                                    style: TextStyle(
                                                        color:
                                                            textSameModeColor,
                                                        fontSize:
                                                            myHeight(context) /
                                                                40.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      myHeight(context) / 30.0,
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
                                                    'Toutes les commandes',
                                                    style: TextStyle(
                                                        color: textSameModeColor
                                                            .withOpacity(.54),
                                                        fontSize:
                                                            myHeight(context) /
                                                                50.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  flexibleSpace: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [gradient1, gradient2],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)),
                                  ),
                                ),
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
                      }),
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
          )
        : Scaffold(
            backgroundColor: backgroundColor,
            key: _scaffoldKey,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: myHeight(context) / 4,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [gradient1, gradient2],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: myHeight(context) / 30.0),
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: searchMode
                                  ? Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            height: myHeight(context) / 17.0,
                                            decoration:
                                                buildTextFormFieldContainer(
                                                    decorationColor),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Hero(
                                            tag: 'search',
                                            child: Container(
                                              height: myHeight(context) / 17.0,
                                              child: TextFormField(
                                                onFieldSubmitted: (_) {
                                                  setState(() {
                                                    searchMode = false;
                                                  });
                                                },
                                                controller: _controller,
                                                textInputAction:
                                                    TextInputAction.done,
                                                style: TextStyle(
                                                    color: textSameModeColor),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 50.0),
                                                    prefixIcon: Icon(
                                                        AmazingIcon
                                                            .search_2_line,
                                                        color:
                                                            textSameModeColor,
                                                        size: 20.0),
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            searchMode = false;
                                                          });
                                                        },
                                                        icon: Icon(
                                                            AmazingIcon
                                                                .close_fill,
                                                            color: Color(
                                                                0xffffffff),
                                                            size: 20.0)),
                                                    hintText: 'Recherche...',
                                                    hintStyle: TextStyle(
                                                        color: textSameModeColor
                                                            .withOpacity(.35),
                                                        fontSize: 18.0),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: myWidth(context) / 3,
                                          height: myHeight(context) / 15.0,
                                          child: Image.asset(
                                            'img/logos/LogoWhiteWithText.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 46.0,
                                          alignment: Alignment.center,
                                          child: Hero(
                                            tag: 'search',
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  searchMode = true;
                                                });
                                              },
                                              child: Icon(
                                                AmazingIcon.search_2_line,
                                                size: myHeight(context) / 30.0,
                                                color: textSameModeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        GestureDetector(
                                          onTap: () => _showAdminSnackBar(),
                                          child: Container(
                                            width: myWidth(context) / 7.5,
                                            height: myWidth(context) / 7.5,
                                            alignment: Alignment.center,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: textSameModeColor
                                                          .withOpacity(.38),
                                                      shape: BoxShape.circle),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        myHeight(context) /
                                                            50.0),
                                                    child: Text(
                                                      '${user.name.substring(0, 2).toUpperCase()}',
                                                      style: TextStyle(
                                                          color:
                                                              textSameModeColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              50.0),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      bottom:
                                                          myHeight(context) /
                                                              100.0,
                                                      right: myHeight(context) /
                                                          200.0,
                                                    ),
                                                    width: myHeight(context) /
                                                        70.0,
                                                    height: myHeight(context) /
                                                        70.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: myHeight(context) / 30,
                        ),
                        Container(
                          height: myHeight(context) / 4.25,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
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
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 13.0,
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
                          height: 7.0,
                        ),
                        Container(
                            height: myHeight(context) / 2.3,
                            padding: EdgeInsets.symmetric(
                                horizontal: myHeight(context) / 30.0),
                            child: FutureBuilder(
                              future: _futureSales,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  allSalesData = snapshot.data;
                                  _sales = _checkAllSales(allSalesData)
                                      .map((sale) => Sale.fromJson(sale))
                                      .toList();

                                  return ListView.builder(
                                    itemCount:
                                        _sales.length > 10 ? 10 : _sales.length,
                                    itemBuilder: (context, index) {
                                      return _sales == null ||
                                              _sales.length == 0
                                          ? Center(
                                              child: Text(
                                                  'Aucune commande recente'))
                                          : Container(
                                              child: InkWell(
                                                  /* onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ManageSales())),
                                                   */
                                                  child: Container(
                                                      height:
                                                          myHeight(context) /
                                                              5.8,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical:
                                                            myWidth(context) /
                                                                50.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .horizontal(
                                                                  right: Radius.circular(
                                                                      myHeight(
                                                                              context) /
                                                                          110.0)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .05))),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                left: BorderSide(
                                                          width:
                                                              myWidth(context) /
                                                                  100.0,
                                                          color: _sales[index]
                                                                      .status ==
                                                                  2
                                                              ? Colors.green
                                                              : _sales[index]
                                                                          .status ==
                                                                      1
                                                                  ? Colors
                                                                      .orange
                                                                  : gradient1,
                                                        ))),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: myWidth(
                                                                      context) /
                                                                  30.0,
                                                              vertical: myHeight(
                                                                      context) /
                                                                  70.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    'S0-${_sales[index].code}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            myHeight(context) /
                                                                                30.0,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Spacer(),
                                                                  Icon(
                                                                    Icons
                                                                        .more_vert,
                                                                    size: myWidth(
                                                                            context) /
                                                                        16.0,
                                                                  )
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: myHeight(
                                                                            context) /
                                                                        62),
                                                                child:
                                                                    Container(
                                                                  width: myWidth(
                                                                      context),
                                                                  height: 30.0,
                                                                  child: ListView
                                                                      .builder(
                                                                          scrollDirection: Axis
                                                                              .horizontal,
                                                                          itemCount: _productsOnSales[index]
                                                                              .length,
                                                                          itemBuilder:
                                                                              (context, ind) {
                                                                            return Text(
                                                                              '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']} ',
                                                                              style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 45.0),
                                                                            );
                                                                          }),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    bottom: myHeight(
                                                                            context) /
                                                                        200.0),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      _sales[index].status ==
                                                                              2
                                                                          ? 'Paye'
                                                                          : _sales[index].status == 1
                                                                              ? 'Servie'
                                                                              : 'En attente',
                                                                      style: TextStyle(
                                                                          color: _sales[index].status == 2
                                                                              ? Colors.green
                                                                              : _sales[index].status == 1 ? Colors.orange : gradient1,
                                                                          fontSize: screenSize(context).height / 53.0),
                                                                    ),
                                                                    Spacer(),
                                                                    Text(
                                                                      'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black26,
                                                                          fontSize:
                                                                              screenSize(context).height / 60.0),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ))),
                                            );
                                    },
                                  );
                                }
                                return Center(
                                    child: CircularProgressIndicator(
                                  valueColor:
                                      new AlwaysStoppedAnimation(gradient1),
                                ));
                              },
                            ))
                      ],
                    ),
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

  @override
  Widget build(BuildContext context) {
    return allSales == null ||
            allPurchases == null ||
            allIncomes == null ||
            dailySales == null ||
            dailyPurchases == null ||
            dailyIncomes == null
        ? FutureBuilder(
            future: stats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                _loadStats(snapshot.data);
                return buildContent();
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
                        valueColor: AlwaysStoppedAnimation<Color>(gradient1),
                      ),
                    ),
                  ),
                ],
              );
            })
        : buildContent();
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
  showSnackBar(GlobalKey<ScaffoldState> _key, int index) {
    _key.currentState.showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      duration: Duration(seconds: 30),
      backgroundColor: textSameModeColor,
      content: Container(
        height: myHeight(widget.parentContext) / 6,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              height: 7.0,
              width: 50.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            InkWell(
              onTap: () {
                _key.currentState.hideCurrentSnackBar();
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
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      AmazingIcon.calendar_line,
                      size: 15.0,
                      color: gradient1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Global',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17.0,
                            color: textInverseModeColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _key.currentState.hideCurrentSnackBar();
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
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      AmazingIcon.calendar_line,
                      size: 15.0,
                      color: gradient1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Aujourd\'hui',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17.0,
                            color: textInverseModeColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
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
      padding: EdgeInsets.only(
          left: widget.index == 1 ? myHeight(context) / 50.0 : 0.0,
          right: widget.index == 3
              ? myHeight(context) / 50.0
              : myHeight(context) / 150.0),
      child: Container(
        width: myWidth(context) * .8,
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: textInverseModeColor.withOpacity(.05)),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 19.5, vertical: 15.25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('${widget.name}',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.35),
                            fontSize: myHeight(context) / 50.0)),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showSnackBar(widget.scaffoldKey, widget.index);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.index == 1
                                ? _labelCard1
                                : widget.index == 2 ? _labelCard2 : _labelCard3,
                            style: TextStyle(
                                color: textInverseModeColor.withOpacity(.35),
                                fontSize: myHeight(context) / 50.0),
                          ),
                          SizedBox(width: myWidth(context) / 100),
                          Icon(
                            AmazingIcon.arrow_down_s_line,
                            color: textInverseModeColor.withOpacity(.35),
                            size: myHeight(context) / 40.0,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 100.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.index == 1
                          ? _priceCard1.toString()
                          : widget.index == 2
                              ? _priceCard2.toString()
                              : _priceCard3.toString(),
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
                    child: Image.asset(
                      'img/charts.png',
                      fit: BoxFit.fitWidth,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
