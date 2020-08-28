import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/customer_with_id.dart';
import 'package:easytrack/models/sale.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/models/user_with_id.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/company/all.dart';
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
    _sites = [];
    _futureSales = fetchSales();
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
            _customers.add(CustomerWithId.fromJson(sale['customer']));

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

  Widget _offsetPopup() => PopupMenuButton<int>(
        onSelected: (int value) {
          value == 1
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SitePage()))
              : value == 2
                  ? _logoutUser()
                  : value == 3
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyPage()))
                      : Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
        },
        itemBuilder: (context) =>
            userRole['slug'] == 'boss' || user.isAdmin == 2
                ? [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          Icon(AmazingIcon.community_line),
                          SizedBox(width: 3.0),
                          Text(
                            "Gerer les sites",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.exit_to_app, color: redColor),
                          SizedBox(width: 3.0),
                          Text(
                            "Deconnexion",
                            style: TextStyle(
                                color: redColor, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ]
                : [
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.exit_to_app, color: redColor),
                          SizedBox(width: 3.0),
                          Text(
                            "Deconnexion",
                            style: TextStyle(
                                color: redColor, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
        icon: Icon(Icons.library_add, color: Colors.transparent),
        offset: Offset(0, 100),
      );

  buildContent() {
    return user.isAdmin == 1
        ? Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: myHeight(context) / 5.5,
                        floating: true,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        title: Container(
                          margin: EdgeInsets.only(top: myHeight(context) / 55),
                          child: searchMode
                              ? Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: myHeight(context) / 17.0,
                                        decoration: textFormFieldBoxDecoration,
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
                                                color: Color(0xffffffff)),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 10.0, left: 50.0),
                                                prefixIcon: Icon(
                                                    AmazingIcon.search_2_line,
                                                    color: Color(0xffffffff),
                                                    size: 20.0),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        searchMode = false;
                                                      });
                                                    },
                                                    icon: Icon(
                                                        AmazingIcon.close_fill,
                                                        color:
                                                            Color(0xffffffff),
                                                        size: 20.0)),
                                                hintText: 'Recherche...',
                                                hintStyle: TextStyle(
                                                    color: Color(0xffffffff)
                                                        .withOpacity(.35),
                                                    fontSize: 18.0),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: Color(0xffffffff),
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
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white38,
                                                  shape: BoxShape.circle),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    myHeight(context) / 50.0),
                                                child: Text(
                                                  '${user.name.substring(0, 2).toUpperCase()}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          myHeight(context) /
                                                              50.0),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  bottom:
                                                      myHeight(context) / 100.0,
                                                  right:
                                                      myHeight(context) / 200.0,
                                                ),
                                                width: myHeight(context) / 70.0,
                                                height:
                                                    myHeight(context) / 70.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                            _offsetPopup(),
                                          ],
                                        ),
                                      )
                                    ],
                                ),
                        ),
                        bottom: PreferredSize(
                          preferredSize:
                              Size.fromHeight(myHeight(context) / 14.5),
                          child: showAll
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: myHeight(context) / 50.0,
                                      horizontal: myHeight(context) / 40.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showAll = true;
                                          });
                                        },
                                        child: Text(
                                          'Toutes les commandes',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  myHeight(context) / 40.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        width: myHeight(context) / 30.0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showAll = false;
                                          });
                                        },
                                        child: Text(
                                          'Mes commandes',
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize:
                                                  myHeight(context) / 50.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: myHeight(context) / 50.0,
                                      horizontal: myHeight(context) / 40.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showAll = false;
                                          });
                                        },
                                        child: Text(
                                          'Mes commandes',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  myHeight(context) / 40.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        width: myHeight(context) / 30.0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showAll = true;
                                          });
                                        },
                                        child: Text(
                                          'Toutes les commandes',
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize:
                                                  myHeight(context) / 50.0,
                                              fontWeight: FontWeight.w600),
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
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => showAll
                                ? FutureBuilder(
                                    future: _futureSales,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        allSalesData = snapshot.data;
                                        _sales = _checkAllSales(allSalesData)
                                            .map((sale) => Sale.fromJson(sale))
                                            .toList();
                                        return _sales == null ||
                                                _sales.length == 0
                                            ? Center(
                                                child: Text(
                                                    'Aucune commande recente'))
                                            : Container(
                                                child: InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ManageSales())),
                                                    child: Container(
                                                        height:
                                                            myHeight(context) /
                                                                5.8,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          vertical:
                                                              myWidth(context) /
                                                                  50.0,
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.horizontal(
                                                                right: Radius.circular(
                                                                    myHeight(context) /
                                                                        110.0)),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black54)),
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
                                                                              FontWeight.w600),
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
                                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 45.0),
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
                                                                          color: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              screenSize(context).height / 60.0),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ))),
                                              );
                                      }

                                      return Container(
                                        height: myHeight(context) * .6,
                                        width: double.infinity,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                gradient1),
                                          ),
                                        ),
                                      );
                                    })
                                : FutureBuilder(
                                    future: _futureSales,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        allSalesData = snapshot.data;
                                        _sales = _checkAllSales(allSalesData)
                                            .map((sale) => Sale.fromJson(sale))
                                            .toList();
                                        return _sales == null ||
                                                _sales.length == 0
                                            ? Center(
                                                child: Text(
                                                    'Aucune commande recente'))
                                            : Container(
                                                child: InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ManageSales())),
                                                    child: Container(
                                                        height:
                                                            myHeight(context) /
                                                                5.8,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          vertical:
                                                              myWidth(context) /
                                                                  50.0,
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.horizontal(
                                                                right: Radius.circular(
                                                                    myHeight(context) /
                                                                        110.0)),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black54)),
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
                                                                              FontWeight.w600),
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
                                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 45.0),
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
                                                                          color: Colors
                                                                              .black54,
                                                                          fontSize:
                                                                              screenSize(context).height / 60.0),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ))),
                                              );
                                      }

                                      return Container(
                                        height: myHeight(context) * .6,
                                        width: double.infinity,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                gradient1),
                                          ),
                                        ),
                                      );
                                    }),
                            childCount: _sales.length),
                      ),
                    ],
                  ),
                  _isLoading
                      ? Container(
                          width: myWidth(context),
                          height: myHeight(context),
                          color: Color(0xffffffff).withOpacity(.89),
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
                        padding: const EdgeInsets.symmetric(horizontal: 22.5),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: searchMode
                                ? Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: myHeight(context) / 17.0,
                                          decoration:
                                              textFormFieldBoxDecoration,
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
                                                  color: Color(0xffffffff)),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 50.0),
                                                  prefixIcon: Icon(
                                                      AmazingIcon.search_2_line,
                                                      color: Color(0xffffffff),
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
                                                          color:
                                                              Color(0xffffffff),
                                                          size: 20.0)),
                                                  hintText: 'Recherche...',
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffffffff)
                                                          .withOpacity(.35),
                                                      fontSize: 18.0),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
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
                                              color: Color(0xffffffff),
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
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white38,
                                                  shape: BoxShape.circle),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    myHeight(context) / 50.0),
                                                child: Text(
                                                  '${user.name.substring(0, 2).toUpperCase()}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          myHeight(context) /
                                                              50.0),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  bottom:
                                                      myHeight(context) / 100.0,
                                                  right:
                                                      myHeight(context) / 200.0,
                                                ),
                                                width: myHeight(context) / 70.0,
                                                height:
                                                    myHeight(context) / 70.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                            _offsetPopup(),
                                          ],
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
                              name: 'VENTES GLOBALES',
                              titleAdd: '${DateTime.now().year}',
                              amount: allSales,
                              additionalIcon: Icons.attach_money,
                              additionField: 'Taux de conversion',
                              showBottom: true,
                            ),
                            StatCards(
                              index: 2,
                              name: 'VENTES DU JOUR',
                              titleAdd: 'Auj.',
                              amount: dailySales,
                              additionalIcon: Icons.attach_money,
                              additionField: 'Taux de conversion',
                              showBottom: true,
                            ),
                            StatCards(
                              index: 3,
                              name: 'ACHATS GLOBAUX',
                              titleAdd: 'Global',
                              amount: allPurchases,
                              additionalIcon: AmazingIcon.shopping_cart_line,
                              additionField: 'Taux de conversion',
                              showBottom: true,
                            ),
                            StatCards(
                              index: 4,
                              name: 'ACHAT DE LA JOURNEE',
                              titleAdd: 'Auj.',
                              amount: dailyPurchases,
                              additionalIcon: AmazingIcon.shopping_cart_line,
                              additionField: 'Taux de conversion',
                              showBottom: true,
                            ),
                            StatCards(
                              index: 5,
                              name: 'BENEFICE GLOBAL',
                              titleAdd: 'Tout',
                              amount: allIncomes,
                              additionalIcon: AmazingIcon.bar_chart_line,
                              additionField: 'Taux de conversion',
                              showBottom: true,
                            ),
                            StatCards(
                              index: 6,
                              name: 'BENEFICE DE LA JOURNEE',
                              titleAdd: 'Auj.',
                              amount: dailyIncomes,
                              additionalIcon: AmazingIcon.bar_chart_line,
                              additionField: 'Taux de conversion',
                              showBottom: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 13.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myHeight(context) / 50.0),
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
                              horizontal: myHeight(context) / 50.0),
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
                                    return _sales == null || _sales.length == 0
                                        ? Center(
                                            child:
                                                Text('Aucune commande recente'))
                                        : Container(
                                            child: InkWell(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ManageSales())),
                                                child: Container(
                                                    height:
                                                        myHeight(context) / 5.8,
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
                                                                    myHeight(context) /
                                                                        110.0)),
                                                        border: Border.all(
                                                            color: Colors
                                                                .black54)),
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
                                                                ? Colors.orange
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
                                                                          FontWeight
                                                                              .w600),
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
                                                            Container(
                                                              width: myWidth(
                                                                  context),
                                                              height: 30.0,
                                                              child: ListView
                                                                  .builder(
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemCount:
                                                                          _productsOnSales[index]
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              ind) {
                                                                        return Text(
                                                                          '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']} ',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: myHeight(context) / 45.0),
                                                                        );
                                                                      }),
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  _sales[index]
                                                                              .status ==
                                                                          2
                                                                      ? 'Paye'
                                                                      : _sales[index].status ==
                                                                              1
                                                                          ? 'Servie'
                                                                          : 'En attente',
                                                                  style: TextStyle(
                                                                      color: _sales[index].status == 2
                                                                          ? Colors
                                                                              .green
                                                                          : _sales[index].status == 1
                                                                              ? Colors
                                                                                  .orange
                                                                              : gradient1,
                                                                      fontSize:
                                                                          screenSize(context).height /
                                                                              53.0),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          screenSize(context).height /
                                                                              60.0),
                                                                ),
                                                              ],
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
                        color: Color(0xffffffff).withOpacity(.89),
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
              return Container(
                height: myHeight(context) * .8,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(gradient1),
                  ),
                ),
              );
            })
        : buildContent();
  }
}

