import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/services/productService.dart';
import 'package:easytrack/services/saleService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class ManageSales extends StatefulWidget {
  @override
  _ManageSalesState createState() => _ManageSalesState();
}

class _ManageSalesState extends State<ManageSales> {
  bool selectionMode = false;
  bool selectedItem = false;
  bool _salesAlreadyLoad;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchNode = FocusNode();
  List _salesForSearch = [];

  Future _companySales;
  Map product, currentSite;
  List _sales,
      _sites,
      _salesToShow,
      sitesToShow,
      _productsOnOrder,
      _quantities,
      products;
  List allSalesData;
  bool _isLoading;
  int _currentIndex;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  PageController _pageController;
  String _paymentMode;

  searchMethod(List items, filter) {
    List result = [];
    for (var item in items) {
      if (item['code'].toLowerCase().contains(filter.toLowerCase())) {
        if (!result.contains(item)) {
          result.add(item);
        }
      }
      if (filter.contains('S'.toLowerCase())) {
        if (item['code']
                .toLowerCase()
                .contains(filter.substring(5).toLowerCase()) ||
            item['code']
                .toLowerCase()
                .contains(filter.substring(3).toLowerCase())) {
          if (!result.contains(item)) {
            result.add(item);
          }
        }
      }
      if (item['validator']['name']
              .toLowerCase()
              .contains(filter.toLowerCase()) ||
          item['initiator']['name'].toLowerCase() == filter.toLowerCase()) {
        if (!result.contains(item)) {
          result.add(item);
        }
      } else if (item['products'].firstWhere(
          (element) => element['name'].toLowerCase() == filter.toLowerCase())) {
        result.add(item);
      }

      print(item['validator']['name']
          .toLowerCase()
          .contains(filter.toLowerCase()));
    }
    return filter == '' ? items : result;
  }

  @override
  void initState() {
    super.initState();
    _companySales = fetchSales();
    _salesAlreadyLoad = false;
    _paymentMode = 'cash';
    _salesToShow = [];
    _quantities = [];
    _productsOnOrder = [];
    _sites = [];
    _currentIndex = 0;
    _scaffoldKey = GlobalKey();
    _formKey = GlobalKey();
    _isLoading = false;
    _pageController = new PageController();
  }

