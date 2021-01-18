import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/sales/manage.dart';
import 'package:easytrack/services/productService.dart';
import 'package:easytrack/services/saleService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class AddSalesPage extends StatefulWidget {
  @override
  _AddSalesPageState createState() => _AddSalesPageState();
}

class _AddSalesPageState extends State<AddSalesPage> {
  int indexOfPaymentMode;
  String labelOfPaymentMode;
  bool selectionMode = false;
  bool selectedItem = false;
  TextEditingController _priceController;

  Map product, currentSite;
  List sitesToShow, _productsOnOrder, _quantities, products;
  List allSalesData;
  bool _isLoading;
  int total;

  @override
  void initState() {
    super.initState();
    indexOfPaymentMode = 0;
    labelOfPaymentMode = 'C A S H';
    _productsOnOrder = [];
    _quantities = [];
    total = 0;
    _isLoading = true;
    fetchData();
    _priceController = new TextEditingController();
  }

  fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await fetchProductsOfSnack().then((value) {
      setState(() {
        _isLoading = false;
      });
      sitesToShow = _fieldValues(value);
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

  showDifferenceDialog(products, qties, id) {
    _showPrice(products, qties, id);
  }

  remboursementDialog(amount, context, products, qties, id) {
    int price = int.tryParse(amount);
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(myHeight(context) / 50.0)),
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: myWidth(context) / 2,
                          child: Text(
                            'Modalites de remboursement',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          )),
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            AmazingIcon.close_fill,
                            size: myHeight(context) / 30.0,
                          ))
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price == null
                            ? 'Entrer un nombre valide'
                            : price < total
                                ? 'Montant inferieur'
                                : 'Remboursement: ${int.parse(amount) - total} FCFA',
                        style: TextStyle(fontSize: myHeight(context) / 45.0),
                      ),
                      SizedBox(height: myHeight(context) / 50.0),
                      InkWell(
                        onTap: price == null
                            ? () {
                                Navigator.pop(context);
                                _showPrice(products, qties, id);
                              }
                            : price < total
                                ? () {
                                    Navigator.pop(context);
                                    _showPrice(products, qties, id);
                                  }
                                : () {
                                    Navigator.pop(context);
                                    _attemptSave(products, qties, id);
                                  },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: myWidth(context) / 20.0),
                            height: myHeight(context) / 22.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [gradient1, gradient2]),
                            ),
                            child: Text(
                              price == null
                                  ? 'Retour'
                                  : price < total ? 'Retour' : 'Suivant',
                              style: TextStyle(
                                  color: textSameModeColor,
                                  fontSize: myHeight(context) / 40.0),
                            )),
                      )
                    ],
                  ),
                );
              },
            ));
  }

  _showPrice(products, qties, id) {
    _priceController.clear();
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(myHeight(context) / 50.0)),
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: myWidth(context) / 2,
                          child: Text(
                            'Modalites de remboursement',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          )),
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            AmazingIcon.close_fill,
                            size: myHeight(context) / 30.0,
                          ))
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: myHeight(context) / 17.0,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(
                                myHeight(context) / 10.0)),
                        child: TextFormField(
                          controller: _priceController,
                          style: TextStyle(fontSize: myHeight(context) / 42.0),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                AmazingIcon.money_dollar_circle_line,
                                color: Colors.black,
                                size: myHeight(context) / 32.0,
                              ),
                              hintText: 'Montant',
                              hintStyle:
                                  TextStyle(fontSize: myHeight(context) / 42.0),
                              contentPadding: EdgeInsets.only(
                                  left: myHeight(context) / 30.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(height: myHeight(context) / 50.0),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          remboursementDialog(_priceController.text, context,
                              products, qties, id);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: myWidth(context) / 20.0),
                            height: myHeight(context) / 17.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [gradient1, gradient2]),
                            ),
                            child: Text(
                              'Suivant',
                              style: TextStyle(
                                  color: textSameModeColor,
                                  fontSize: myHeight(context) / 40.0),
                            )),
                      )
                    ],
                  ),
                );
              },
            ));
  }

  calculTotal(List datas) {
    int total = 0;
    for (var data in datas) {
      total += data['pivot']['price'] * data['pivot']['qty'];
    }
    return total;
  }

  _attemptSave(List products, List quantities, int siteId) async {
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
    params['paying_method'] = labelOfPaymentMode;
    params['sale_note'] = '';
    setState(() {
      _isLoading = true;
    });
    await storeSale(params).then((response) async {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ManageSales(),
          ));
    });
  }

  OverlayEntry _overlay;

  _show() {
    setState(() {
      this._overlay = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlay);
    });
  }

  _createOverlayEntry() {
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
                    height: myHeight(context) * .6,
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
                            height: myHeight(context) / 70.0,
                          ),
                          user.isAdmin == 1
                              ? Expanded(
                                  child: sitesToShow == null ||
                                          sitesToShow.length == 0
                                      ? Center(
                                          child: Text('Aucun produit'),
                                        )
                                      : ListView.builder(
                                          itemCount: sitesToShow.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _productsOnOrder
                                                      .add(sitesToShow[index]);
                                                  total += sitesToShow[index]
                                                      ['pivot']['price'];
                                                  _quantities.add(1);
                                                  sitesToShow.remove(
                                                      sitesToShow[index]);
                                                });
                                                this._overlay.remove();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: myHeight(context) /
                                                        70.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            myHeight(context) /
                                                                70.0)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          myWidth(context) /
                                                              30.0,
                                                      vertical:
                                                          myHeight(context) /
                                                              40.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              width: myWidth(
                                                                      context) /
                                                                  2,
                                                              child: Text(
                                                                '${sitesToShow[index]["name"]}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            41.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          SizedBox(
                                                            height: myHeight(
                                                                    context) /
                                                                200.0,
                                                          ),
                                                          Container(
                                                            width: myWidth(
                                                                    context) /
                                                                4.0,
                                                            child: Text(
                                                              'x${sitesToShow[index]["pivot"]['qty']}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      myHeight(
                                                                              context) /
                                                                          45.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: myHeight(
                                                                      context) /
                                                                  300.0),
                                                          width:
                                                              myWidth(context) /
                                                                  4.0,
                                                          child: Text(
                                                            '${sitesToShow[index]["pivot"]["price"]} FCFA',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: myHeight(
                                                                        context) /
                                                                    44.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }))
                              : Expanded(
                                  child: products == null ||
                                          products.length == 0
                                      ? Center(
                                          child: currentSite == null
                                              ? Text('Selectionner un site')
                                              : Text('Aucun produit'),
                                        )
                                      : ListView.builder(
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _productsOnOrder
                                                      .add(products[index]);
                                                  total += products[index]
                                                      ['pivot']['price'];
                                                  _quantities.add(1);
                                                  products
                                                      .remove(products[index]);
                                                });
                                                this._overlay.remove();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: myHeight(context) /
                                                        70.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            myHeight(context) /
                                                                70.0)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          myWidth(context) /
                                                              30.0,
                                                      vertical:
                                                          myHeight(context) /
                                                              40.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              width: myWidth(
                                                                      context) /
                                                                  2,
                                                              child: Text(
                                                                '${products[index]["name"]}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            41.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          SizedBox(
                                                            height: myHeight(
                                                                    context) /
                                                                200.0,
                                                          ),
                                                          Container(
                                                            width: myWidth(
                                                                    context) /
                                                                4.0,
                                                            child: Text(
                                                              'x${products[index]["pivot"]['qty']}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      myHeight(
                                                                              context) /
                                                                          45.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: myHeight(
                                                                      context) /
                                                                  300.0),
                                                          width:
                                                              myWidth(context) /
                                                                  4.0,
                                                          child: Text(
                                                            '${products[index]["pivot"]["price"]} FCFA',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: myHeight(
                                                                        context) /
                                                                    44.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: myWidth(context) / 30.0,
                  vertical: myHeight(context) / 60.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: myWidth(context) / 1.2,
                            child: Text(
                              'Creer une commande',
                              style: TextStyle(
                                  fontSize: myHeight(context) / 35.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: myHeight(context) / 150.0,
                          ),
                          Text('POUR UN CLIENT')
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () => Navigator.pop(context, true),
                        child: Icon(
                          AmazingIcon.close_fill,
                          size: myHeight(context) / 25.0,
                        ),
                      )
                    ],
                  ),
                  user.isAdmin != 2
                      ? Container(
                          height: 0.0,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            Container(
                              height: myHeight(context) / 15.0,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.07),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          myHeight(context) / 50.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: myHeight(context) / 50.0,
                                    right: myHeight(context) / 70.0),
                                child: DropdownButton(
                                  underline: Text(''),
                                  isExpanded: true,
                                  icon: Icon(AmazingIcon.arrow_down_s_line,
                                      color: textInverseModeColor,
                                      size: myHeight(context) / 30.0),
                                  hint: Text('Selectionner un site'),
                                  items: sitesToShow == null
                                      ? []
                                      : sitesToShow
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
                                        products = value['products'];
                                        if (_productsOnOrder != null) {
                                          for (var product
                                              in _productsOnOrder) {
                                            products.add(product);
                                          }
                                        }
                                        _productsOnOrder.clear();
                                        _quantities.clear();
                                        currentSite = value;
                                      });
                                    }
                                  },
                                  value: currentSite,
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),
                  Expanded(
                      child: _productsOnOrder == null ||
                              _productsOnOrder.length == 0
                          ? Center(
                              child: Text('Aucun produit ajoute'),
                            )
                          : ListView.builder(
                              itemCount: _productsOnOrder.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: myHeight(context) / 70.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(
                                          myHeight(context) / 70.0)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: myWidth(context) / 30.0,
                                        vertical: myHeight(context) / 40.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: myWidth(context) / 4.0,
                                                child: Text(
                                                  _productsOnOrder[index]
                                                      ['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          myHeight(context) /
                                                              50.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            SizedBox(
                                              height: myHeight(context) / 200.0,
                                            ),
                                            Container(
                                              width: myWidth(context) / 4.0,
                                              child: Text(
                                                '${_quantities[index]}x ${_productsOnOrder[index]["pivot"]["price"]} FCFA',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            60.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                                width: myWidth(context) / 4.0,
                                                child: Text(
                                                  'SOUS TOTAL',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          myHeight(context) /
                                                              70.0),
                                                )),
                                            SizedBox(
                                              height: myHeight(context) / 200.0,
                                            ),
                                            Container(
                                              width: myWidth(context) / 4.0,
                                              child: Text(
                                                '${_quantities[index] * _productsOnOrder[index]["pivot"]["price"]} FCFA',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            50.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (user.isAdmin == 1) {
                                                if (_quantities[index] == 1) {
                                                  sitesToShow.add(
                                                      _productsOnOrder[index]);
                                                  total -=
                                                      _productsOnOrder[index]
                                                          ['pivot']['price'];
                                                  _quantities.removeAt(index);
                                                  _productsOnOrder
                                                      .removeAt(index);
                                                } else {
                                                  --_quantities[index];
                                                  total -=
                                                      _productsOnOrder[index]
                                                          ['pivot']['price'];
                                                }
                                              } else {
                                                if (_quantities[index] == 1) {
                                                  products.add(
                                                      _productsOnOrder[index]);
                                                  total -=
                                                      _productsOnOrder[index]
                                                          ['pivot']['price'];
                                                  _quantities.removeAt(index);
                                                  _productsOnOrder
                                                      .removeAt(index);
                                                } else {
                                                  --_quantities[index];
                                                  total -=
                                                      _productsOnOrder[index]
                                                          ['pivot']['price'];
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    gradient1.withOpacity(.1)),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  myHeight(context) / 100.0),
                                              child: Icon(
                                                Icons.remove,
                                                color: gradient1,
                                                size: myHeight(context) / 50.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_quantities[index] <
                                                  _productsOnOrder[index]
                                                      ['pivot']['qty']) {
                                                ++_quantities[index];
                                                total += _productsOnOrder[index]
                                                    ['pivot']['price'];
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    gradient1.withOpacity(.1)),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  myHeight(context) / 100.0),
                                              child: Icon(
                                                Icons.add,
                                                color: gradient1,
                                                size: myHeight(context) / 50.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (user.isAdmin == 1) {
                                              setState(() {
                                                sitesToShow.add(
                                                    _productsOnOrder[index]);
                                                total -= _quantities[index] *
                                                    _productsOnOrder[index]
                                                        ['pivot']['price'];
                                                _quantities.removeAt(index);
                                                _productsOnOrder
                                                    .removeAt(index);
                                              });
                                            } else {
                                              setState(() {
                                                products.add(
                                                    _productsOnOrder[index]);
                                                total -= _quantities[index] *
                                                    _productsOnOrder[index]
                                                        ['pivot']['price'];
                                                _quantities.removeAt(index);
                                                _productsOnOrder
                                                    .removeAt(index);
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    Colors.red.withOpacity(.1)),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  myHeight(context) / 90.0),
                                              child: Icon(
                                                AmazingIcon.delete_bin_6_line,
                                                color: Colors.red,
                                                size: myHeight(context) / 60.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 70.0),
                        side: BorderSide(color: Colors.black12)),
                    onPressed: _show,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: myHeight(context) / 70.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: myWidth(context) / 20.0,
                          ),
                          Text(
                            'Ajouter un produit',
                            style: TextStyle(
                              fontSize: myHeight(context) / 45.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 70.0)),
                    height: myHeight(context) / 13.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: myHeight(context) / 70.0,
                          bottom: myHeight(context) / 70.0,
                          left: myWidth(context) / 30.0,
                          right: myWidth(context) / 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexOfPaymentMode = 0;
                                labelOfPaymentMode = 'C A S H';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: indexOfPaymentMode == 0
                                      ? Border(
                                          bottom: BorderSide(color: gradient1))
                                      : Border()),
                              child: Image.asset('img/Cash.png'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexOfPaymentMode = 1;
                                labelOfPaymentMode = 'O M';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: indexOfPaymentMode == 1
                                      ? Border(
                                          bottom: BorderSide(color: gradient1))
                                      : Border()),
                              child: Image.asset('img/OM.png'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                indexOfPaymentMode = 2;
                                labelOfPaymentMode = 'M O M O';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: indexOfPaymentMode == 2
                                      ? Border(
                                          bottom: BorderSide(color: gradient1))
                                      : Border()),
                              child: Image.asset('img/MTN.png'),
                            ),
                          ),
                          Container(
                            width: myWidth(context) / 10.0,
                            child: VerticalDivider(
                              thickness: 1.5,
                            ),
                          ),
                          Container(
                            child: Text(
                              labelOfPaymentMode,
                              style:
                                  TextStyle(fontSize: myHeight(context) / 40.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: myHeight(context) / 300.0),
                        child: Text(
                          'TOTAL: ',
                          style: TextStyle(fontSize: myHeight(context) / 55.0),
                        ),
                      ),
                      Text(
                        '$total FCFA',
                        style: TextStyle(fontSize: myHeight(context) / 35.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),
                  InkWell(
                    onTap: _productsOnOrder == null || _productsOnOrder.isEmpty
                        ? null
                        : () => showDifferenceDialog(
                            _productsOnOrder,
                            _quantities,
                            user.isAdmin == 1 ? site.id : currentSite['id']),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth(context) / 20.0),
                        height: myHeight(context) / 22.0,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          gradient: _productsOnOrder == null ||
                                  _productsOnOrder.isEmpty
                              ? LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.grey, Colors.grey])
                              : LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [gradient1, gradient2]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            Text(
                              'Envoyer',
                              style: TextStyle(
                                  color: textSameModeColor,
                                  fontSize: myHeight(context) / 40.0),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: myWidth(context) / 25.0,
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
            _isLoading
                ? Container(
                    color: Colors.white.withOpacity(.9),
                    alignment: Alignment.center,
                    height: myHeight(context),
                    width: double.infinity,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(gradient1),
                    ))
                : Container(
                    height: 0.0,
                  )
          ],
        ),
      ),
    );
  }
}