class StatCards extends StatelessWidget {
  final int index;
  final int amount;
  final String name;
  final String titleAdd;
  final String additionField;
  final IconData additionalIcon;
  final bool showBottom;
  const StatCards({
    @required this.index,
    Key key,
    this.amount,
    this.name,
    this.additionField,
    this.additionalIcon,
    this.titleAdd,
    this.showBottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: index == 1 ? 22.5 : 0.0, right: index == 6 ? 22.5 : 10.0),
      child: Container(
        width: myWidth(context) * .8,
        child: Card(
          shape: RoundedRectangleBorder(
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
                    Text('$name',
                        style: TextStyle(
                            color: Color(0xff000000).withOpacity(.55),
                            fontSize: myHeight(context) / 50.0)),
                    Spacer(),
                    Text(
                      '$titleAdd',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.55),
                          fontSize: myHeight(context) / 50.0),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: myHeight(context) / 40.0,
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$amount',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.55),
                          fontSize: myHeight(context) / 20.0),
                    ),
                    Text(
                      'FCFA',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.55),
                          fontSize: myHeight(context) / 35.0),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '$additionField',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.55),
                          fontSize: myHeight(context) / 45.0),
                    ),
                    Spacer(),
                    Icon(
                      additionalIcon,
                      size: myHeight(context) / 40.0,
                      color: gradient1,
                    )
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 150.0,
                ),
                showBottom
                    ? Container(
                        height: myHeight(context) / 150.0,
                        child: LinearProgressIndicator(
                          value: .8,
                          backgroundColor: Color(0xff000000).withOpacity(.2),
                          valueColor: AlwaysStoppedAnimation<Color>(gradient1),
                        ),
                      )
                    : Container(
                        height: 0.0,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
