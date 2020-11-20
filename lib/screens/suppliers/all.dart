import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/supplier.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class SupplierPage extends StatefulWidget {
  final data;
  final String sitename;
  const SupplierPage({Key key, this.data, this.sitename}) : super(key: key);
  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  List _suppliers;
  String name;
  bool _isLoading;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    name = widget.sitename;
    _isLoading = false;
    _suppliers = widget.data.map((data) => Supplier.fromJson(data)).toList();
    globalSuppliers = _suppliers;
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
                    sliverHeader(context, 'Site $name', 'Fournisseurs',
                        canAdd: false, onClick: null),
                    _suppliers == null || _suppliers.length == 0
                        ? SliverList(
                            delegate: SliverChildListDelegate.fixed([
                              Container(
                                height: myHeight(context) / 1.5,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Aucun fournisseur',
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
                                                    _suppliers[index],
                                                  ), */
                                                  child: Container(
                                                    width:
                                                        myWidth(context) / 1.4,
                                                    child: Text(
                                                      '${capitalize(_suppliers[index].street)}',
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
                                                  '${_suppliers[index].town}, Cameroun',
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
                                                  '${_suppliers[index].tel1}',
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
                            }, childCount: _suppliers.length),
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
