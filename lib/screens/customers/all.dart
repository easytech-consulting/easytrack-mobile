import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/customer.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget {
  final data;
  final sitename;
  const CustomerPage({Key key, this.data, this.sitename}) : super(key: key);
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List _customers;
  bool _isLoading;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String name;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _isLoading = false;
    name = widget.sitename;
    _customers =
        widget.data.map((customer) => Customer.fromJson(customer)).toList();
    globalClients = _customers;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
            backgroundColor: backgroundColor,
            key: _scaffoldKey,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    sliverHeader(context, 'Site $name', 'Clients', 0,
                        canSearch: false, canAdd: false, onClick: null),
                    _customers == null || _customers.length == 0
                        ? SliverList(
                            delegate: SliverChildListDelegate.fixed([
                              Container(
                                height: myHeight(context) / 1.5,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Aucun client',
                                  style: TextStyle(
                                      fontSize: myHeight(context) / 50.0),
                                ),
                              )
                            ]),
                          )
                        : SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: index == 0
                                          ? myHeight(context) / 50.0
                                          : myHeight(context) / 100.0,
                                      horizontal: myHeight(context) / 40.0),
                                  child: Container(
                                      height: myHeight(context) / 6.5,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  myHeight(context) / 70.0)),
                                          border: Border.all(
                                              color: Colors.black12)),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            myHeight(context) / 60.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                InkWell(
                                                  /* onTap: () => _showDetails(
                                                    _customers[index],
                                                  ), */
                                                  child: Container(
                                                    width:
                                                        myWidth(context) / 1.4,
                                                    child: Text(
                                                      '${capitalize(_customers[index].name)}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: screenSize(
                                                                      context)
                                                                  .height /
                                                              35,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  AmazingIcon.map_pin_2_line,
                                                  color: Colors.black54,
                                                  size:
                                                      myHeight(context) / 40.0,
                                                ),
                                                SizedBox(
                                                  width: screenSize(context)
                                                          .width /
                                                      40,
                                                ),
                                                Text(
                                                  '${_customers[index].town}, ${_customers[index].street}',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize:
                                                          screenSize(context)
                                                                  .height /
                                                              42.0),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  AmazingIcon.phone_line,
                                                  color: Colors.black54,
                                                  size:
                                                      myHeight(context) / 40.0,
                                                ),
                                                SizedBox(
                                                  width: screenSize(context)
                                                          .width /
                                                      40,
                                                ),
                                                Text(
                                                  '699177985',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize:
                                                          screenSize(context)
                                                                  .height /
                                                              42.0),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )));
                            }, childCount: _customers.length),
                          )
                  ],
                ),
                _isLoading
                    ? Container(
                        width: myWidth(context),
                        height: myHeight(context),
                        color: textSameModeColor.withOpacity(.89),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(gradient1),
                          ),
                        ))
                    : Container(),
              ],
            )));
  }
}
