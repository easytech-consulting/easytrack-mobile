import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class SalePage extends StatefulWidget {
  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  List _sales, _initiators, _validators, _sites, _productsOnSales;
  List allSalesData;
  bool _isLoading;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _initiators = [];
    _validators = [];
    _productsOnSales = [];
    _sites = [];
    _scaffoldKey = GlobalKey();
    _isLoading = false;
    allSalesData = globalSales;
    _sales = _checkAllSales(allSalesData).toList();
  }

  showBill(String _customer, _site, _sale, _products, _initiator, {validator}) {
    int total = 0;
    for (var product in _products) {
      total += product['pivot']['price'] * product['pivot']['qty'];
    }
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: myHeight(context) / 30,
                horizontal: myHeight(context) / 25),
            height: myHeight(context) * .9,
            width: myWidth(context) * .9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'img/logos/LogoWhiteWithText.png',
                      color: textInverseModeColor,
                      height: myHeight(context) / 20.0,
                    ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    Text(
                      'Recu bon de vente',
                      style: TextStyle(
                          fontSize: myHeight(context) / 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    company == null
                        ? Container(
                            height: 0.0,
                          )
                        : Column(
                            children: [
                              Text(
                                'Snack: ${company.name}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                              Text(
                                'Telephone: ${company.tel1}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                              Text(
                                '${company.town}, ${company.street}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                              SizedBox(
                                height: myHeight(context) / 50.0,
                              ),
                            ],
                          ),
                    Text(
                      'Site: ${_site.name}',
                      style: TextStyle(
                        fontSize: myHeight(context) / 50.0,
                      ),
                    ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    Text(
                      '${_site.street}',
                      style: TextStyle(
                        fontSize: myHeight(context) / 50.0,
                      ),
                    ),
                    _site.tel1 != null
                        ? Text(
                            '${_site.tel1}',
                            style: TextStyle(
                              fontSize: myHeight(context) / 50.0,
                            ),
                          )
                        : _site["tel2"] != null
                            ? Text(
                                '${_site["tel2"]}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              )
                            : Container(
                                height: 0.0,
                              ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    Text(
                      'Client: ${capitalize(_customer)}',
                      style: TextStyle(
                        fontSize: myHeight(context) / 50.0,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: myHeight(context) / 50.0,
                        ),
                        Text(
                          'Date: ${_sale["created_at"]}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Reference: S0-${_sale["code"]}',
                      style: TextStyle(
                        fontSize: myHeight(context) / 50.0,
                      ),
                    ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    Text(
                      'Initie par: ${_initiator["name"]}',
                      style: TextStyle(
                        fontSize: myHeight(context) / 50.0,
                      ),
                    ),
                    validator == null
                        ? Container(
                            height: 0.0,
                          )
                        : Text(
                            'Valide par: ${validator["name"]}',
                            style: TextStyle(
                              fontSize: myHeight(context) / 50.0,
                            ),
                          ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    Container(
                      height: myHeight(context) / 12.0 * _products.length,
                      child: ListView.builder(
                        physics: null,
                        itemCount: _products.length,
                        itemBuilder: (context, index) => Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${_products[index]['name']}',
                                  style: TextStyle(
                                    fontSize: myHeight(context) / 50.0,
                                  ),
                                )),
                            SizedBox(
                              height: myHeight(context) / 100.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${_products[index]['pivot']['qty']} x ${_products[index]['pivot']['price']}',
                                  style: TextStyle(
                                    fontSize: myHeight(context) / 50.0,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${_products[index]['pivot']['qty'] * _products[index]['pivot']['price']}',
                                  style: TextStyle(
                                    fontSize: myHeight(context) / 50.0,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: myHeight(context) / 100.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight(context) / 100.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Sous total',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '$total',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: myHeight(context) / 100.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '$total',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    Container(
                      color: Colors.blueGrey.withOpacity(.3),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: myHeight(context) / 100.0,
                            horizontal: 1.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Paye par: ${_sale["paying_method"].toUpperCase()}',
                            style: TextStyle(
                              fontSize: myHeight(context) / 50.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight(context) / 40.0,
                    ),
                    InkWell(
                      onTap: () => launchWhatsApp(phone: '', message: ''),
                      child: Container(
                        width: double.infinity,
                        height: myHeight(context) / 20.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(myHeight(context) / 20.0),
                            gradient:
                                LinearGradient(colors: [gradient1, gradient2])),
                        child: Text(
                          'Envoyer au client',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textSameModeColor,
                              fontSize: myHeight(context) / 50.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight(context) / 100.0,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: myHeight(context) / 20.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: textInverseModeColor),
                          borderRadius:
                              BorderRadius.circular(myHeight(context) / 20.0),
                        ),
                        child: Text(
                          'Retour',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: myHeight(context) / 50.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  List _checkAllSales(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var sale in datas) {
        _initiators.add(sale['initiator']);
        _validators.add(sale['validator']);
        _productsOnSales.add(sale['products']);
        _sites.add(site);

        result.add(sale);
      }
    } else {
      for (var site in datas) {
        for (var sale in site['sales']) {
          if (!result.contains(sale)) {
            _initiators.add(sale['initiator']);
            _productsOnSales.add(sale['products']);
            _validators.add(sale['validator']);
            _sites.add(SiteWithId.fromJson(site));
            /* 
            _customers.add(CustomerWithId.fromJson(sale['customer'])); */

            result.add(sale);
          }
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('sales').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    slivers: [
                      sliverHeader2(context, 'Mon site', 'Mes ventes', 0),
                      _sites == null || _sites.length == 0
                          ? SliverList(
                              delegate: SliverChildListDelegate.fixed([
                                Container(
                                  height: myHeight(context) / 1.5,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Aucune vente',
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 50.0),
                                  ),
                                )
                              ]),
                            )
                          : SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: index == 0
                                            ? 0.0
                                            : myHeight(context) / 100.0,
                                        horizontal: myHeight(context) / 40.0),
                                    child: Container(
                                        height: myHeight(context) / 6.4,
                                        margin: EdgeInsets.symmetric(
                                          vertical: myWidth(context) / 50.0,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    myHeight(context) / 90.0)),
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.black
                                                    .withOpacity(.1))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  myWidth(context) / 30.0,
                                              vertical:
                                                  myHeight(context) / 70.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () => showBill(
                                                        'Passager',
                                                        _sites[index],
                                                        _sales[index],
                                                        _productsOnSales[index],
                                                        _initiators[index],
                                                        validator:
                                                            _validators[index]),
                                                    child: Text(
                                                      'S0-${_sales[index]["code"]}',
                                                      style: TextStyle(
                                                          fontSize: myHeight(
                                                                  context) /
                                                              33.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.more_vert,
                                                    size:
                                                        myWidth(context) / 16.0,
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              Expanded(
                                                child: Container(
                                                  width: myWidth(context),
                                                  child: ListView.builder(
                                                      physics: null,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          _productsOnSales[
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
                                                          _productsOnSales[
                                                                          index]
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
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  45.0),
                                                        );
                                                      }),
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    _sales[index]["status"] == 2
                                                        ? 'Paye'
                                                        : _sales[index][
                                                                    "status"] ==
                                                                1
                                                            ? 'Servie'
                                                            : 'En attente',
                                                    style: TextStyle(
                                                        color: _sales[index][
                                                                    'status'] ==
                                                                2
                                                            ? Colors.green
                                                            : _sales[index][
                                                                        'status'] ==
                                                                    1
                                                                ? Colors.orange
                                                                : gradient1,
                                                        fontSize:
                                                            screenSize(context)
                                                                    .height /
                                                                53.0),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${formatDate(DateTime.parse(_sales[index]["created_at"]))}',
                                                    style: TextStyle(
                                                        color: Colors.black26,
                                                        fontSize:
                                                            screenSize(context)
                                                                    .height /
                                                                60.0),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )));
                              }, childCount: _sales.length),
                            )
                    ],
                  );
                }

                return CustomScrollView(
                  slivers: [
                    sliverHeader2(context, 'Mon site', 'Mes ventes', 0),
                    SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        Container(
                            height: myHeight(context) / 1.5,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(gradient1),
                            ))
                      ]),
                    )
                  ],
                );
              },
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
      ),
    );
  }
}
