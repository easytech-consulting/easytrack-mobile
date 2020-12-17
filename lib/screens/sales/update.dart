import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/sales/manage.dart';
import 'package:easytrack/services/saleService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class UpdateSalesPage extends StatefulWidget {
  final List productsAlreadyInOrder;
  final sale;

  const UpdateSalesPage({Key key, this.productsAlreadyInOrder, this.sale})
      : super(key: key);
  @override
  _UpdateSalesPageState createState() => _UpdateSalesPageState();
}

class _UpdateSalesPageState extends State<UpdateSalesPage> {
  List _quantities;
  int total;
  bool _isLoading;
  int indexOfPaymentMode;
  String labelOfPaymentMode;

  @override
  void initState() {
    super.initState();
    _quantities = [];
    indexOfPaymentMode = 0;
    labelOfPaymentMode = 'C A S H';
    total = 0;
    _isLoading = false;
    initData();
  }

  initData() {
    for (var product in widget.productsAlreadyInOrder) {
      _quantities.add(product['pivot']['qty']);
      total += product['pivot']['price'] * product['pivot']['qty'];
    }
  }

  _attemptUpdate(saleData, List products, List quantities) async {
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
    params['customer_id'] = saleData['customer_id'].toString();
    params['site_id'] = saleData['site_id'].toString();
    params['status'] = saleData['status'].toString();
    params['paying_method'] =
        labelOfPaymentMode ?? saleData['paying_method'].toString();
    params['sale_note'] = '';
    setState(() {
      _isLoading = true;
    });
    await updateSale(params, saleData['id']).then((response) async {
      Map allData;
      Map toRemove;
      await FirebaseFirestore.instance.collection('sales').get().then((value) {
        value.docs.forEach((element) {
          for (var item in element.data()['sales']) {
            if (item['code'] == saleData['code']) {
              allData = element.data();
              toRemove = item;
            }
          }
        });
      });
      setState(() {
        _isLoading = false;
      });
      List _sales = allData['sales'];
      int index =
          _sales.indexWhere((element) => element['code'] == toRemove['code']);
      print(response['sale']['paying_method']);

      _sales.removeAt(index);
      toRemove['products'] = response['sale']['products'];
      _sales.insert(index, toRemove);
      await FirebaseFirestore.instance
          .collection('sales')
          .where('email', isEqualTo: allData['email'])
          .get()
          .then(
              (value) => value.docs.first.reference.update({'sales': _sales}));
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

  calculTotal(List datas) {
    int total = 0;
    for (var data in datas) {
      total += data['pivot']['price'] * data['pivot']['qty'];
    }
    return total;
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
                              'MISE A JOUR',
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
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          AmazingIcon.close_fill,
                          size: myHeight(context) / 25.0,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),

                  //products on order
                  Expanded(
                      child: widget.productsAlreadyInOrder == null ||
                              widget.productsAlreadyInOrder.length == 0
                          ? Center(
                              child: Text('Aucun produit ajoute'),
                            )
                          : ListView.builder(
                              itemCount: widget.productsAlreadyInOrder.length,
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
                                                  widget.productsAlreadyInOrder[
                                                      index]['name'],
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
                                                '${_quantities[index]}x ${widget.productsAlreadyInOrder[index]["pivot"]["price"]} FCFA',
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
                                                '${_quantities[index] * widget.productsAlreadyInOrder[index]["pivot"]["price"]} FCFA',
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
                                                  total -= widget
                                                          .productsAlreadyInOrder[
                                                      index]['pivot']['price'];
                                                  _quantities.removeAt(index);
                                                  widget.productsAlreadyInOrder
                                                      .removeAt(index);
                                                } else {
                                                  --_quantities[index];
                                                  total -= widget
                                                          .productsAlreadyInOrder[
                                                      index]['pivot']['price'];
                                                }
                                              } else {
                                                if (_quantities[index] > 1) {
                                                  --_quantities[index];
                                                  total -= widget
                                                          .productsAlreadyInOrder[
                                                      index]['pivot']['price'];
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
                                              ++_quantities[index];
                                              total +=
                                                  widget.productsAlreadyInOrder[
                                                      index]['pivot']['price'];
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
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),

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
                    onTap: () {
                      _attemptUpdate(widget.sale, widget.productsAlreadyInOrder,
                          _quantities);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth(context) / 20.0),
                        height: myHeight(context) / 22.0,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          gradient: LinearGradient(
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
