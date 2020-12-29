import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubSearchPurchases extends StatelessWidget {
  final List data, _suppliers, _sites, _initiators, _validators;
  SubSearchPurchases(this.data, this._suppliers, this._sites, this._initiators,
      this._validators);

  List _purchases;

  showBill(context, _supplier, _site, _purchase, _initiator, {validator}) {
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: myHeight(context) / 30,
                horizontal: myHeight(context) / 25),
            height: myHeight(context) * .8,
            width: myWidth(context) * .9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
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
                              '${company.town}, ${company.street}',
                              style: TextStyle(
                                fontSize: myHeight(context) / 50.0,
                              ),
                            ),
                          ],
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
                  SizedBox(
                    height: myHeight(context) / 30.0,
                  ),
                  Text(
                    'Date: ${_purchase["created_at"]}',
                    style: TextStyle(
                      fontSize: myHeight(context) / 50.0,
                    ),
                  ),
                  Text(
                    'Reference: P0-${_purchase["code"]}',
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
                  _purchase['status'] == 0
                      ? Text('Statut: Non paye')
                      : Container(
                          color: Colors.blueGrey.withOpacity(.3),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: myHeight(context) / 100.0,
                                horizontal: 1.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Paye par: ${_purchase["paying_method"].toUpperCase()}',
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
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 20.0),
                        gradient:
                            LinearGradient(colors: [gradient1, gradient2])),
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

  Widget build(BuildContext context) {
    _purchases = data;

    return data == null
        ? Center(
            child: Text('Aucune valeur'),
          )
        : data.isEmpty
            ? Center(child: Text('Vide'))
            : ListView.builder(
                itemCount: _purchases.length,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: myHeight(context) / 100.0,
                        horizontal: myHeight(context) / 40.0),
                    child: Container(
                        height: myHeight(context) / 6.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(myHeight(context) / 70.0)),
                            border: Border.all(color: Colors.black12)),
                        child: Padding(
                          padding: EdgeInsets.all(myHeight(context) / 60.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      showBill(
                                          context,
                                          _suppliers[index],
                                          _sites[index],
                                          _purchases[index],
                                          _initiators[index],
                                          validator: _validators[index]);
                                    },
                                    child: Container(
                                      width: myWidth(context) / 1.4,
                                      child: Text(
                                        'P0 - ${_purchases[index]["code"]}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                screenSize(context).height / 35,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                      child: Icon(
                                    AmazingIcon.more_2_fill,
                                    size: 25.0,
                                    color: Colors.black,
                                  ))
                                ],
                              ),
                              Text(
                                capitalize(_suppliers[index].name),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize:
                                        screenSize(context).height / 42.0),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    _purchases[index]['status'] == 1
                                        ? 'Paye'
                                        : 'Non paye',
                                    style: TextStyle(
                                        color: _purchases[index]['status'] == 1
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize:
                                            screenSize(context).height / 45.0),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${formatDate(DateTime.parse(_purchases[index]["created_at"]))}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize:
                                            screenSize(context).height / 62.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))));
  }
}
