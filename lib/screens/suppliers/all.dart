import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/supplier.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class SupplierPage extends StatefulWidget {
  final data;

  const SupplierPage({Key key, this.data}) : super(key: key);
  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  List _suppliers;
  bool _isLoading;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _isLoading = false;
    _suppliers = widget.data.map((data) => Supplier.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: backgroundColor,
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'img/logos/LogoWithText.png',
                          width: myHeight(context) / 5.2,
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: myHeight(context) / 50.0),
                          child: Icon(
                            AmazingIcon.search_2_line,
                            size: myHeight(context) / 30.0,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: textInverseModeColor.withOpacity(.12),
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '${user.name.substring(0, 2).toUpperCase()}',
                              style:
                                  TextStyle(fontSize: myHeight(context) / 45.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back)),
                        SizedBox(
                          width: myHeight(context) / 40.0,
                        ),
                        Text(
                          'Fournisseurs',
                          style: TextStyle(
                              fontSize: myHeight(context) / 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                AmazingIcon.list_settings_fill,
                                size: myHeight(context) / 25.0,
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight(context) / 40.0,
                  ),
                  Container(
                      width: myWidth(context),
                      height: myHeight(context) * .78,
                      child: _suppliers == null || _suppliers.length == 0
                          ? Center(
                              child: Text('Aucun fournisseur'),
                            )
                          : ListView.builder(
                              itemCount: _suppliers.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        height: myHeight(context) / 5.2,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            border: Border.all(
                                                color: textInverseModeColor
                                                    .withOpacity(.38))),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: screenSize(context)
                                                              .width /
                                                          80),
                                                  child: Row(
                                                    children: <Widget>[
                                                      InkWell(
                                                        child: Text(
                                                          '${_suppliers[index].name.length > 30 ? _suppliers[index].name.substring(0, 30) + '...' : _suppliers[index].name}',
                                                          style: TextStyle(
                                                              fontSize: screenSize(
                                                                          context)
                                                                      .height /
                                                                  30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: screenSize(context)
                                                          .height /
                                                      40.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      AmazingIcon
                                                          .map_pin_2_line,
                                                    ),
                                                    SizedBox(
                                                      width: screenSize(context)
                                                              .width /
                                                          70,
                                                    ),
                                                    Text(
                                                      'Yaounde, Cameroun',
                                                      style: TextStyle(
                                                          color:
                                                              textInverseModeColor
                                                                  .withOpacity(
                                                                      .54),
                                                          fontSize: screenSize(
                                                                      context)
                                                                  .height /
                                                              38.0),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: screenSize(context)
                                                          .height /
                                                      40.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      AmazingIcon.phone_line,
                                                    ),
                                                    SizedBox(
                                                      width: screenSize(context)
                                                              .width /
                                                          70,
                                                    ),
                                                    Text(
                                                      _suppliers[index]
                                                          .tel1
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              textInverseModeColor
                                                                  .withOpacity(
                                                                      .54),
                                                          fontSize: screenSize(
                                                                      context)
                                                                  .height /
                                                              38.0),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )));
                              })),
                ],
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
        ));
  }
}
