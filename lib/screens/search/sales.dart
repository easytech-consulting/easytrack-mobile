import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/screens/sales/manage.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubSearchSales extends StatelessWidget {
  final List data, sites;
  SubSearchSales(this.data, this.sites);

  List _sales;
  List _productsOnSales;

  showBill(context, String _customer, _site, _sale, _products, _initiator,
      {validator}) {
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
                        /*  Text(
                          'Date: ${_sale["created_at"]}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ), */
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
                                  '${_products[index]["name"]}',
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
                                  "${_products[index]['pivot']['qty']} x ${_products[index]['pivot']['price']}",
                                  style: TextStyle(
                                    fontSize: myHeight(context) / 50.0,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "${_products[index]['pivot']['qty'] * _products[index]['pivot']['price']}",
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

  @override
  Widget build(BuildContext context) {
    _sales = data;
    _productsOnSales = [];
    for (var sale in _sales) {
      _productsOnSales.add(sale['products']);
    }
    return data == null
        ? Center(
            child: Text('Aucune valeur'),
          )
        : data.isEmpty
            ? Center(child: Text('Vide'))
            : ListView.builder(
                itemCount: _sales.length > 10 ? 10 : _sales.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageSales(),
                          )),
                      child: Container(
                          height: myHeight(context) / 6.4,
                          margin: EdgeInsets.symmetric(
                              vertical: myWidth(context) / 50.0,
                              horizontal: myHeight(context) / 40.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(myHeight(context) / 90.0)),
                              border: Border.all(
                                  width: 1.0,
                                  color: Colors.black.withOpacity(.1))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: myWidth(context) / 30.0,
                                vertical: myHeight(context) / 70.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'S0-${_sales[index]["code"]}',
                                      style: TextStyle(
                                          fontSize: myHeight(context) / 33.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: myHeight(context) / 62),
                                    alignment: Alignment.center,
                                    child: ListView.builder(
                                        physics: null,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _productsOnSales[index].length > 1
                                                ? 1
                                                : _productsOnSales[index]
                                                    .length,
                                        itemBuilder: (context, ind) {
                                          return Text(
                                            _productsOnSales[index].length > 1
                                                ? '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}...'
                                                : '${_productsOnSales[index][ind]['pivot']['qty']}x ${_productsOnSales[index][ind]['name']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: textInverseModeColor
                                                    .withOpacity(.54),
                                                fontSize:
                                                    myHeight(context) / 45.0),
                                          );
                                        }),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: myHeight(context) / 200.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        _sales[index]["status"] == 2
                                            ? 'Paye'
                                            : _sales[index]["status"] == 1
                                                ? 'Servie'
                                                : 'En attente',
                                        style: TextStyle(
                                            color: _sales[index]["status"] == 2
                                                ? Colors.green
                                                : _sales[index]["status"] == 1
                                                    ? Colors.orange
                                                    : gradient1,
                                            fontSize:
                                                screenSize(context).height /
                                                    53.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${formatDate(DateTime.parse(_sales[index]["created_at"]))}',
                                        style: TextStyle(
                                            color: Colors.black26,
                                            fontSize:
                                                screenSize(context).height /
                                                    60.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )));
                },
              );
  }
}
