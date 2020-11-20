import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:flutter/material.dart';

class SubSearchProducts extends StatelessWidget {
  final List data;
  SubSearchProducts(this.data);

  @override
  Widget build(BuildContext context) {
    List _products = data;
    return data == null
        ? Center(
            child: Text('Aucune valeur'),
          )
        : data.isEmpty
            ? Center(child: Text('Aucune correspondance'))
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: index == 0
                            ? myHeight(context) / 50.0
                            : myHeight(context) / 100.0,
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
                                  Container(
                                    width: myWidth(context) / 1.4,
                                    child: Text(
                                      '${_products[index].name}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize:
                                              screenSize(context).height / 35,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    AmazingIcon.more_2_fill,
                                    size: 25.0,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              Container(
                                width: myWidth(context) / 1.3,
                                child: Text(
                                  '${_products[index].qty} EN STOCK',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize:
                                          screenSize(context).height / 42.0),
                                ),
                              ),
                              Container(
                                width: myWidth(context) / 1.3,
                                child: Text(
                                  '${_products[index].price} XAF  A LA VENTE',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize:
                                          screenSize(context).height / 42.0),
                                ),
                              ),
                            ],
                          ),
                        ))),
              );
  }
}
