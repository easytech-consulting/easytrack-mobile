import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/product.dart';
import 'package:easytrack/models/site_with_id.dart';
import 'package:easytrack/models/supplier_with_id.dart';
import 'package:easytrack/models/user_with_id.dart';
import 'package:easytrack/screens/search/contacts.dart';
import 'package:easytrack/screens/search/notifications.dart';
import 'package:easytrack/screens/search/products.dart';
import 'package:easytrack/screens/search/purchases.dart';
import 'package:easytrack/screens/search/sales.dart';
import 'package:easytrack/screens/search/sites.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final int index;
  Search({@required this.index}) : assert(index != null);
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<Search> {
  TextEditingController _controller;
  int _currentIndex;
  Widget _widgetShow;
  FocusNode _node;
  List _sitesForSales = [];
  List _suppliersForPurchase = [],
      _sitesForPurchase = [],
      _initiatorsForPurchase = [],
      _validatorsForPurchase = [];

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _node = new FocusNode();
    _currentIndex = widget.index;
    initialPage(_currentIndex);
  }

  initialPage(int index) {
    if (_currentIndex == 0) {
      _widgetShow = SubSearchSales(_checkAllSales(globalSales), _sitesForSales);
    } else if (_currentIndex == 1) {
      _widgetShow = SubSearchSites(globalSites);
    } else if (_currentIndex == 2) {
      _widgetShow = SubSearchProducts(_fieldProductValues(globalProducts));
    } else if (_currentIndex == 3) {
      _widgetShow = SubSearchPurchases(
          _checkAllPurchases(globalPurchases),
          _suppliersForPurchase,
          _sitesForPurchase,
          _initiatorsForPurchase,
          _validatorsForPurchase);
    } else if (_currentIndex == 4) {
      _widgetShow = SubSearchNotification(globalNotifications);
    } else if (_currentIndex == 5) {
      _widgetShow = SubSearchContact(globalContacts);
    }
  }

  List _fieldProductValues(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var product in datas) {
        if (!result.contains(Product.fromJson(product))) {
          result.add(Product.fromJson(product));
        }
      }
    } else {
      for (var site in datas) {
        for (var product in site['products']) {
          if (!result.contains(Product.fromJson(product))) {
            result.add(Product.fromJson(product));
          }
        }
      }
    }

    return result;
  }

  List _checkAllSales(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var sale in datas) {
        _sitesForSales.add(site);
        result.add(sale);
      }
    } else {
      for (var site in datas) {
        for (var sale in site['sales']) {
          _sitesForSales.add(SiteWithId.fromJson(site));
          result.add(sale);
        }
      }
    }

    return result;
  }

  List _checkAllPurchases(datas) {
    List result = [];
    if (user.isAdmin == 1) {
      for (var purchase in datas) {
        _initiatorsForPurchase.add(UserWithId.fromJson(purchase['initiator']));
        _validatorsForPurchase.add(purchase['validator'] == null
            ? null
            : UserWithId.fromJson(purchase['validator']));
        _sitesForPurchase.add(site);
        _suppliersForPurchase
            .add(SupplierWithId.fromJson(purchase['supplier']));
        result.add(purchase);
      }
    } else {
      for (var site in datas) {
        for (var purchase in site['purchases']) {
          _initiatorsForPurchase
              .add(UserWithId.fromJson(purchase['initiator']));
          _validatorsForPurchase.add(purchase['validator'] == null
              ? null
              : UserWithId.fromJson(purchase['validator']));
          _sitesForPurchase.add(SiteWithId.fromJson(site));
          _suppliersForPurchase
              .add(SupplierWithId.fromJson(purchase['supplier']));
          result.add(purchase);
        }
      }
    }

    return result;
  }

  loadData(String value) {
    List result = [];
    List _toShow;

    if (_currentIndex == 0) {
      setState(() {
        _toShow = _checkAllSales(globalSales ?? []);
        for (var item in _toShow) {
          if (item['code'].toLowerCase().contains(value.toLowerCase()) ||
              "S0-${item['code']}"
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              "S0 - ${item['code']}"
                  .toLowerCase()
                  .contains(value.toLowerCase())) {
            result.add(item);
          } else if ('servie'.contains(value.toLowerCase()) &&
              item['status'] == 1) {
            result.add(item);
          } else if ('en attente'.contains(value.toLowerCase()) &&
              item['status'] == 0) {
            result.add(item);
          } else if ('payee'.contains(value.toLowerCase()) &&
              item['status'] == 2) {
            result.add(item);
          }
        }
        _widgetShow =
            SubSearchSales(value.isEmpty ? _toShow : result, _sitesForSales);
      });
    } else if (_currentIndex == 1) {
      setState(() {
        _toShow = globalSites ?? [];
        for (var item in _toShow) {
          if (item['street'].toLowerCase().contains(value.toLowerCase()) ||
              item['town'].toLowerCase().contains(value.toLowerCase()) ||
              item['name'].toLowerCase().contains(value.toLowerCase()) ||
              item['phone1'].toLowerCase().contains(value.toLowerCase())) {
            result.add(item);
          }
        }
        _widgetShow = SubSearchSites(value.isEmpty ? _toShow : result);
      });
    } else if (_currentIndex == 2) {
      setState(() {
        _toShow = _fieldProductValues(globalProducts) ?? [];
        for (var item in _toShow) {
          if (item.name.toLowerCase().contains(value.toLowerCase())) {
            result.add(item);
          }
        }
        _widgetShow = SubSearchProducts(value.isEmpty ? _toShow : result);
      });
    } else if (_currentIndex == 3) {
      setState(() {
        _toShow = _checkAllPurchases(globalPurchases ?? []);
        for (var item in _toShow) {
          if (item['code'].toLowerCase().contains(value.toLowerCase()) ||
              "P0-${item['code']}"
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              "P0 - ${item['code']}"
                  .toLowerCase()
                  .contains(value.toLowerCase())) {
            result.add(item);
          } else if ('non paye'.contains(value.toLowerCase()) &&
              item['status'] == 0) {
            result.add(item);
          } else if ('paye'.contains(value.toLowerCase()) &&
              item['status'] == 1) {
            result.add(item);
          } else if (_suppliersForPurchase[_toShow.indexOf(item)]
              .name
              .toLowerCase()
              .contains(value.toLowerCase())) {
            result.add(item);
          }
        }

        _widgetShow = SubSearchPurchases(
            value.isEmpty ? _toShow : result,
            _suppliersForPurchase,
            _sitesForPurchase,
            _initiatorsForPurchase,
            _validatorsForPurchase);
      });
    } else if (_currentIndex == 4) {
      setState(() {
        _toShow = globalNotifications ?? [];
        for (var item in _toShow) {
          if (item['text'].toLowerCase().contains(value.toLowerCase())) {
            result.add(item);
          }
        }
        _widgetShow = SubSearchNotification(value.isEmpty ? _toShow : result);
      });
    } else if (_currentIndex == 5) {
      setState(() {
        _toShow = globalContacts ?? [];
        for (var item in _toShow) {
          if (item['name'].toLowerCase().contains(value.toLowerCase())) {
            result.add(item);
          }
        }
        _widgetShow = SubSearchContact(value.isEmpty ? _toShow : result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: DefaultTabController(
            length: 6,
            initialIndex: widget.index,
            child: Scaffold(
                backgroundColor: backgroundColor,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(myHeight(context) / 5.5),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [gradient1, gradient2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: myHeight(context) / 50),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    AmazingIcon.arrow_left_line,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: myWidth(context) / 30.0,
                                ),
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 46.0,
                                        decoration: buildTextFormFieldContainer(
                                            decorationColor),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Container(
                                          height: 46.0,
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            style: TextStyle(
                                                color: textSameModeColor
                                                    .withOpacity(.87)),
                                            controller: _controller,
                                            focusNode: _node,
                                            onChanged: (value) {
                                              loadData(value);
                                            },
                                            onFieldSubmitted: (value) {
                                              loadData(value);
                                              _node.unfocus();
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 50.0),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    _controller.text = '';
                                                    _node.unfocus();
                                                    loadData(_controller.text);
                                                  },
                                                  child: Icon(
                                                      AmazingIcon.close_fill,
                                                      color: textSameModeColor),
                                                ),
                                                hintText: 'Recherche...',
                                                prefixIcon: Icon(
                                                    AmazingIcon.search_2_line,
                                                    color: textSameModeColor),
                                                hintStyle: TextStyle(
                                                    color: textSameModeColor
                                                        .withOpacity(.35),
                                                    fontSize: 18.0),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.white,
                          onTap: (value) => setState(() {
                            _currentIndex = value;
                            loadData(_controller.text);
                          }),
                          tabs: [
                            Tab(
                              icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(AmazingIcon.shopping_bag_3_line,
                                      size: myHeight(context) / 40.0,
                                      color: textSameModeColor),
                                  _currentIndex == 0
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: myWidth(context) / 60.0,
                                            ),
                                            Text(
                                              'Ventes',
                                              style: TextStyle(
                                                  color: textSameModeColor),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Tab(
                              icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(AmazingIcon.building_2_line,
                                      size: myHeight(context) / 40.0,
                                      color: textSameModeColor),
                                  _currentIndex == 1
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: myWidth(context) / 60.0,
                                            ),
                                            Text(
                                              'Sites',
                                              style: TextStyle(
                                                  color: textSameModeColor),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Tab(
                              icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(AmazingIcon.archive_line,
                                      size: myHeight(context) / 40.0,
                                      color: textSameModeColor),
                                  _currentIndex == 2
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: myWidth(context) / 60.0,
                                            ),
                                            Text(
                                              'Produits',
                                              style: TextStyle(
                                                  color: textSameModeColor),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Tab(
                              icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(AmazingIcon.calendar_line,
                                      size: myHeight(context) / 40.0,
                                      color: textSameModeColor),
                                  _currentIndex == 3
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: myWidth(context) / 60.0,
                                            ),
                                            Text(
                                              'Achats',
                                              style: TextStyle(
                                                  color: textSameModeColor),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Tab(
                              icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(AmazingIcon.notification_4_line,
                                      size: myHeight(context) / 40.0,
                                      color: textSameModeColor),
                                  _currentIndex == 4
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: myWidth(context) / 60.0,
                                            ),
                                            Text(
                                              'Notifications',
                                              style: TextStyle(
                                                  color: textSameModeColor),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Tab(
                              icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(AmazingIcon.chat_1_line,
                                      size: myHeight(context) / 40.0,
                                      color: textSameModeColor),
                                  _currentIndex == 5
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: myWidth(context) / 60.0,
                                            ),
                                            Text(
                                              'Contacts',
                                              style: TextStyle(
                                                  color: textSameModeColor),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                body: _widgetShow)));
  }
}
