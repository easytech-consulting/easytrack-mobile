import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:flutter/material.dart';

class SubSearchCustomer extends StatelessWidget {
  final List data;
  SubSearchCustomer(this.data);
  @override
  Widget build(BuildContext context) {
    List _customers = data;
    return data == null
        ? Center(
            child: Text('Aucune valeur'),
          )
        : data.isEmpty
            ? Center(child: Text('Aucune correspondance'))
            : ListView.builder(
                itemCount: _customers.length,
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
                                  InkWell(
                                    child: Container(
                                      width: myWidth(context) / 1.4,
                                      child: Text(
                                        '${capitalize(_customers[index].name)}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                screenSize(context).height / 35,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                      /*  onTap: () => _showBu(index),
                                                    */
                                      child: Icon(
                                    AmazingIcon.more_2_fill,
                                    size: 25.0,
                                    color: Colors.black,
                                  ))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.map_pin_2_line,
                                    color: Colors.black54,
                                    size: myHeight(context) / 40.0,
                                  ),
                                  SizedBox(
                                    width: screenSize(context).width / 40,
                                  ),
                                  Text(
                                    '${_customers[index].town}, ${_customers[index].street}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize:
                                            screenSize(context).height / 42.0),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.phone_line,
                                    color: Colors.black54,
                                    size: myHeight(context) / 40.0,
                                  ),
                                  SizedBox(
                                    width: screenSize(context).width / 40,
                                  ),
                                  Text(
                                    '699177985',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize:
                                            screenSize(context).height / 42.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))),
              );
  }
}
