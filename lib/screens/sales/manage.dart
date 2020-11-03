import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/screens/sales/add.dart';
import 'package:easytrack/screens/sales/update.dart';
import 'package:easytrack/services/externalService.dart';
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

  OverlayEntry _overlay;
  _show(GlobalKey<ScaffoldState> _key, int status, int saleId, currentIndex) {
    setState(() {
      this._overlay =
          this._createOverlayEntry(_key, status, saleId, currentIndex);
      Overlay.of(context).insert(this._overlay);
    });
  }

  _createOverlayEntry(
      GlobalKey<ScaffoldState> _key, int status, int saleId, currentIndex) {
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
                    width: double.infinity,
                    height: status == 2
                        ? _salesToShow[currentIndex]['validator'] == null ||
                                _salesToShow[currentIndex]['validator']['id'] !=
                                    user.id
                            ? myHeight(context) * 2.5 / 15
                            : myHeight(context) * 3.5 / 15
                        : myHeight(context) * 4 / 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(myHeight(context) / 70.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth(context) / 13),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
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
                                    this._overlay.remove();
                                    _currentIndex = 0;
                                    _changeSaleStatus(1, saleId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          AmazingIcon.account_circle_line,
                                          size: 15.0,
                                          color: gradient1,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                                    this._overlay.remove();
                                    _currentIndex = 0;
                                    _changeSaleStatus(2, saleId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          AmazingIcon.shopping_cart_line,
                                          size: 15.0,
                                          color: gradient1,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                                    this._overlay.remove();
                                    showBill(
                                        'Passager',
                                        _sites[currentIndex],
                                        _salesToShow[currentIndex],
                                        _salesToShow[currentIndex]['products'],
                                        _salesToShow[currentIndex]['initiator'],
                                        validator: _salesToShow[currentIndex]
                                            ['validator']);
                                           
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          AmazingIcon.repeat_2_line,
                                          size: 15.0,
                                          color: gradient1,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            'Voir facture',
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
                                  _salesToShow[currentIndex]['validator'] !=
                                      null
                              ? Container(
                                  height: 0.0,
                                )
                              : InkWell(
                                  onTap: () {
                                    this._overlay.remove();
                                    _currentIndex = 0;
                                    _validateSale(saleId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          AmazingIcon.repeat_2_line,
                                          size: 15.0,
                                          color: gradient1,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                                  _salesToShow[currentIndex]['validator']
                                          ['id'] !=
                                      user.id
                              ? Container(
                                  height: 0.0,
                                )
                              : InkWell(
                                  onTap: () {
                                    this._overlay.remove();
                                    _currentIndex = 0;
                                    _invalidateSale(saleId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          AmazingIcon.account_circle_line,
                                          size: 15.0,
                                          color: gradient1,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        AmazingIcon.edit_2_line,
                                        size: 15.0,
                                        color: gradient1,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          this._overlay.remove();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateSalesPage(
                                                          sale: _salesToShow[
                                                              currentIndex],
                                                          productsAlreadyInOrder:
                                                              _salesToShow[
                                                                      currentIndex]
                                                                  [
                                                                  'products'])));
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
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
                              this._overlay.remove();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
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
                  ),
                ],
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    _companySales = fetchSales();
    _salesAlreadyLoad = false;
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
                  SizedBox(
                    height: myHeight(context) / 50.0,
                  ),
                  Text(
                    'Date: ${_sale["createdAt"]}',
                    style: TextStyle(
                      fontSize: myHeight(context) / 50.0,
                    ),
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
                  Expanded(
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
                    onTap: () => launchWhatsApp(phone: '+237694589535', message: ''),
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

  List _checkAllSales(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var sale in datas) {
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

  Widget _myBottomNavigation() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: myHeight(context) / 100.0,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        key: _scaffoldKey,
        bottomNavigationBar: _myBottomNavigation(),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(myWidth(context) / 30.0,
                  myHeight(context) / 50.0, myWidth(context) / 30.0, 0.0),
              child: Column(
                children: <Widget>[
                  Expanded(
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
                                          /* Serveuse */
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.brightness_1,
                                                    color: gradient1,
                                                    size:
                                                        myWidth(context) / 15.0,
                                                  ),
                                                  SizedBox(
                                                      width: myWidth(context) /
                                                          30.0),
                                                  Text(
                                                    'En attente',
                                                    style: TextStyle(
                                                        fontSize:
                                                            myHeight(context) /
                                                                40.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Icon(
                                                        AmazingIcon
                                                            .arrow_down_s_line,
                                                        size:
                                                            myHeight(context) /
                                                                20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 50.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 46.0,
                                                          decoration:
                                                              buildTextFormFieldContainer(
                                                                  decorationColor),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Container(
                                                            height: 46.0,
                                                            child:
                                                                TextFormField(
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              style: TextStyle(
                                                                  color: textInverseModeColor
                                                                      .withOpacity(
                                                                          .87)),
                                                              controller:
                                                                  _searchController,
                                                              focusNode:
                                                                  _searchNode,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _sales = searchMethod(
                                                                      _salesForSearch,
                                                                      value);
                                                                  loadDesireSales(
                                                                      _sales);
                                                                });
                                                              },
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                setState(() {
                                                                  _sales = searchMethod(
                                                                      _salesForSearch,
                                                                      value);
                                                                  loadDesireSales(
                                                                      _sales);
                                                                  _searchController
                                                                      .text = '';
                                                                });
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                      contentPadding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              50.0),
                                                                      suffixIcon:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          _searchController.text =
                                                                              '';
                                                                          _searchNode
                                                                              .unfocus();
                                                                          _sales =
                                                                              _salesForSearch;
                                                                          loadDesireSales(
                                                                              _sales);
                                                                        },
                                                                        child: Icon(
                                                                            AmazingIcon
                                                                                .close_fill,
                                                                            color:
                                                                                textInverseModeColor),
                                                                      ),
                                                                      hintText:
                                                                          'Recherche...',
                                                                      prefixIcon: Icon(
                                                                          AmazingIcon
                                                                              .search_2_line,
                                                                          color:
                                                                              textInverseModeColor),
                                                                      hintStyle: TextStyle(
                                                                          color: textInverseModeColor.withOpacity(
                                                                              .35),
                                                                          fontSize:
                                                                              18.0),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        myWidth(context) / 30.0,
                                                  ),
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddSalesPage())),
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          myHeight(context) /
                                                              70.0),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: gradient1
                                                              .withOpacity(.2)),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: gradient1,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 100.0,
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
                                                                    padding: EdgeInsets.only(
                                                                        top: myHeight(context) /
                                                                            100.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                            height: myHeight(context) /
                                                                                5.5,
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.all(Radius.circular(myHeight(context) / 90.0)),
                                                                                border: Border.all(width: 1.0, color: Colors.black.withOpacity(.1))),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: myWidth(context) / 30.0, vertical: myHeight(context) / 70.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: <Widget>[
                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      InkWell(
                                                                                        child: Text(
                                                                                          'S0-${_salesToShow[index]["code"]}',
                                                                                          style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index);
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons.more_vert,
                                                                                          size: myWidth(context) / 16.0,
                                                                                        ),
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
                                                                                          itemCount: _salesToShow[index]['products'].length > 1 ? 1 : _salesToShow[index]['products'].length,
                                                                                          itemBuilder: (context, ind) {
                                                                                            return Text(
                                                                                              _salesToShow[index]['products'].length > 1 ? '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}...' : '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}',
                                                                                              style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 45.0),
                                                                                            );
                                                                                          }),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                      padding: EdgeInsets.only(bottom: myHeight(context) / 200.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            width: 50.0,
                                                                                            child: Stack(
                                                                                              children: <Widget>[
                                                                                                Container(
                                                                                                  decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.all(myHeight(context) / 80.0),
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
                                                                                                          padding: EdgeInsets.all(myHeight(context) / 80.0),
                                                                                                          child: Text(
                                                                                                            '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
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
                                                                                                Text('Total', style: TextStyle(color: Colors.black45, fontSize: myHeight(context) / 55.0)),
                                                                                                Text(
                                                                                                  '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                            )),
                                                                        index == _salesToShow.length - 1 &&
                                                                                _salesToShow.length > 3
                                                                            ? InkWell(
                                                                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddSalesPage())),
                                                                                child: Container(
                                                                                  margin: EdgeInsets.symmetric(vertical: myHeight(context) / 30.0),
                                                                                  padding: EdgeInsets.symmetric(vertical: myHeight(context) / 100.0),
                                                                                  width: double.infinity,
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(myHeight(context) / 30.0), color: gradient1.withOpacity(.1)),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Icon(Icons.add, color: gradient1, size: myHeight(context) / 30.0),
                                                                                      SizedBox(
                                                                                        width: myWidth(context) / 30.0,
                                                                                      ),
                                                                                      Text(
                                                                                        'Ajouter une commande',
                                                                                        style: TextStyle(color: gradient1, fontSize: myHeight(context) / 45.0),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                height: 0.0,
                                                                              )
                                                                      ],
                                                                    ));
                                                              })),
                                            ],
                                          ),
                                        ]
                                      : <Widget>[
                                          /* Premiere */
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.brightness_1,
                                                    color: gradient1,
                                                    size:
                                                        myWidth(context) / 15.0,
                                                  ),
                                                  SizedBox(
                                                      width: myWidth(context) /
                                                          30.0),
                                                  Text(
                                                    'En attente',
                                                    style: TextStyle(
                                                        fontSize:
                                                            myHeight(context) /
                                                                40.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Icon(
                                                        AmazingIcon
                                                            .arrow_down_s_line,
                                                        size:
                                                            myHeight(context) /
                                                                20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 50.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 46.0,
                                                          decoration:
                                                              buildTextFormFieldContainer(
                                                                  decorationColor),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Container(
                                                            height: 46.0,
                                                            child:
                                                                TextFormField(
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              style: TextStyle(
                                                                  color: textInverseModeColor
                                                                      .withOpacity(
                                                                          .87)),
                                                              controller:
                                                                  _searchController,
                                                              focusNode:
                                                                  _searchNode,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _sales = searchMethod(
                                                                      _salesForSearch,
                                                                      value);
                                                                  loadDesireSales(
                                                                      _sales);
                                                                });
                                                              },
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                setState(() {
                                                                  _sales = searchMethod(
                                                                      _salesForSearch,
                                                                      value);
                                                                  loadDesireSales(
                                                                      _sales);
                                                                  _searchController
                                                                      .text = '';
                                                                });
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                      contentPadding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              50.0),
                                                                      suffixIcon:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          _searchController.text =
                                                                              '';
                                                                          _searchNode
                                                                              .unfocus();
                                                                          _sales =
                                                                              _salesForSearch;
                                                                          loadDesireSales(
                                                                              _sales);
                                                                        },
                                                                        child: Icon(
                                                                            AmazingIcon
                                                                                .close_fill,
                                                                            color:
                                                                                textInverseModeColor),
                                                                      ),
                                                                      hintText:
                                                                          'Recherche...',
                                                                      prefixIcon: Icon(
                                                                          AmazingIcon
                                                                              .search_2_line,
                                                                          color:
                                                                              textInverseModeColor),
                                                                      hintStyle: TextStyle(
                                                                          color: textInverseModeColor.withOpacity(
                                                                              .35),
                                                                          fontSize:
                                                                              18.0),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        myWidth(context) / 30.0,
                                                  ),
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddSalesPage())),
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          myHeight(context) /
                                                              70.0),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: gradient1
                                                              .withOpacity(.2)),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: gradient1,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 100.0,
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
                                                                    padding: EdgeInsets.only(
                                                                        top: myHeight(context) /
                                                                            100.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                            height: myHeight(context) /
                                                                                5.5,
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.all(Radius.circular(myHeight(context) / 90.0)),
                                                                                border: Border.all(width: 1.0, color: Colors.black.withOpacity(.1))),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: myWidth(context) / 30.0, vertical: myHeight(context) / 70.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: <Widget>[
                                                                                  Row(
                                                                                    children: <Widget>[
                                                                                      InkWell(
                                                                                        child: Text(
                                                                                          'S0-${_salesToShow[index]["code"]}',
                                                                                          style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index);
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons.more_vert,
                                                                                          size: myWidth(context) / 16.0,
                                                                                        ),
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
                                                                                          itemCount: _salesToShow[index]['products'].length > 1 ? 1 : _salesToShow[index]['products'].length,
                                                                                          itemBuilder: (context, ind) {
                                                                                            return Text(
                                                                                              _salesToShow[index]['products'].length > 1 ? '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}...' : '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}',
                                                                                              style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 45.0),
                                                                                            );
                                                                                          }),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                      padding: EdgeInsets.only(bottom: myHeight(context) / 200.0),
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            width: 50.0,
                                                                                            child: Stack(
                                                                                              children: <Widget>[
                                                                                                Container(
                                                                                                  decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.all(myHeight(context) / 80.0),
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
                                                                                                          padding: EdgeInsets.all(myHeight(context) / 80.0),
                                                                                                          child: Text(
                                                                                                            '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
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
                                                                                                Text('Total', style: TextStyle(color: Colors.black45, fontSize: myHeight(context) / 55.0)),
                                                                                                Text(
                                                                                                  '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                            )),
                                                                        index == _salesToShow.length - 1 &&
                                                                                _salesToShow.length > 3
                                                                            ? InkWell(
                                                                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddSalesPage())),
                                                                                child: Container(
                                                                                  margin: EdgeInsets.symmetric(vertical: myHeight(context) / 30.0),
                                                                                  padding: EdgeInsets.symmetric(vertical: myHeight(context) / 100.0),
                                                                                  width: double.infinity,
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(myHeight(context) / 30.0), color: gradient1.withOpacity(.1)),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Icon(Icons.add, color: gradient1, size: myHeight(context) / 30.0),
                                                                                      SizedBox(
                                                                                        width: myWidth(context) / 30.0,
                                                                                      ),
                                                                                      Text(
                                                                                        'Ajouter une commande',
                                                                                        style: TextStyle(color: gradient1, fontSize: myHeight(context) / 45.0),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                height: 0.0,
                                                                              )
                                                                      ],
                                                                    ));
                                                              })),
                                            ],
                                          ),

                                          /* Deuxieme */
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.brightness_1,
                                                    color: Colors.orange,
                                                    size:
                                                        myWidth(context) / 15.0,
                                                  ),
                                                  SizedBox(
                                                      width: myWidth(context) /
                                                          30.0),
                                                  Text(
                                                    'Servie',
                                                    style: TextStyle(
                                                        fontSize:
                                                            myHeight(context) /
                                                                40.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Icon(
                                                        AmazingIcon
                                                            .arrow_down_s_line,
                                                        size:
                                                            myHeight(context) /
                                                                20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 50.0,
                                              ),
                                              Stack(
                                                children: <Widget>[
                                                  Container(
                                                    height: 46.0,
                                                    decoration:
                                                        buildTextFormFieldContainer(
                                                            decorationColor),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    child: Container(
                                                      height: 46.0,
                                                      child: TextFormField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        style: TextStyle(
                                                            color:
                                                                textInverseModeColor
                                                                    .withOpacity(
                                                                        .87)),
                                                        controller:
                                                            _searchController,
                                                        focusNode: _searchNode,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _sales = searchMethod(
                                                                _salesForSearch,
                                                                value);
                                                            loadDesireSales(
                                                                _sales);
                                                          });
                                                        },
                                                        onFieldSubmitted:
                                                            (value) {
                                                          setState(() {
                                                            _sales = searchMethod(
                                                                _salesForSearch,
                                                                value);
                                                            loadDesireSales(
                                                                _sales);
                                                            _searchController
                                                                .text = '';
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            50.0),
                                                                suffixIcon:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    _searchController
                                                                        .text = '';
                                                                    _searchNode
                                                                        .unfocus();
                                                                    _sales =
                                                                        _salesForSearch;
                                                                    loadDesireSales(
                                                                        _sales);
                                                                  },
                                                                  child: Icon(
                                                                      AmazingIcon
                                                                          .close_fill,
                                                                      color:
                                                                          textInverseModeColor),
                                                                ),
                                                                hintText:
                                                                    'Recherche...',
                                                                prefixIcon: Icon(
                                                                    AmazingIcon
                                                                        .search_2_line,
                                                                    color:
                                                                        textInverseModeColor),
                                                                hintStyle: TextStyle(
                                                                    color: textInverseModeColor
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
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 100.0,
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
                                                                    padding: EdgeInsets.only(
                                                                        top: myHeight(context) /
                                                                            100.0),
                                                                    child: Container(
                                                                        height: myHeight(context) / 5.5,
                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(myHeight(context) / 90.0)), border: Border.all(width: 1.0, color: Colors.black.withOpacity(.1))),
                                                                        child: Padding(
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
                                                                                  InkWell(
                                                                                    child: Text(
                                                                                      'S0-${_salesToShow[index]["code"]}',
                                                                                      style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index);
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.more_vert,
                                                                                      size: myWidth(context) / 16.0,
                                                                                    ),
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
                                                                                      itemCount: _salesToShow[index]['products'].length > 1 ? 1 : _salesToShow[index]['products'].length,
                                                                                      itemBuilder: (context, ind) {
                                                                                        return Text(
                                                                                          _salesToShow[index]['products'].length > 1 ? '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}...' : '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}',
                                                                                          style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 45.0),
                                                                                        );
                                                                                      }),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                  padding: EdgeInsets.only(bottom: myHeight(context) / 200.0),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        width: 50.0,
                                                                                        child: Stack(
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(myHeight(context) / 80.0),
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
                                                                                                      padding: EdgeInsets.all(myHeight(context) / 80.0),
                                                                                                      child: Text(
                                                                                                        '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
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
                                                                                            Text('Total', style: TextStyle(color: Colors.black45, fontSize: myHeight(context) / 55.0)),
                                                                                            Text(
                                                                                              '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        )));
                                                              })),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),

                                          /* Troisieme */
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.brightness_1,
                                                    color: Colors.green,
                                                    size:
                                                        myWidth(context) / 15.0,
                                                  ),
                                                  SizedBox(
                                                      width: myWidth(context) /
                                                          30.0),
                                                  Text(
                                                    'Paye',
                                                    style: TextStyle(
                                                        fontSize:
                                                            myHeight(context) /
                                                                40.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Icon(
                                                        AmazingIcon
                                                            .arrow_down_s_line,
                                                        size:
                                                            myHeight(context) /
                                                                20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 50.0,
                                              ),
                                              Stack(
                                                children: <Widget>[
                                                  Container(
                                                    height: 46.0,
                                                    decoration:
                                                        buildTextFormFieldContainer(
                                                            decorationColor),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    child: Container(
                                                      height: 46.0,
                                                      child: TextFormField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        style: TextStyle(
                                                            color:
                                                                textInverseModeColor
                                                                    .withOpacity(
                                                                        .87)),
                                                        controller:
                                                            _searchController,
                                                        focusNode: _searchNode,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _sales = searchMethod(
                                                                _salesForSearch,
                                                                value);
                                                            loadDesireSales(
                                                                _sales);
                                                          });
                                                        },
                                                        onFieldSubmitted:
                                                            (value) {
                                                          setState(() {
                                                            _sales = searchMethod(
                                                                _salesForSearch,
                                                                value);
                                                            loadDesireSales(
                                                                _sales);
                                                            _searchController
                                                                .text = '';
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            50.0),
                                                                suffixIcon:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    _searchController
                                                                        .text = '';
                                                                    _searchNode
                                                                        .unfocus();
                                                                    _sales =
                                                                        _salesForSearch;
                                                                    loadDesireSales(
                                                                        _sales);
                                                                  },
                                                                  child: Icon(
                                                                      AmazingIcon
                                                                          .close_fill,
                                                                      color:
                                                                          textInverseModeColor),
                                                                ),
                                                                hintText:
                                                                    'Recherche...',
                                                                prefixIcon: Icon(
                                                                    AmazingIcon
                                                                        .search_2_line,
                                                                    color:
                                                                        textInverseModeColor),
                                                                hintStyle: TextStyle(
                                                                    color: textInverseModeColor
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
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 100.0,
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
                                                                    padding: EdgeInsets.only(
                                                                        top: myHeight(context) /
                                                                            100.0),
                                                                    child: Container(
                                                                        height: myHeight(context) / 5.5,
                                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(myHeight(context) / 90.0)), border: Border.all(width: 1.0, color: Colors.black.withOpacity(.1))),
                                                                        child: Padding(
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
                                                                                  InkWell(
                                                                                    child: Text(
                                                                                      'S0-${_salesToShow[index]["code"]}',
                                                                                      style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index]['id'], index);
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.more_vert,
                                                                                      size: myWidth(context) / 16.0,
                                                                                    ),
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
                                                                                      itemCount: _salesToShow[index]['products'].length > 1 ? 1 : _salesToShow[index]['products'].length,
                                                                                      itemBuilder: (context, ind) {
                                                                                        return Text(
                                                                                          _salesToShow[index]['products'].length > 1 ? '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}...' : '${_salesToShow[index]['products'][ind]['pivot']['qty']}x ${_salesToShow[index]['products'][ind]['name']}',
                                                                                          style: TextStyle(fontWeight: FontWeight.w500, color: textInverseModeColor.withOpacity(.54), fontSize: myHeight(context) / 45.0),
                                                                                        );
                                                                                      }),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                  padding: EdgeInsets.only(bottom: myHeight(context) / 200.0),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        width: 50.0,
                                                                                        child: Stack(
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              decoration: BoxDecoration(color: Color(0xffE4E4E4), shape: BoxShape.circle, border: Border.all(color: Color(0xffCDCDCD), width: 1.3)),
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(myHeight(context) / 80.0),
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
                                                                                                      padding: EdgeInsets.all(myHeight(context) / 80.0),
                                                                                                      child: Text(
                                                                                                        '${_salesToShow[index]['validator']['name'].substring(0, 2).toUpperCase()}',
                                                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
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
                                                                                            Text('Total', style: TextStyle(color: Colors.black45, fontSize: myHeight(context) / 55.0)),
                                                                                            Text(
                                                                                              '${calculTotal(_salesToShow[index]['products'])} FCFA',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: myHeight(context) / 50.0),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        )));
                                                              })),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                        ],
                            );
                          }
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.brightness_1,
                                    color: gradient1,
                                    size: myWidth(context) / 15.0,
                                  ),
                                  SizedBox(width: myWidth(context) / 30.0),
                                  Text(
                                    'En attente',
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 40.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        AmazingIcon.arrow_down_s_line,
                                        size: myHeight(context) / 20.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation(gradient1),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                ],
              ),
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
    );
  }
}
