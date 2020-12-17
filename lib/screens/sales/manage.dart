import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:easytrack/screens/sales/add.dart';
import 'package:easytrack/screens/sales/update.dart';
import 'package:easytrack/screens/search/search.dart';
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
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchNode = FocusNode();

  Stream _companySales;
  Map product, currentSite;
  List _sales, _sites, _salesToShow, sitesToShow, products;
  List allSalesData;
  bool _isLoading;
  int _currentIndex;
  GlobalKey<ScaffoldState> _scaffoldKey;
  PageController _pageController;

  _deleteFunction(Map sale) async {
    Navigator.pop(context);
    Map allData;
    Map toRemove;
    await FirebaseFirestore.instance.collection('sales').get().then((value) {
      value.docs.forEach((element) {
        for (var item in element.data()['sales']) {
          if (item['code'] == sale['code']) {
            allData = element.data();
            toRemove = item;
          }
        }
      });
    });

    List _sales = allData['sales'];
    _sales.removeWhere((element) => element['code'] == toRemove['code']);
    await FirebaseFirestore.instance
        .collection('sales')
        .where('email', isEqualTo: allData['email'])
        .get()
        .then((value) => value.docs.first.reference.update({'sales': _sales}));

    deleteSales(sale['id']);
  }

  _showDetails(sale) {
    List _products = sale['products'];
    Map _initiator = sale['initiator'];
    Map validator = sale['validator'];
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
                  Text(
                    'Client: PASSAGER',
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
                        'Date: ${sale["created_at"]}',
                        style: TextStyle(
                          fontSize: myHeight(context) / 50.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Reference: S0-${sale["code"]}',
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
                        '${calculTotal(sale['products'])} FCFA',
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
                        '${calculTotal(sale['products'])} FCFA',
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
                          'Paye par: ${sale["paying_method"].toUpperCase()}',
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

  _showConfirmationMessage(Map sale) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                  height: myHeight(context) / 2.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      errorAlertIcon(context),
                      SizedBox(
                        height: myHeight(context) / 40,
                      ),
                      Text(
                        'Operation de suppression',
                        style: TextStyle(
                            color: textInverseModeColor,
                            fontSize: myWidth(context) / 22),
                      ),
                      SizedBox(height: myHeight(context) / 80),
                      Text(
                        'Vous allez proceder a une suppression.',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 30),
                      ),
                      Text(
                        'Attention cette operation',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 30),
                      ),
                      Text(
                        'est irreversible.',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 30),
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              borderSide:
                                  BorderSide(color: textInverseModeColor),
                              onPressed: () => _deleteFunction(sale),
                              child: Container(
                                  alignment: Alignment.center,
                                  height: myHeight(context) / 30.0,
                                  child: Text('Supprimer')),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ));
  }

  _deleteSite(Map sale) {
    _showConfirmationMessage(sale);
  }

  OverlayEntry _overlay;

  _show(GlobalKey<ScaffoldState> _key, int status, Map sale, currentIndex) {
    setState(() {
      this._overlay =
          this._createOverlayEntry(_key, status, sale, currentIndex);
      Overlay.of(context).insert(this._overlay);
    });
  }

  _createOverlayEntry(
      GlobalKey<ScaffoldState> _key, int status, Map sale, currentIndex) {
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
                    padding: EdgeInsets.only(top: myHeight(context) / 100.0),
                    width: double.infinity,
                    height: status == 2
                        ? _salesToShow[currentIndex]['validator'] == null ||
                                _salesToShow[currentIndex]['validator']['id'] !=
                                    user.id
                            ? myHeight(context) * 2 / 15
                            : myHeight(context) * 3 / 15
                        : status == 1
                            ? myHeight(context) * 3 / 15
                            : myHeight(context) * 4.5 / 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(myHeight(context) / 70.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth(context) / 13),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            width: myWidth(context) / 7,
                            height: myHeight(context) / 150.0,
                          ),
                          SizedBox(
                            height: myHeight(context) / 100.0,
                          ),
                          Column(
                            children: [
                              status != 0
                                  ? Container(
                                      height: 0.0,
                                    )
                                  : InkWell(
                                      onTap: () {
                                        this._overlay.remove();
                                        _changeSaleStatus(1, sale);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                myHeight(context) / 100.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              AmazingIcon.account_circle_line,
                                              size: myHeight(context) / 40.0,
                                              color: gradient1,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                'Servir commande',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textInverseModeColor),
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
                                        _changeSaleStatus(2, sale);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                myHeight(context) / 100.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              AmazingIcon.shopping_cart_line,
                                              size: myHeight(context) / 40.0,
                                              color: gradient1,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                'Payer commande',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textInverseModeColor),
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
                                            _salesToShow[currentIndex]
                                                ['products'],
                                            _salesToShow[currentIndex]
                                                ['initiator'],
                                            validator:
                                                _salesToShow[currentIndex]
                                                    ['validator']);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                myHeight(context) / 100.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              AmazingIcon.repeat_2_line,
                                              size: myHeight(context) / 40.0,
                                              color: gradient1,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                'Voir facture',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textInverseModeColor),
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
                                        _validateSale(sale);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                myHeight(context) / 100.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              AmazingIcon.repeat_2_line,
                                              size: myHeight(context) / 40.0,
                                              color: gradient1,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                'Valider Commande',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textInverseModeColor),
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
                                        _invalidateSale(sale);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                myHeight(context) / 100.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              AmazingIcon.account_circle_line,
                                              size: myHeight(context) / 40.0,
                                              color: gradient1,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                'Invalider commande',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textInverseModeColor),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                              status != 0
                                  ? Container(
                                      height: 0.0,
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: myHeight(context) / 100.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            AmazingIcon.edit_2_line,
                                            size: myHeight(context) / 40.0,
                                            color: gradient1,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              this._overlay.remove();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => UpdateSalesPage(
                                                          sale: _salesToShow[
                                                              currentIndex],
                                                          productsAlreadyInOrder:
                                                              _salesToShow[
                                                                      currentIndex]
                                                                  [
                                                                  'products'])));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                'Modifier',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textInverseModeColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              status != 0
                                  ? Container(
                                      height: 0.0,
                                    )
                                  : InkWell(
                                      onTap: () {
                                        this._overlay.remove();
                                        _deleteSite(sale);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                myHeight(context) / 100.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              AmazingIcon.delete_bin_6_line,
                                              size: myHeight(context) / 40.0,
                                              color: redColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                'Supprimer',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textInverseModeColor),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Container(
                            height: myHeight(context) / 80.0,
                          )
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
    _companySales = FirebaseFirestore.instance.collection('sales').snapshots();
    _salesToShow = [];
    _sites = [];
    _currentIndex = 0;
    _scaffoldKey = GlobalKey();
    _isLoading = false;
    _pageController = new PageController();
  }

  _changeSaleStatus(int newStatus, Map sale) async {
    Map allData;
    Map toRemove;
    await FirebaseFirestore.instance.collection('sales').get().then((value) {
      value.docs.forEach((element) {
        for (var item in element.data()['sales']) {
          if (item['code'] == sale['code']) {
            allData = element.data();
            toRemove = item;
          }
        }
      });
    });

    List _sales = allData['sales'];
    var _sale =
        _sales.firstWhere((element) => element['code'] == toRemove['code']);
    _sale['status'] = newStatus;
    int index =
        _sales.indexWhere((element) => element['code'] == toRemove['code']);
    _sales.removeAt(index);
    _sales.insert(index, _sale);
    await FirebaseFirestore.instance
        .collection('sales')
        .where('email', isEqualTo: allData['email'])
        .get()
        .then((value) => value.docs.first.reference.update({'sales': _sales}));

    Map<String, dynamic> params = Map();
    params['status'] = newStatus.toString();
    changeSaleState(params, sale['id']);
  }

  _validateSale(sale) async {
    setState(() {
      _isLoading = true;
    });
    await validateSale(sale['id']).then((success) async {
      Map allData;
      Map toRemove;
      await FirebaseFirestore.instance.collection('sales').get().then((value) {
        value.docs.forEach((element) {
          for (var item in element.data()['sales']) {
            if (item['code'] == sale['code']) {
              allData = element.data();
              toRemove = item;
            }
          }
        });
      });

      List _sales = allData['sales'];
      var _sale =
          _sales.firstWhere((element) => element['code'] == toRemove['code']);
      _sale['validator'] = success['sale']['validator'];
      _sale['status'] = 2;
      int index =
          _sales.indexWhere((element) => element['code'] == toRemove['code']);
      _sales.removeAt(index);
      _sales.insert(index, _sale);
      await FirebaseFirestore.instance
          .collection('sales')
          .where('email', isEqualTo: allData['email'])
          .get()
          .then(
              (value) => value.docs.first.reference.update({'sales': _sales}));
      setState(() {
        _isLoading = false;
      });
    });
  }

  _invalidateSale(sale) async {
    setState(() {
      _isLoading = true;
    });
    await invalidateSale(sale['id']).then((success) async {
      Map allData;
      Map toRemove;
      await FirebaseFirestore.instance.collection('sales').get().then((value) {
        value.docs.forEach((element) {
          for (var item in element.data()['sales']) {
            if (item['code'] == sale['code']) {
              allData = element.data();
              toRemove = item;
            }
          }
        });
      });

      List _sales = allData['sales'];
      var _sale =
          _sales.firstWhere((element) => element['code'] == toRemove['code']);
      _sale['validator'] = null;
      int index =
          _sales.indexWhere((element) => element['code'] == toRemove['code']);
      _sales.removeAt(index);
      _sales.insert(index, _sale);
      await FirebaseFirestore.instance
          .collection('sales')
          .where('email', isEqualTo: allData['email'])
          .get()
          .then(
              (value) => value.docs.first.reference.update({'sales': _sales}));
      setState(() {
        _isLoading = false;
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

  checkSiteProduct(sites, siteId) {
    Map result;
    for (var site in sites) {
      if (site['id'] == siteId) {
        result = site;
      }
    }
    return result == null ? [] : result['products'];
  }

  loadDesireSales(datas, filter) {
    _salesToShow.clear();
    for (var data in datas) {
      if (data['status'] == filter) {
        _salesToShow.add(data);
      }
    }
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.brightness_1,
                        color: _currentIndex == 0
                            ? gradient1
                            : _currentIndex == 1 ? Colors.orange : Colors.green,
                        size: myWidth(context) / 15.0,
                      ),
                      SizedBox(width: myWidth(context) / 30.0),
                      Text(
                        _currentIndex == 0
                            ? 'En attente'
                            : _currentIndex == 1 ? 'Servie' : 'Paye',
                        style: TextStyle(
                            fontSize: myHeight(context) / 40.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      index: 1,
                                    ))),
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
                  SizedBox(
                    height: myHeight(context) / 50.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search())),
                          child: Stack(
                            children: <Widget>[
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
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 50.0),
                                        suffixIcon: Icon(AmazingIcon.close_fill,
                                            color: textInverseModeColor),
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
                              Container(
                                height: 48,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      _currentIndex == 0
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: myWidth(context) / 30.0,
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddSalesPage())),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        myHeight(context) / 70.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: gradient1.withOpacity(.2)),
                                    child: Icon(
                                      Icons.add,
                                      color: gradient1,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: myHeight(context) / 100.0,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: _companySales,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (user.isAdmin == 1) {
                              globalSales =
                                  snapshot.data.docs[0].data()['sales'];
                              allSalesData = globalSales;
                              _sales = _checkAllSales(allSalesData);
                            } else {
                              globalSales = [];
                              for (var item in snapshot.data.docs) {
                                globalSales.add(item.data());
                              }
                              allSalesData = globalSales;
                              _sales = _checkAllSales(allSalesData);
                            }
                            loadDesireSales(_sales, _currentIndex);
                            return PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              children:
                                  user.isAdmin == 1 &&
                                          userRole['slug'] == 'server'
                                      ? <Widget>[
                                          /* Serveuse */
                                          Column(
                                            children: <Widget>[
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
                                                                                        onTap: () => _showDetails(_salesToShow[index]),
                                                                                        child: Text(
                                                                                          'S0-${_salesToShow[index]["code"]}',
                                                                                          style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index], index);
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
                                                                                      height: myHeight(context) / 40.0,
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
                                                                                        onTap: () => _showDetails(_salesToShow[index]),
                                                                                        child: Text(
                                                                                          'S0-${_salesToShow[index]["code"]}',
                                                                                          style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index], index);
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
                                                                                      height: myHeight(context) / 40.0,
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
                                                                                    onTap: () => _showDetails(_salesToShow[index]),
                                                                                    child: Text(
                                                                                      'S0-${_salesToShow[index]["code"]}',
                                                                                      style: TextStyle(fontSize: myHeight(context) / 33.0, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index], index);
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
                                                                                  height: myHeight(context) / 40.0,
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
                                                                                      _show(_scaffoldKey, _salesToShow[index]['status'], _salesToShow[index], index);
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
                                                                                  height: myHeight(context) / 40.0,
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

                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation(gradient1),
                            ),
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
