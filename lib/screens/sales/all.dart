import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/sale.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/models/user_with_id.dart';
import 'package:easytrack/services/saleService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class SalePage extends StatefulWidget {
  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  Future _companySales;
  List _sales,
      _salesForSearch,
      _customers,
      _initiators,
      _validators,
      _sites,
      _productsOnSales;
  List allSalesData;
  bool _isLoading;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _controller;
  FocusNode _node;

  @override
  void initState() {
    super.initState();
    _companySales = fetchSales();
    _customers = [];
    _initiators = [];
    _validators = [];
    _salesForSearch = [];
    _productsOnSales = [];
    _node = FocusNode();
    _sites = [];
    _controller = new TextEditingController();
    _scaffoldKey = GlobalKey();
    _isLoading = false;
  }

  searchMethod(List items, filter) {
    List result = [];
    for (var item in items) {
      if (item.code.toLowerCase().contains(filter.toLowerCase())) {
        if (!result.contains(item)) {
          result.add(item);
        }
      }
      if (filter.contains('S'.toLowerCase())) {
        if (item.code
                .toLowerCase()
                .contains(filter.substring(5).toLowerCase()) ||
            item.code
                .toLowerCase()
                .contains(filter.substring(3).toLowerCase())) {
          if (!result.contains(item)) {
            result.add(item);
          }
        }
      }
    }
    return filter == '' ? items : result;
  }

  showBill(_customer, _site, _sale, _products, _initiator, {validator}) {
    int total = 0;
    for (var product in _products) {
      total += product['pivot']['price'] * product['pivot']['qty'];
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: myHeight(context) / 60,
                    horizontal: myHeight(context) / 100),
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'img/logos/LogoWhiteWithText.png',
                          color: textInverseModeColor,
                          height: myHeight(context) / 20.0,
                        ),
                        SizedBox(
                          height: myHeight(context) / 30.0,
                        ),
                        Text(
                          'Recu bon de vente',
                          style: TextStyle(
                              fontSize: myHeight(context) / 40.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: myHeight(context) / 30.0,
                        ),
                        Text(
                          'Snack: ${company.name}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Text(
                          'Site de ${_site.street}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        SizedBox(
                          height: myHeight(context) / 30.0,
                        ),
                        Text(
                          'Client: ${_customer.name}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Text(
                          'telephone: ${_site.tel1}',
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
                        Text(
                          'Date: ${_sale.createdAt}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Text(
                          'Reference: S0-${_sale.code}',
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
                          height: myHeight(context) / 30.0,
                        ),
                        Text(
                          'Initie par: ${_initiator.name}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        validator == null
                            ? Container(
                                height: 0.0,
                              )
                            : Text(
                                'Valide par: ${validator.name}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                        SizedBox(
                          height: myHeight(context) / 25.0,
                        ),
                        Container(
                          height: myHeight(context) / 12 * _products.length,
                          width: myWidth(context),
                          child: ListView.builder(
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
                                'Paye par: ${_sale.payingMethod}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: myHeight(context) / 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: myHeight(context) / 20.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  myHeight(context) / 20.0),
                              gradient: LinearGradient(
                                  colors: [gradient1, gradient2])),
                          child: Text(
                            'Envoyer au client',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textSameModeColor,
                                fontSize: myHeight(context) / 50.0),
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
                              borderRadius: BorderRadius.circular(
                                  myHeight(context) / 20.0),
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
            ),
          ],
        ),
      ),
    );
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
                    _companySales = fetchSales();
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
        /* 
        _customers.add(CustomerWithId.fromJson(sale['customer'])); */

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
      backgroundColor: Color(0xFFF8F8F8),
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: myWidth(context) / 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: myHeight(context) / 17.0,
                    margin: EdgeInsets.only(
                        top: myWidth(context) / 30.0,),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 10.0)),
                    child: TextFormField(
                      style: TextStyle(fontSize: myHeight(context) / 42.0),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            AmazingIcon.search_2_line,
                            color: Colors.black,
                            size: myHeight(context) / 40.0,
                          ),
                          hintText: 'Entrer du texte',
                          hintStyle:
                              TextStyle(fontSize: myHeight(context) / 42.0),
                          contentPadding: EdgeInsets.only(
                              left: myHeight(context) / 25.0,
                              top: myHeight(context) / 40.0),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 50.0,
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: myHeight(context) / 40.0,
                      ),
                      Text(
                        'Mes ventes',
                        style: TextStyle(
                          fontSize: myHeight(context) / 25.0,
                        ),
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
                  SizedBox(
                    height: myHeight(context) / 40.0,
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: _companySales,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            if (_sales == null) {
                              allSalesData = snapshot.data;
                              _sales = _checkAllSales(allSalesData)
                                  .map((sale) => Sale.fromJson(sale))
                                  .toList();
                              _salesForSearch = _sales;
                            }
                            return _sales == null || _sales.length == 0
                                ? Center(
                                    child: Text('Aucune vente'),
                                  )
                                : ListView.builder(
                                    itemCount: _sales.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: InkWell(
                                            child: Container(
                                                height: myHeight(context) / 6.4,
                                                margin: EdgeInsets.symmetric(
                                                  vertical:
                                                      myWidth(context) / 50.0,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
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
                                                          myWidth(context) /
                                                              30.0,
                                                      vertical:
                                                          myHeight(context) /
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
                                                        children: <Widget>[
                                                          Text(
                                                            'S0-${_sales[index].code}',
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
                                                        child: Container(
                                                          width:
                                                              myWidth(context),
                                                          height: 30.0,
                                                          child:
                                                              ListView.builder(
                                                                  physics: null,
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  itemCount: _productsOnSales[index]
                                                                              .length >
                                                                          1
                                                                      ? 1
                                                                      : _productsOnSales[
                                                                              index]
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          ind) {
                                                                    return Text(
                                                                      _productsOnSales[index].length >
                                                                              1
                                                                          ? '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}...'
                                                                          : '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: textInverseModeColor.withOpacity(
                                                                              .54),
                                                                          fontSize:
                                                                              myHeight(context) / 45.0),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: myHeight(
                                                                    context) /
                                                                200.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              _sales[index]
                                                                          .status ==
                                                                      2
                                                                  ? 'Paye'
                                                                  : _sales[index]
                                                                              .status ==
                                                                          1
                                                                      ? 'Servie'
                                                                      : 'En attente',
                                                              style: TextStyle(
                                                                  color: _sales[index]
                                                                              .status ==
                                                                          2
                                                                      ? Colors
                                                                          .green
                                                                      : _sales[index].status ==
                                                                              1
                                                                          ? Colors
                                                                              .orange
                                                                          : gradient1,
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          53.0),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              'Il y\'a ${formatDate(DateTime.parse(_sales[index].createdAt))}',
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
                                                ))),
                                      );
                                    },
                                  );
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

/* SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: backgroundColor,
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          myHeight(context) / 40.0,
                          myHeight(context) / 30.0,
                          myHeight(context) / 40.0,
                          myHeight(context) / 50.0 + 10.0),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: myHeight(context) / 17.0,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Hero(
                              tag: 'search',
                              child: Container(
                                height: myHeight(context) / 17.0,
                                child: TextFormField(
                                  controller: _controller,
                                  focusNode: _node,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(color: textInverseModeColor),
                                  onChanged: (value) {
                                    setState(() {
                                      _sales =
                                          searchMethod(_salesForSearch, value);
                                    });
                                  },
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      _sales =
                                          searchMethod(_salesForSearch, value);
                                      _controller.text = '';
                                    });
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          top: 10.0, left: 50.0),
                                      prefixIcon: Icon(
                                          AmazingIcon.search_2_line,
                                          color: textInverseModeColor,
                                          size: 20.0),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            _node.unfocus();
                                            _controller.text = '';
                                            _sales = _salesForSearch;
                                          },
                                          icon: Icon(AmazingIcon.close_fill,
                                              color: textInverseModeColor,
                                              size: 20.0)),
                                      hintText: 'Recherche...',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textInverseModeColor
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
                      )),
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
                          'Mes ventes',
                          style: TextStyle(
                              fontSize: myHeight(context) / 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () => _filterData(),
                            child: Icon(
                              AmazingIcon.list_settings_fill,
                              size: myHeight(context) / 25.0,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 40.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: myHeight(context) / 50.0),
                    child: Container(
                      width: myWidth(context),
                      height: myHeight(context) * .78,
                      child: FutureBuilder(
                          future: _companySales,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              if (_sales == null) {
                                allSalesData = snapshot.data;
                                _sales = _checkAllSales(allSalesData)
                                    .map((sale) => Sale.fromJson(sale))
                                    .toList();
                                _salesForSearch = _sales;
                              }
                              return _sales == null || _sales.length == 0
                                  ? Center(
                                      child: Text('Aucune vente'),
                                    )
                                  : ListView.builder(
                                      itemCount: _sales.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () => showBill(
                                                _customers[index],
                                                _sites[index],
                                                _sales[index],
                                                _productsOnSales[index],
                                                _initiators[index],
                                                validator: _validators[index]),
                                            child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10.0),
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
                                                        borderRadius: BorderRadius.circular(
                                                            myHeight(context) /
                                                                110.0),
                                                        border: Border.all(
                                                            color: textInverseModeColor
                                                                .withOpacity(.05))),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                                            children: <Widget>[
                                                              Text(
                                                                'S0-${_sales[index].code}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            30.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Spacer(),
                                                              Icon(
                                                                Icons.more_vert,
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
                                                            child: Container(
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
                                                                              color: textInverseModeColor.withOpacity(.54),
                                                                              fontSize: myHeight(context) / 45.0),
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
                                                                          .black26,
                                                                      fontSize:
                                                                          screenSize(context).height /
                                                                              60.0),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ))));
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
   */
