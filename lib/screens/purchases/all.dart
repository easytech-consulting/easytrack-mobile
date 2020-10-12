import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/purchase.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/models/supplier_with_id.dart';
import 'package:easytrack/models/user_with_id.dart';
import 'package:easytrack/services/purchaseService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  Future _companyPurchases;
  List allPurchasesData;
  List _purchases;
  List _sites;
  List _initiators;
  List _validators;
  List _suppliers;
  bool _isLoading;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _suppliers = [];
    _sites = [];
    _initiators = [];
    _validators = [];
    _companyPurchases = fetchPurchases();
    _controller = new TextEditingController();
    _scaffoldKey = GlobalKey();
    _isLoading = false;
  }

  showBill(_supplier, _site, _purchase, _initiator, {validator}) {
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
                          'Recu bon de commande',
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
                          'Fournisseur: ${_supplier.name}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Text(
                          'telephone: ${_supplier.tel1}',
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
                          'Date: ${_purchase.createdAt}',
                          style: TextStyle(
                            fontSize: myHeight(context) / 50.0,
                          ),
                        ),
                        Text(
                          'Reference: P0-${_purchase.code}',
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
                          color: Colors.blueGrey.withOpacity(.3),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: myHeight(context) / 100.0,
                                horizontal: 1.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Paye par: ${_purchase.payingMethod}',
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
                            'Enregistrer',
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

  List _checkAllPurchases(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var purchase in datas) {
        _initiators.add(UserWithId.fromJson(purchase['initiator']));
        _validators.add(purchase['validator'] == null
            ? null
            : UserWithId.fromJson(purchase['validator']));
        _sites.add(site);
        _suppliers.add(SupplierWithId.fromJson(purchase['supplier']));
        result.add(purchase);
      }
    } else {
      for (var site in datas) {
        for (var purchase in site['purchases']) {
          _initiators.add(UserWithId.fromJson(purchase['initiator']));
          _validators.add(purchase['validator'] == null
              ? null
              : UserWithId.fromJson(purchase['validator']));
          _sites.add(SiteWithId.fromJson(site));
          _suppliers.add(SupplierWithId.fromJson(purchase['supplier']));
          result.add(purchase);
        }
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
                    _companyPurchases = fetchPurchases();
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
                  EdgeInsets.symmetric(horizontal: myWidth(context) / 30.0),
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
                        'Mes achats',
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
                        future: _companyPurchases,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            allPurchasesData = snapshot.data;
                            _purchases = _checkAllPurchases(allPurchasesData)
                                .map((sale) => Purchase.fromJson(sale))
                                .toList();
                            return _purchases == null || _purchases.length == 0
                                ? Center(
                                    child: Text('Aucun produit'),
                                  )
                                : ListView.builder(
                                    itemCount: _purchases.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => showBill(
                                            _suppliers[index],
                                            _sites[index],
                                            _purchases[index],
                                            _initiators[index],
                                            validator: _validators[index]),
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                height: myHeight(context) / 6.5,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(Radius
                                                            .circular(10.0)),
                                                    border: Border.all(
                                                        color:
                                                            textInverseModeColor
                                                                .withOpacity(
                                                                    .1))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: screenSize(
                                                                          context)
                                                                      .width /
                                                                  80),
                                                          child: InkWell(
                                                            child: Text(
                                                              'P0 - ${_purchases[index].code}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          35,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          _suppliers[index]
                                                              .name
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: screenSize(
                                                                          context)
                                                                      .height /
                                                                  43.0),
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              _purchases[index]
                                                                      .alreadyDelivered
                                                                  ? 'Paye'
                                                                  : 'Non paye',
                                                              style: TextStyle(
                                                                  color: _purchases[
                                                                              index]
                                                                          .alreadyDelivered
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          45.0),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              'Il y\'a ${formatDate(DateTime.parse(_purchases[index].createdAt))}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          62.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))),
                                      );
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