  _changeSaleStatus(int newStatus, int saleId) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> params = Map();
    params['status'] = newStatus.toString();
    await changeSaleState(params, saleId).then((success) {
      setState(() {
        _isLoading = false;
        _salesAlreadyLoad = false;
        _companySales = fetchSales();
      });
    });
  }

  _validateSale(id) async {
    setState(() {
      _isLoading = true;
    });
    await validateSale(id).then((success) {
      setState(() {
        _isLoading = false;
        _salesAlreadyLoad = false;
        _companySales = fetchSales();
      });
    });
  }

  _invalidateSale(id) async {
    setState(() {
      _isLoading = true;
    });
    await invalidateSale(id).then((success) {
      setState(() {
        _isLoading = false;
        _salesAlreadyLoad = false;
        _companySales = fetchSales();
      });
    });
  }

  showBill(_customer, _site, _sale, _initiator, {validator}) {
    int total = 0;
    for (var product in _sale['products']) {
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
                        company == null
                            ? Text(
                                'Site: ${_site.name}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              )
                            : Text(
                                'Snack: ${company.name ?? _site.name}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                        company == null
                            ? Container(
                                height: 0.0,
                              )
                            : Text(
                                'Site de ${_site.street}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                        SizedBox(
                          height: myHeight(context) / 30.0,
                        ),
                        Text(
                          'Client: ${_customer['name']}',
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
                        SizedBox(
                          height: myHeight(context) / 50.0,
                        ),
                        Text(
                          'Date: ${_sale['created_at'] == null ? DateTime.now().year.toString() + '-' + DateTime.now().month.toString() + '-' + DateTime.now().day.toString() : _sale['created_at']}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Text(
                          'Reference: S0-${_sale['code']}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        company == null
                            ? Container(
                                height: 0.0,
                              )
                            : Text(
                                '${company.town ?? 'Yaounde'}, ${company.street ?? 'Cameroun'}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                        SizedBox(
                          height: myHeight(context) / 30.0,
                        ),
                        Text(
                          'Initie par: ${_initiator['name']}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        validator == null
                            ? Container(
                                height: 0.0,
                              )
                            : Text(
                                'Valide par: ${validator['name']}',
                                style: TextStyle(
                                  fontSize: myHeight(context) / 50.0,
                                ),
                              ),
                        SizedBox(
                          height: myHeight(context) / 25.0,
                        ),
                        Container(
                          height:
                              myHeight(context) / 12 * _sale['products'].length,
                          width: myWidth(context),
                          child: ListView.builder(
                            itemCount: _sale['products'].length,
                            itemBuilder: (context, index) => Column(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${_sale['products'][index]['name']}',
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
                                      '${_sale['products'][index]['pivot']['qty']} x ${_sale['products'][index]['pivot']['price']}',
                                      style: TextStyle(
                                        fontSize: myHeight(context) / 50.0,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${_sale['products'][index]['pivot']['qty'] * _sale['products'][index]['pivot']['price']}',
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
                                'Paye par: ${_sale['paying_method']}',
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            launchWhatsApp(
                                phone: "+2376991177985",
                                message: 'Recu de commande ${_site.name}');
                          },
                          child: Container(
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

  showSnackBar(
      GlobalKey<ScaffoldState> _key, int status, int saleId, currentIndex) {
    _key.currentState.showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      duration: Duration(seconds: 30),
      backgroundColor: textSameModeColor,
      content: Container(
        height: status == 2
            ? _salesToShow[currentIndex]['validator'] == null ||
                    _salesToShow[currentIndex]['validator']['id'] != user.id
                ? myHeight(context) * 2.5 / 15
                : myHeight(context) * 3.5 / 15
            : myHeight(context) * 4 / 15,
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
            status != 0
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _changeSaleStatus(1, saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.account_circle_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Servir commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            status != 1
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _changeSaleStatus(2, saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.shopping_cart_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Payer commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            _salesToShow[currentIndex]['validator'] == null
                ? Container(height: 0.0)
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      showBill(
                          _salesToShow[currentIndex]['customer'],
                          _sites[currentIndex],
                          _salesToShow[currentIndex],
                          _salesToShow[currentIndex]['initiator'],
                          validator: _salesToShow[currentIndex]['validator']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.repeat_2_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Voir la facture',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            userRole['slug'] == 'server' ||
                    _salesToShow[currentIndex]['validator'] != null
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _validateSale(saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.repeat_2_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Valider Commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            _salesToShow[currentIndex]['validator'] == null ||
                    _salesToShow[currentIndex]['validator']['id'] != user.id
                ? Container(
                    height: 0.0,
                  )
                : InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _currentIndex = 0;
                      _invalidateSale(saleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            AmazingIcon.account_circle_line,
                            size: 15.0,
                            color: gradient1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Invalider commande',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            status == 2
                ? Container(
                    height: 0.0,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          AmazingIcon.edit_2_line,
                          size: 15.0,
                          color: gradient1,
                        ),
                        InkWell(
                          onTap: () async {
                            _scaffoldKey.currentState.hideCurrentSnackBar();
                            if (sitesToShow == null) {
                              setState(() {
                                _isLoading = true;
                              });
                              await fetchProductsOfSnack().then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                                sitesToShow = _fieldValues(value);
                                updateSales(
                                    _salesToShow[currentIndex],
                                    user.isAdmin == 1
                                        ? sitesToShow
                                        : checkSiteProduct(
                                            sitesToShow,
                                            _salesToShow[currentIndex]
                                                ['site_id']),
                                    _salesToShow[currentIndex]['products']);
                              });
                            } else {
                              updateSales(
                                  _salesToShow[currentIndex],
                                  user.isAdmin == 1
                                      ? sitesToShow
                                      : checkSiteProduct(
                                          sitesToShow,
                                          _salesToShow[currentIndex]
                                              ['site_id']),
                                  _salesToShow[currentIndex]['products']);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Modifier',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: textInverseModeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            InkWell(
              onTap: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
                /* 
                _deleteSite(index); */
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      AmazingIcon.delete_bin_6_line,
                      size: 15.0,
                      color: redColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Supprimer',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
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

  checkSiteProduct(sites, siteId) {
    Map result;
    for (var site in sites) {
      if (site['id'] == siteId) {
        result = site;
      }
    }
    return result == null ? [] : result['products'];
  }

  _cancelMode(GlobalKey<ScaffoldState> _key) {
    setState(() {
      selectionMode = false;
    });
  }

  loadDesireSales(datas, {int filter = 0}) {
    _salesToShow.clear();
    _salesAlreadyLoad = true;
    for (var data in datas) {
      if (data['status'] == filter) {
        _salesToShow.add(data);
      }
    }
  }

  updateSales(sale, List products, productsAlreadyInOrder) {
    _quantities = [];
    _productsOnOrder = [];
    List allProducts = [];
    int total = 0;
    for (var product in products) {
      if (!allProducts.contains(product)) {
        allProducts.add(product);
      }
    }
    for (var product in productsAlreadyInOrder) {
      _quantities.add(product['pivot']['qty']);
      _productsOnOrder.add(allProducts.firstWhere(
          (element) => element['id'] == product['id'],
          orElse: () => print('Pas de correspondance.')));
      total += product['pivot']['qty'] * product['pivot']['price'];
    }
    showDialog(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return ListView(
                children: <Widget>[
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: myHeight(context) / 60,
                          horizontal: myHeight(context) / 100),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          height: myHeight(context) * .8,
                          width: myWidth(context),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Modifier',
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 28.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        for (var product in _productsOnOrder) {
                                          allProducts.add(product);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Icon(AmazingIcon.close_line)),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: myHeight(context) / 15.0,
                                    decoration: buildTextFormFieldContainer(
                                        decorationColor),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      underline: Text(''),
                                      icon: Icon(AmazingIcon.arrow_down_s_line,
                                          color: textInverseModeColor),
                                      items: allProducts
                                          .map((product) => DropdownMenuItem(
                                                child: Text(product['name']),
                                                value: product,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        if (_productsOnOrder.contains(value)) {
                                          setState(() {
                                            total += value['pivot']['price'];
                                            _quantities[_productsOnOrder
                                                .indexOf(value)]++;
                                          });
                                        } else {
                                          setState(() {
                                            allProducts.remove(value);
                                            _productsOnOrder.add(value);
                                            total += value['pivot']['price'];

                                            _quantities.add(1);
                                          });
                                        }
                                      },
                                      hint: Text('Ajouter un produit'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                child:
                                    _productsOnOrder.isEmpty ||
                                            _productsOnOrder == null
                                        ? Center(child: Text('Aucun produit'))
                                        : ListView.builder(
                                            itemCount: _productsOnOrder.length,
                                            itemBuilder: (context, int index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: myHeight(context) /
                                                        100),
                                                child: Container(
                                                  height:
                                                      myHeight(context) / 7.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                          color:
                                                              textInverseModeColor
                                                                  .withOpacity(
                                                                      .12))),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: myHeight(
                                                                    context) /
                                                                50.0,
                                                            vertical: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${_productsOnOrder[index]['name'].length > 7 ? _productsOnOrder[index]['name'].substring(0, 7) + '...' : _productsOnOrder[index]['name']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            36.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.0,
                                                                ),
                                                                Text(
                                                                    '${_productsOnOrder[index]['pivot']['price']} FCFA',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          myHeight(context) /
                                                                              43.0,
                                                                    )),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 35.0,
                                                              child:
                                                                  VerticalDivider(
                                                                thickness: 1.0,
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        total -=
                                                                            _productsOnOrder[index]['pivot']['price'];
                                                                      });
                                                                      if (_quantities[
                                                                              index] ==
                                                                          1) {
                                                                        setState(
                                                                            () {
                                                                          allProducts
                                                                              .add(_productsOnOrder[index]);
                                                                          _productsOnOrder
                                                                              .removeAt(index);
                                                                          _quantities
                                                                              .removeAt(index);
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _quantities[
                                                                              index]--;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .remove),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.0,
                                                                  ),
                                                                  Text(
                                                                    '${_quantities[index]}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            myHeight(context) /
                                                                                28.0,
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.0,
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (_productsOnOrder[index]['pivot']['qty'] >
                                                                            _quantities[index]) {
                                                                          setState(
                                                                              () {
                                                                            total +=
                                                                                _productsOnOrder[index]['pivot']['price'];
                                                                            _quantities[index]++;
                                                                          });
                                                                        }
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .add)),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      'SOUS TOTAL',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            65.0,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          '  ${_quantities[index] * _productsOnOrder[index]['pivot']['price']} FCFA',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            myHeight(context) /
                                                                                55.0,
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  total -= _quantities[
                                                                          index] *
                                                                      _productsOnOrder[index]
                                                                              [
                                                                              'pivot']
                                                                          [
                                                                          'price'];
                                                                  allProducts.add(
                                                                      _productsOnOrder[
                                                                          index]);
                                                                  _quantities
                                                                      .removeAt(
                                                                          index);
                                                                  _productsOnOrder
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: Icon(
                                                                AmazingIcon
                                                                    .delete_bin_6_line,
                                                                color:
                                                                    Colors.red,
                                                                size: myHeight(
                                                                        context) /
                                                                    40.0,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('TOTAL:',
                                      style: TextStyle(
                                        fontSize: myHeight(context) / 55.0,
                                      )),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('$total FCFA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: myHeight(context) / 45.0,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _attemptUpdate(
                                      sale, _productsOnOrder, _quantities);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [gradient1, gradient2]),
                                      borderRadius:
                                          BorderRadius.circular(40.0)),
                                  child: Text(
                                    'Mettre a jour',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: textSameModeColor,
                                    ),
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
              );
            }));
  }

  _attemptUpdate(sale, List products, List quantities) async {
    Navigator.pop(context);

    String order = '';
    for (var i = 0; i < products.length; i++) {
      order += products[i]['id'].toString() +
          ';' +
          quantities[i].toString() +
          ';' +
          products[i]['pivot']['price'].toString() +
          '|';
    }

    Map<String, dynamic> params = Map();
    params['order'] = order;
    params['customer_id'] = sale['customer_id'].toString();
    params['site_id'] = sale['site_id'].toString();
    params['status'] = sale['status'].toString();
    params['paying_method'] = sale['paying_method'].toString();
    params['sale_note'] = '';
    print(params);
    setState(() {
      _isLoading = true;
    });
    await updateSale(params, sale['id']).then((response) {
      setState(() {
        _isLoading = false;
        _salesAlreadyLoad = false;
        _currentIndex = 0;
        _companySales = fetchSales();
      });
    });
  }

  addSales({List sites}) {
    _productsOnOrder.clear();
    _quantities.clear();
    int total = 0;
    showDialog(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return ListView(
                children: <Widget>[
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: myHeight(context) / 60,
                          horizontal: myHeight(context) / 100),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          height: myHeight(context) * .8,
                          width: myWidth(context),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Ajouter',
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 28.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        for (var product in _productsOnOrder) {
                                          if (user.isAdmin == 1) {
                                            sites.add(product);
                                          } else {
                                            products.add(product);
                                          }
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Icon(AmazingIcon.close_line)),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              user.isAdmin == 1
                                  ? Container(
                                      height: 0.0,
                                    )
                                  : Stack(
                                      children: <Widget>[
                                        Container(
                                          height: myHeight(context) / 15.0,
                                          decoration:
                                              buildTextFormFieldContainer(
                                                  decorationColor),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: DropdownButton<
                                              Map<String, dynamic>>(
                                            isExpanded: true,
                                            underline: Text(''),
                                            icon: Icon(
                                                AmazingIcon.arrow_down_s_line,
                                                color: textInverseModeColor),
                                            items: sites
                                                .map((site) => DropdownMenuItem<
                                                        Map<String, dynamic>>(
                                                      child: Text(site['name']),
                                                      value: site,
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != currentSite) {
                                                setState(() {
                                                  total = 0;
                                                  _productsOnOrder.clear();
                                                  _quantities.clear();
                                                  currentSite = value;
                                                  products = value['products'];
                                                });
                                              }
                                            },
                                            value: currentSite,
                                            hint: Text('Selectionner un site'),
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: myHeight(context) / 15.0,
                                    decoration: buildTextFormFieldContainer(
                                        decorationColor),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: DropdownButton<Map<String, dynamic>>(
                                      isExpanded: true,
                                      underline: Text(''),
                                      icon: Icon(AmazingIcon.arrow_down_s_line,
                                          color: textInverseModeColor),
                                      items: user.isAdmin == 1
                                          ? sites
                                              .map((site) => DropdownMenuItem<
                                                      Map<String, dynamic>>(
                                                    child: Text(site['name']),
                                                    value: site,
                                                  ))
                                              .toList()
                                          : products == null
                                              ? []
                                              : products
                                                  .map((product) =>
                                                      DropdownMenuItem<
                                                          Map<String, dynamic>>(
                                                        child: Text(
                                                            product['name']),
                                                        value: product,
                                                      ))
                                                  .toList(),
                                      onChanged: (value) {
                                        if (user.isAdmin == 1) {
                                          setState(() {
                                            sites.remove(value);
                                            _productsOnOrder.add(value);
                                            total += value['pivot']['price'];

                                            _quantities.add(1);
                                          });
                                        } else {
                                          setState(() {
                                            products.remove(value);
                                            _productsOnOrder.add(value);
                                            total += value['pivot']['price'];

                                            _quantities.add(1);
                                          });
                                        }
                                      },
                                      hint: Text('Selectionner un produit'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                child:
                                    _productsOnOrder.isEmpty ||
                                            _productsOnOrder == null
                                        ? Center(child: Text('Aucun produit'))
                                        : ListView.builder(
                                            itemCount: _productsOnOrder.length,
                                            itemBuilder: (context, int index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: myHeight(context) /
                                                        100),
                                                child: Container(
                                                  height:
                                                      myHeight(context) / 7.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                          color:
                                                              textInverseModeColor
                                                                  .withOpacity(
                                                                      .12))),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: myHeight(
                                                                    context) /
                                                                50.0,
                                                            vertical: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${_productsOnOrder[index]['name'].length > 7 ? _productsOnOrder[index]['name'].substring(0, 7) + '...' : _productsOnOrder[index]['name']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            36.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8.0,
                                                                ),
                                                                Text(
                                                                    '${_productsOnOrder[index]['pivot']['price']} FCFA',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          myHeight(context) /
                                                                              43.0,
                                                                    )),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 35.0,
                                                              child:
                                                                  VerticalDivider(
                                                                thickness: 1.0,
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        total -=
                                                                            _productsOnOrder[index]['pivot']['price'];
                                                                      });
                                                                      if (_quantities[
                                                                              index] ==
                                                                          1) {
                                                                        setState(
                                                                            () {
                                                                          user.isAdmin == 1
                                                                              ? sites.add(_productsOnOrder[index])
                                                                              : products.add(_productsOnOrder[index]);
                                                                          _productsOnOrder
                                                                              .removeAt(index);
                                                                          _quantities
                                                                              .removeAt(index);
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _quantities[
                                                                              index]--;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .remove),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.0,
                                                                  ),
                                                                  Text(
                                                                    '${_quantities[index]}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            myHeight(context) /
                                                                                28.0,
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.0,
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (_productsOnOrder[index]['pivot']['qty'] >
                                                                            _quantities[index]) {
                                                                          setState(
                                                                              () {
                                                                            total +=
                                                                                _productsOnOrder[index]['pivot']['price'];
                                                                            _quantities[index]++;
                                                                          });
                                                                        }
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .add)),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      'SOUS TOTAL',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            65.0,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          '  ${_quantities[index] * _productsOnOrder[index]['pivot']['price']} FCFA',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            myHeight(context) /
                                                                                55.0,
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  total -= _quantities[
                                                                          index] *
                                                                      _productsOnOrder[index]
                                                                              [
                                                                              'pivot']
                                                                          [
                                                                          'price'];
                                                                  user.isAdmin ==
                                                                          1
                                                                      ? sites.add(
                                                                          _productsOnOrder[
                                                                              index])
                                                                      : products.add(
                                                                          _productsOnOrder[
                                                                              index]);
                                                                  _quantities
                                                                      .removeAt(
                                                                          index);
                                                                  _productsOnOrder
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              child: Icon(
                                                                AmazingIcon
                                                                    .delete_bin_6_line,
                                                                color:
                                                                    Colors.red,
                                                                size: myHeight(
                                                                        context) /
                                                                    40.0,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: myHeight(context) / 40.0,
                                    child: DropdownButton(
                                      underline: Text(''),
                                      icon: Icon(
                                          AmazingIcon.arrow_drop_down_line,
                                          size: myHeight(context) / 50),
                                      items: [
                                        DropdownMenuItem(
                                            child: Text('Cash',
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            50.0)),
                                            value: 'cash'),
                                        DropdownMenuItem(
                                            child: Text('OM',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            50.0)),
                                            value: 'OM'),
                                        DropdownMenuItem(
                                            child: Text('MoMo',
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            50.0)),
                                            value: 'MoMo')
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _paymentMode = value;
                                        });
                                      },
                                      value: _paymentMode,
                                    ),
                                  ),
                                  Spacer(),
                                  Text('TOTAL:',
                                      style: TextStyle(
                                        fontSize: myHeight(context) / 55.0,
                                      )),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('$total FCFA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: myHeight(context) / 45.0,
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (currentSite != null ||
                                      user.isAdmin == 1) {
                                    _attemptSave(
                                        _productsOnOrder,
                                        _quantities,
                                        user.isAdmin == 1
                                            ? site.id
                                            : currentSite['id']);
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [gradient1, gradient2]),
                                      borderRadius:
                                          BorderRadius.circular(40.0)),
                                  child: Text(
                                    'Enregistrer',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: textSameModeColor,
                                    ),
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
              );
            }));
  }

  _attemptSave(List products, List quantities, int siteId) async {
    Navigator.pop(context);

    String order = '';
    for (var i = 0; i < products.length; i++) {
      order += products[i]['id'].toString() +
          ';' +
          quantities[i].toString() +
          ';' +
          products[i]['pivot']['price'].toString() +
          '|';
    }

    Map<String, dynamic> params = Map();
    params['order'] = order;
    params['site_id'] = siteId.toString();
    params['customer_id'] = '3';
    params['status'] = '0';
    params['paying_method'] = _paymentMode;
    params['sale_note'] = '';
    setState(() {
      _isLoading = true;
    });
    await storeSale(params).then((response) {
      setState(() {
        _isLoading = false;
        _salesAlreadyLoad = false;
        _companySales = fetchSales();
      });
    });
  }

  List _fieldValues(datas) {
    List result = [];
    for (var site in datas) {
      if (!result.contains(site)) {
        result.add(site);
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
                    _salesAlreadyLoad = false;
                    _currentIndex = 0;
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
        /* if (!_sites.contains(site)) {
                _sites.add(site);
              } */

        _sites.add(site);
        result.add(sale);
      }
    } else {
      for (var site in datas) {
        for (var sale in site['sales']) {
          _sites.add(SiteWithId.fromJson(site));

          result.add(sale);
        }
      }
    }

    return result;
  }

  calculTotal(List datas) {
    int total = 0;
    for (var data in datas) {
      total += data['pivot']['price'] * data['pivot']['qty'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        key: _scaffoldKey,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(
            15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _currentIndex == 0
                  ? Container(
                      height: myHeight(context) / 100.0,
                      width: myHeight(context) / 38.0,
                      decoration: BoxDecoration(
                          color: gradient1,
                          borderRadius: BorderRadius.circular(10.0)),
                    )
                  : Container(
                      height: myHeight(context) / 100.0,
                      width: myHeight(context) / 70.0,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
              SizedBox(
                width: myHeight(context) / 100.0,
              ),
              user.isAdmin == 1 && userRole['slug'] == 'server'
                  ? Container(
                      height: 0.0,
                      width: 0.0,
                    )
                  : Row(
                      children: <Widget>[
                        _currentIndex == 1
                            ? Container(
                                height: myHeight(context) / 100.0,
                                width: myHeight(context) / 38.0,
                                decoration: BoxDecoration(
                                    color: gradient1,
                                    borderRadius: BorderRadius.circular(10.0)),
                              )
                            : Container(
                                height: myHeight(context) / 100.0,
                                width: myHeight(context) / 70.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                        SizedBox(
                          width: myHeight(context) / 100.0,
                        ),
                        _currentIndex == 2
                            ? Container(
                                height: myHeight(context) / 100.0,
                                width: myHeight(context) / 38.0,
                                decoration: BoxDecoration(
                                    color: gradient1,
                                    borderRadius: BorderRadius.circular(10.0)),
                              )
                            : Container(
                                height: myHeight(context) / 100.0,
                                width: myHeight(context) / 70.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                      ],
                    )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 46.0,
                                  decoration: buildTextFormFieldContainer(
                                      decorationColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 46.0,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(
                                        color: textInverseModeColor
                                            .withOpacity(.87)),
                                    controller: _searchController,
                                    focusNode: _searchNode,
                                    onChanged: (value) {
                                      setState(() {
                                        _sales = searchMethod(
                                            _salesForSearch, value);
                                        loadDesireSales(_sales);
                                      });
                                    },
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        _sales = searchMethod(
                                            _salesForSearch, value);
                                        loadDesireSales(_sales);
                                        _searchController.text = '';
                                      });
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 50.0),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            _searchController.text = '';
                                            _searchNode.unfocus();
                                            _sales = _salesForSearch;
                                            loadDesireSales(_sales);
                                          },
                                          child: Icon(AmazingIcon.close_fill,
                                              color: textInverseModeColor),
                                        ),
                                        hintText: 'Recherche...',
                                        prefixIcon: Icon(
                                            AmazingIcon.search_2_line,
                                            color: textInverseModeColor),
                                        hintStyle: TextStyle(
                                            color: textInverseModeColor
                                                .withOpacity(.35),
                                            fontSize: 18.0),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              AmazingIcon.arrow_down_s_line,
                              size: myHeight(context) / 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 20.0,
                  ),
                  Container(
                    height: myHeight(context) * .8,
                    child: FutureBuilder(
                        future: _companySales,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            if (_sales == null) {
                              allSalesData = snapshot.data;
                              _sales = _checkAllSales(allSalesData);
                              _salesForSearch = _sales;
                              if (!_salesAlreadyLoad) {
                                loadDesireSales(_sales);
                              }
                            }
                            return PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                  loadDesireSales(_sales, filter: index);
                                });
                              },
                              children:
                                  user.isAdmin == 1 &&
                                          userRole['slug'] == 'server'
                                      ? <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.brightness_1,
                                                      color: gradient1,
                                                      size: 26,
                                                    ),
                                                    SizedBox(
                                                      width: 11.0,
                                                    ),
                                                    Text(
                                                      'En attente',
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (sitesToShow ==
                                                            null) {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          await fetchProductsOfSnack()
                                                              .then((value) {
                                                            setState(() {
                                                              _isLoading =
                                                                  false;
                                                            });
                                                            sitesToShow =
                                                                _fieldValues(
                                                                    value);
                                                            addSales(
                                                                sites:
                                                                    sitesToShow);
                                                          });
                                                        } else {
                                                          addSales(
                                                              sites:
                                                                  sitesToShow);
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        size:
                                                            myHeight(context) /
                                                                26.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: myHeight(context) /
                                                          50.0,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () =>
                                                            selectionMode
                                                                ? _cancelMode(
                                                                    _scaffoldKey)
                                                                : _filterData(),
                                                        child: Icon(selectionMode
                                                            ? AmazingIcon
                                                                .close_line
                                                            : AmazingIcon
                                                                .list_settings_fill)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Expanded(
                                                  child:
                                                      _salesToShow == null ||
                                                              _salesToShow
                                                                      .length ==
                                                                  0
                                                          ? Center(
                                                              child: Text(
                                                                  'Aucune vente'),
                                                            )
                                                          : ListView.builder(
                                                              itemCount:
                                                                  _salesToShow
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          15.0,
                                                                          0.0,
                                                                          15.0,
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        screenSize(context).height /
                                                                            5.0,
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Stack(
                                                                      fit: StackFit
                                                                          .expand,
                                                                      children: <
                                                                          Widget>[
                                                                        AnimatedContainer(
                                                                          curve:
                                                                              Curves.bounceInOut,
                                                                          duration:
                                                                              Duration(seconds: 4),
                                                                          decoration: BoxDecoration(
                                                                              color: textSameModeColor,
                                                                              border: Border.all(color: textInverseModeColor.withOpacity(.12)),
                                                                              borderRadius: BorderRadius.circular(10.0)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(10.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      'S0-${_salesToShow[index]['code']}',
                                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 26.0),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    userRole['slug'] == 'storekeeper'
                                                                                        ? Container(
                                                                                            height: 0.0,
                                                                                          )
                                                                                        : GestureDetector(
                                                                                            onTap: () => showSnackBar(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index),
                                                                                            child: Icon(Icons.more_vert, size: myHeight(context) / 25.0),
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: myHeight(context) / 100.0),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        height: myHeight(context) / 35.0,
                                                                                        child: ListView.builder(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            itemCount: _salesToShow[index]['products'].length,
                                                                                            itemBuilder: (context, ind) {
                                                                                              return Text(
                                                                                                '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']} ',
                                                                                                style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 40.0),
                                                                                              );
                                                                                            }),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      width: 50.0,
                                                                                      child: Stack(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Text(
                                                                                                '${_salesToShow[index]['initiator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          _salesToShow[index]['validator'] == null
                                                                                              ? Container(
                                                                                                  width: 0.0,
                                                                                                )
                                                                                              : Container(
                                                                                                  transform: Matrix4.translationValues(23, 0, 0),
                                                                                                  decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                                    child: Text(
                                                                                                      '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: textInverseModeColor.withOpacity(.45), fontSize: myHeight(context) / 50.0),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Container(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: <Widget>[
                                                                                          Text('Total', style: TextStyle(color: textInverseModeColor.withOpacity(.45))),
                                                                                          Text(
                                                                                            '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        selectionMode
                                                                            ? AnimatedContainer(
                                                                                curve: Curves.bounceInOut,
                                                                                duration: Duration(seconds: 4),
                                                                                decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(.9), borderRadius: BorderRadius.circular(10.0)),
                                                                                child: Container(
                                                                                  child: Align(
                                                                                    alignment: Alignment.bottomLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(20.0),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            selectedItem = !selectedItem;
                                                                                          });
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              width: 30.0,
                                                                                              height: 30.0,
                                                                                              decoration: BoxDecoration(color: selectedItem ? textSameModeColor : Colors.transparent, border: Border.all(color: textSameModeColor), borderRadius: BorderRadius.circular(10.0)),
                                                                                              child: Icon(
                                                                                                Icons.check,
                                                                                                color: selectedItem ? Colors.blueGrey : Colors.transparent,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 20.0,
                                                                                            ),
                                                                                            Text(
                                                                                              'Selectionner',
                                                                                              style: TextStyle(color: textSameModeColor, fontSize: 17.0),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            : Container(
                                                                                height: 0.0,
                                                                              )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              })),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                        ]
                                      : <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.brightness_1,
                                                      color: gradient1,
                                                      size: 26,
                                                    ),
                                                    SizedBox(
                                                      width: 11.0,
                                                    ),
                                                    Text(
                                                      'En attente',
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (sitesToShow ==
                                                            null) {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          await fetchProductsOfSnack()
                                                              .then((value) {
                                                            setState(() {
                                                              _isLoading =
                                                                  false;
                                                            });
                                                            sitesToShow =
                                                                _fieldValues(
                                                                    value);
                                                            addSales(
                                                                sites:
                                                                    sitesToShow);
                                                          });
                                                        } else {
                                                          addSales(
                                                              sites:
                                                                  sitesToShow);
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        size:
                                                            myHeight(context) /
                                                                26.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: myHeight(context) /
                                                          50.0,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () =>
                                                            selectionMode
                                                                ? _cancelMode(
                                                                    _scaffoldKey)
                                                                : _filterData(),
                                                        child: Icon(selectionMode
                                                            ? AmazingIcon
                                                                .close_line
                                                            : AmazingIcon
                                                                .list_settings_fill)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Expanded(
                                                  child:
                                                      _salesToShow == null ||
                                                              _salesToShow
                                                                      .length ==
                                                                  0
                                                          ? Center(
                                                              child: Text(
                                                                  'Aucune vente'),
                                                            )
                                                          : ListView.builder(
                                                              itemCount:
                                                                  _salesToShow
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          15.0,
                                                                          0.0,
                                                                          15.0,
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        screenSize(context).height /
                                                                            5.0,
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Stack(
                                                                      fit: StackFit
                                                                          .expand,
                                                                      children: <
                                                                          Widget>[
                                                                        AnimatedContainer(
                                                                          curve:
                                                                              Curves.bounceInOut,
                                                                          duration:
                                                                              Duration(seconds: 4),
                                                                          decoration: BoxDecoration(
                                                                              color: textSameModeColor,
                                                                              border: Border.all(color: textInverseModeColor.withOpacity(.12)),
                                                                              borderRadius: BorderRadius.circular(10.0)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(10.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      'S0-${_salesToShow[index]['code']}',
                                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 26.0),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    userRole['slug'] == 'storekeeper'
                                                                                        ? Container(
                                                                                            height: 0.0,
                                                                                          )
                                                                                        : GestureDetector(
                                                                                            onTap: () => showSnackBar(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index),
                                                                                            child: Icon(Icons.more_vert, size: myHeight(context) / 25.0),
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: myHeight(context) / 100.0),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        height: myHeight(context) / 35.0,
                                                                                        child: ListView.builder(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            itemCount: _salesToShow[index]['products'].length,
                                                                                            itemBuilder: (context, ind) {
                                                                                              return Text(
                                                                                                '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']} ',
                                                                                                style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 40.0),
                                                                                              );
                                                                                            }),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      width: 50.0,
                                                                                      child: Stack(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(10.0),
                                                                                              child: Text(
                                                                                                '${_salesToShow[index]['initiator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: textInverseModeColor.withOpacity(.45), fontSize: myHeight(context) / 50.0),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          _salesToShow[index]['validator'] == null
                                                                                              ? Container(
                                                                                                  width: 0.0,
                                                                                                )
                                                                                              : Container(
                                                                                                  transform: Matrix4.translationValues(23, 0, 0),
                                                                                                  decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                                    child: Text(
                                                                                                      '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: textInverseModeColor.withOpacity(.45), fontSize: myHeight(context) / 50.0),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Container(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: <Widget>[
                                                                                          Text('Total', style: TextStyle(color: textInverseModeColor.withOpacity(.45))),
                                                                                          Text(
                                                                                            '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        selectionMode
                                                                            ? AnimatedContainer(
                                                                                curve: Curves.bounceInOut,
                                                                                duration: Duration(seconds: 4),
                                                                                decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(.9), borderRadius: BorderRadius.circular(10.0)),
                                                                                child: Container(
                                                                                  child: Align(
                                                                                    alignment: Alignment.bottomLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(20.0),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            selectedItem = !selectedItem;
                                                                                          });
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              width: 30.0,
                                                                                              height: 30.0,
                                                                                              decoration: BoxDecoration(color: selectedItem ? textSameModeColor : Colors.transparent, border: Border.all(color: textSameModeColor), borderRadius: BorderRadius.circular(10.0)),
                                                                                              child: Icon(
                                                                                                Icons.check,
                                                                                                color: selectedItem ? Colors.blueGrey : Colors.transparent,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 20.0,
                                                                                            ),
                                                                                            Text(
                                                                                              'Selectionner',
                                                                                              style: TextStyle(color: textSameModeColor, fontSize: 17.0),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            : Container(
                                                                                height: 0.0,
                                                                              )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              })),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.brightness_1,
                                                      color: Colors.orange,
                                                      size: 26,
                                                    ),
                                                    SizedBox(
                                                      width: 11.0,
                                                    ),
                                                    Text(
                                                      'Servie',
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Spacer(),
                                                    SizedBox(
                                                      width: myHeight(context) /
                                                          100.0,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () =>
                                                            selectionMode
                                                                ? _cancelMode(
                                                                    _scaffoldKey)
                                                                : _filterData(),
                                                        child: Icon(selectionMode
                                                            ? AmazingIcon
                                                                .close_line
                                                            : AmazingIcon
                                                                .list_settings_fill)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Expanded(
                                                  child:
                                                      _salesToShow == null ||
                                                              _salesToShow
                                                                      .length ==
                                                                  0
                                                          ? Center(
                                                              child: Text(
                                                                  'Aucune vente'),
                                                            )
                                                          : ListView.builder(
                                                              itemCount:
                                                                  _salesToShow
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          15.0,
                                                                          0.0,
                                                                          15.0,
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        screenSize(context).height /
                                                                            5.0,
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Stack(
                                                                      fit: StackFit
                                                                          .expand,
                                                                      children: <
                                                                          Widget>[
                                                                        AnimatedContainer(
                                                                          curve:
                                                                              Curves.bounceInOut,
                                                                          duration:
                                                                              Duration(seconds: 4),
                                                                          decoration: BoxDecoration(
                                                                              color: textSameModeColor,
                                                                              border: Border.all(color: textInverseModeColor.withOpacity(.12)),
                                                                              borderRadius: BorderRadius.circular(10.0)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(10.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      'S0-${_salesToShow[index]['code']}',
                                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 26.0),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    userRole['slug'] == 'storekeeper'
                                                                                        ? Container(
                                                                                            height: 0.0,
                                                                                          )
                                                                                        : GestureDetector(
                                                                                            onTap: () => showSnackBar(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index),
                                                                                            child: Icon(Icons.more_vert, size: myHeight(context) / 25.0),
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: myHeight(context) / 100.0),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        height: myHeight(context) / 35.0,
                                                                                        child: ListView.builder(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            itemCount: _salesToShow[index]['products'].length,
                                                                                            itemBuilder: (context, ind) {
                                                                                              return Text(
                                                                                                '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']} ',
                                                                                                style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 40.0),
                                                                                              );
                                                                                            }),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      width: 50.0,
                                                                                      child: Stack(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(10.0),
                                                                                              child: Text(
                                                                                                '${_salesToShow[index]['initiator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: textInverseModeColor.withOpacity(.45), fontSize: myHeight(context) / 50.0),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          _salesToShow[index]['validator'] == null
                                                                                              ? Container(
                                                                                                  width: 0.0,
                                                                                                )
                                                                                              : Container(
                                                                                                  transform: Matrix4.translationValues(23, 0, 0),
                                                                                                  decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                                    child: Text(
                                                                                                      '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: textInverseModeColor.withOpacity(.45), fontSize: myHeight(context) / 50.0),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Container(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: <Widget>[
                                                                                          Text('Total', style: TextStyle(color: textInverseModeColor.withOpacity(.45))),
                                                                                          Text(
                                                                                            '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        selectionMode
                                                                            ? AnimatedContainer(
                                                                                curve: Curves.bounceInOut,
                                                                                duration: Duration(seconds: 4),
                                                                                decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(.9), borderRadius: BorderRadius.circular(10.0)),
                                                                                child: Container(
                                                                                  child: Align(
                                                                                    alignment: Alignment.bottomLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(20.0),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            selectedItem = !selectedItem;
                                                                                          });
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              width: 30.0,
                                                                                              height: 30.0,
                                                                                              decoration: BoxDecoration(color: selectedItem ? textSameModeColor : Colors.transparent, border: Border.all(color: textSameModeColor), borderRadius: BorderRadius.circular(10.0)),
                                                                                              child: Icon(
                                                                                                Icons.check,
                                                                                                color: selectedItem ? Colors.blueGrey : Colors.transparent,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 20.0,
                                                                                            ),
                                                                                            Text(
                                                                                              'Selectionner',
                                                                                              style: TextStyle(color: textSameModeColor, fontSize: 17.0),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            : Container(
                                                                                height: 0.0,
                                                                              )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              })),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.brightness_1,
                                                      color: Colors.green,
                                                      size: 26,
                                                    ),
                                                    SizedBox(
                                                      width: 11.0,
                                                    ),
                                                    Text(
                                                      'Payee',
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Spacer(),
                                                    SizedBox(
                                                      width: myHeight(context) /
                                                          100.0,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () =>
                                                            selectionMode
                                                                ? _cancelMode(
                                                                    _scaffoldKey)
                                                                : _filterData(),
                                                        child: Icon(selectionMode
                                                            ? AmazingIcon
                                                                .close_line
                                                            : AmazingIcon
                                                                .list_settings_fill)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Expanded(
                                                  child:
                                                      _salesToShow == null ||
                                                              _salesToShow
                                                                      .length ==
                                                                  0
                                                          ? Center(
                                                              child: Text(
                                                                  'Aucune vente'),
                                                            )
                                                          : ListView.builder(
                                                              itemCount:
                                                                  _salesToShow
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          15.0,
                                                                          0.0,
                                                                          15.0,
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        screenSize(context).height /
                                                                            5.0,
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Stack(
                                                                      fit: StackFit
                                                                          .expand,
                                                                      children: <
                                                                          Widget>[
                                                                        AnimatedContainer(
                                                                          curve:
                                                                              Curves.bounceInOut,
                                                                          duration:
                                                                              Duration(seconds: 4),
                                                                          decoration: BoxDecoration(
                                                                              color: textSameModeColor,
                                                                              border: Border.all(color: textInverseModeColor.withOpacity(.12)),
                                                                              borderRadius: BorderRadius.circular(10.0)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(10.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: <Widget>[
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      'S0-${_salesToShow[index]['code']}',
                                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: myHeight(context) / 26.0),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    userRole['slug'] == 'storekeeper'
                                                                                        ? Container(
                                                                                            height: 0.0,
                                                                                          )
                                                                                        : GestureDetector(
                                                                                            onTap: () => showSnackBar(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index),
                                                                                            child: Icon(Icons.more_vert, size: myHeight(context) / 25.0),
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: myHeight(context) / 100.0),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        height: myHeight(context) / 35.0,
                                                                                        child: ListView.builder(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            itemCount: _salesToShow[index]['products'].length,
                                                                                            itemBuilder: (context, ind) {
                                                                                              return Text(
                                                                                                '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']} ',
                                                                                                style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 40.0),
                                                                                              );
                                                                                            }),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      width: 50.0,
                                                                                      child: Stack(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(10.0),
                                                                                              child: Text(
                                                                                                '${_salesToShow[index]['initiator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: textInverseModeColor.withOpacity(.45), fontSize: myHeight(context) / 50.0),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          _salesToShow[index]['validator'] == null
                                                                                              ? Container(
                                                                                                  width: 0.0,
                                                                                                )
                                                                                              : Container(
                                                                                                  transform: Matrix4.translationValues(23, 0, 0),
                                                                                                  decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                                    child: Text(
                                                                                                      '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: textInverseModeColor.withOpacity(.45), fontSize: myHeight(context) / 50.0),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Spacer(),
                                                                                    Container(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: <Widget>[
                                                                                          Text('Total', style: TextStyle(color: textInverseModeColor.withOpacity(.45))),
                                                                                          Text(
                                                                                            '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        selectionMode
                                                                            ? AnimatedContainer(
                                                                                curve: Curves.bounceInOut,
                                                                                duration: Duration(seconds: 4),
                                                                                decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(.9), borderRadius: BorderRadius.circular(10.0)),
                                                                                child: Container(
                                                                                  child: Align(
                                                                                    alignment: Alignment.bottomLeft,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(20.0),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            selectedItem = !selectedItem;
                                                                                          });
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              width: 30.0,
                                                                                              height: 30.0,
                                                                                              decoration: BoxDecoration(color: selectedItem ? textSameModeColor : Colors.transparent, border: Border.all(color: textSameModeColor), borderRadius: BorderRadius.circular(10.0)),
                                                                                              child: Icon(
                                                                                                Icons.check,
                                                                                                color: selectedItem ? Colors.blueGrey : Colors.transparent,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 20.0,
                                                                                            ),
                                                                                            Text(
                                                                                              'Selectionner',
                                                                                              style: TextStyle(color: textSameModeColor, fontSize: 17.0),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            : Container(
                                                                                height: 0.0,
                                                                              )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              })),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          )
                                        ],
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
                  )
                ],
              ),
              _isLoading
                  ? Container(
                      height: myHeight(context),
                      width: myWidth(context),
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
      ),
    );
  }
}
