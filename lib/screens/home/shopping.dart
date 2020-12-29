import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/category.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/notifications/all.dart';
import 'package:easytrack/screens/products/all.dart';
import 'package:easytrack/screens/purchases/all.dart';
import 'package:easytrack/screens/sales/all.dart';
import 'package:easytrack/screens/sales/manage.dart';
import 'package:easytrack/screens/site/all.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List _categories;
  OverlayEntry _overlayEntry, _overlayEntry2;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _categories =
        globalCategories.map((cat) => Category.fromJson(cat)).toList();
    _categories.insert(0, Category(id: 0, name: 'Produits'));
    _isLoading = false;
  }

  _showAbonnement() {
    this._overlayEntry.remove();
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: myHeight(context) / 30,
                horizontal: myHeight(context) / 25),
            height: myHeight(context) * .65,
            width: myWidth(context) * .9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: myWidth(context) / 1.5,
                      child: Text(
                        'Mon Abonnement',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: myHeight(context) / 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(AmazingIcon.close_line))
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Row(
                  children: [
                    Icon(AmazingIcon.secure_payment_line, color: gradient1),
                    SizedBox(
                      width: myHeight(context) / 40.0,
                    ),
                    Container(
                        width: myWidth(context) / 2,
                        child: Text(
                          'Version d\'essaie',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: myHeight(context) / 40.0),
                        ))
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Text('Nov 02, 2020 / Jan 31, 2021'),
                SizedBox(
                  height: myHeight(context) / 60.0,
                ),
                LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Color(0xffEEEEEE),
                    minHeight: 5,
                    valueColor: AlwaysStoppedAnimation(gradient1)),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                OutlineButton(
                    onPressed: () => launchURL(url: websiteUrl),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: gradient1),
                        borderRadius:
                            BorderRadius.circular(myHeight(context) / 70)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: myHeight(context) / 70.0),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Payer une nouvelle licence',
                        style: TextStyle(
                            color: gradient1,
                            fontSize: myHeight(context) / 48.0),
                      ),
                    )),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Text('Historique',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: myHeight(context) / 40.0)),
                SizedBox(
                  height: myHeight(context) / 40.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: myHeight(context) / 100.0),
                  decoration: BoxDecoration(
                      color: Color(0xffEEEEEE).withOpacity(.6),
                      border:
                          Border(bottom: BorderSide(color: Colors.black54))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Abonnement',
                            style:
                                TextStyle(fontSize: myHeight(context) / 47.0),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        width: myWidth(context) / 6,
                        child: Text('Prix',
                            style:
                                TextStyle(fontSize: myHeight(context) / 47.0),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        width: myWidth(context) / 5,
                        child: Text('Date',
                            style:
                                TextStyle(fontSize: myHeight(context) / 47.0),
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Version d\'essaie',
                        style: TextStyle(fontSize: myHeight(context) / 51.0),
                      ),
                    ),
                    Container(
                      width: myWidth(context) / 6,
                      child: Text('0 XFA',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    ),
                    Container(
                      width: myWidth(context) / 5,
                      child: Text('15 Aout 2020',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    )
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text('Silver',
                            style:
                                TextStyle(fontSize: myHeight(context) / 51.0))),
                    Container(
                        width: myWidth(context) / 6,
                        child: Text('30000 XFA',
                            style:
                                TextStyle(fontSize: myHeight(context) / 51.0))),
                    Container(
                      width: myWidth(context) / 5,
                      child: Text('20 Septembre 2020',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    )
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 80.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Gold',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    ),
                    Container(
                      width: myWidth(context) / 6,
                      child: Text('50000 XFA',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    ),
                    Container(
                      width: myWidth(context) / 5,
                      child: Text('30 Octobre 2020',
                          style: TextStyle(fontSize: myHeight(context) / 51.0)),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _logoutUser() async {
    setState(() {
      _isLoading = true;
    });
    await logout().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  _showAdmin() {
    setState(() {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry);
    });
  }

  //Create Menu
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0.0,
            height: myHeight(context),
            width: myWidth(context),
            child: Material(
              color: Colors.black38,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => this._overlayEntry.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      height: myHeight(context) * .8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(myHeight(context) / 70.0))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth(context) / 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: myWidth(context) / 7,
                                  height: myHeight(context) / 150.0,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(
                                          myHeight(context) / 100.0))),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff267FC9),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        myHeight(context) / 50.0),
                                    child: Text(
                                      '${user.name.substring(0, 2).toUpperCase()}',
                                      style: TextStyle(
                                          color: textSameModeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: myHeight(context) / 50.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: myWidth(context) / 20.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${capitalize(user.name)}',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: myHeight(context) / 40.0),
                                    ),
                                    Text(
                                      '${capitalize(company.name.toLowerCase())} (${capitalize(userRole["name"])})',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.38),
                                          fontSize: myHeight(context) / 60.0),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: myHeight(context) / 20.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                this._overlayEntry.remove();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationsPage()));
                              },
                              child: Row(
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      Icon(
                                        AmazingIcon.notification_4_line,
                                        color: textInverseModeColor,
                                        size: myHeight(context) / 35.0,
                                      ),
                                      Positioned(
                                        top: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          width: myHeight(context) / 100.0,
                                          height: myHeight(context) / 100.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                this._overlayEntry.remove();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SitePage()));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.building_2_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Mes sites',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.bar_chart_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Rapports',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.settings_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Configurations',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: _showAbonnement,
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.money_dollar_circle_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Abonnement',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 20.0,
                            ),
                            Text(
                              'MENU',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.45),
                                  fontWeight: FontWeight.w500,
                                  fontSize: myHeight(context) / 45.0),
                            ),
                            SizedBox(
                              height: myHeight(context) / 35.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Politique de confidentialite',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Termes et conditions',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'A Propos',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Aide',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: myHeight(context) / 60.0),
                              child: GestureDetector(
                                onTap: () {
                                  this._overlayEntry.remove();
                                  _logoutUser();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      AmazingIcon.logout_box_line,
                                      color: textInverseModeColor,
                                      size: myHeight(context) / 30.0,
                                    ),
                                    SizedBox(
                                      width: myWidth(context) / 10.0,
                                    ),
                                    Text(
                                      'Deconnexion',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: myHeight(context) / 40.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }

  //Show Menu
  _showUser() {
    setState(() {
      this._overlayEntry2 = this._createOverlayEntry2();
      Overlay.of(context).insert(this._overlayEntry2);
    });
  }

  //Menu
  OverlayEntry _createOverlayEntry2() {
    return OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0.0,
            height: myHeight(context),
            width: myWidth(context),
            child: Material(
              color: Colors.black38,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => this._overlayEntry2.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      height: myHeight(context) * .67,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(myHeight(context) / 70.0))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth(context) / 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: myWidth(context) / 7,
                                  height: myHeight(context) / 150.0,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(
                                          myHeight(context) / 100.0))),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff267FC9),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        myHeight(context) / 50.0),
                                    child: Text(
                                      '${user.name.substring(0, 2).toUpperCase()}',
                                      style: TextStyle(
                                          color: textSameModeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: myHeight(context) / 50.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: myWidth(context) / 20.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${capitalize(user.name)}',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: myHeight(context) / 40.0),
                                    ),
                                    Text(
                                      '${capitalize(site.street.toLowerCase())} (${capitalize(userRole["name"])})',
                                      style: TextStyle(
                                          color: textInverseModeColor
                                              .withOpacity(.38),
                                          fontSize: myHeight(context) / 60.0),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: myHeight(context) / 20.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                this._overlayEntry2.remove();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationsPage()));
                              },
                              child: Row(
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      Icon(
                                        AmazingIcon.notification_4_line,
                                        color: textInverseModeColor,
                                        size: myHeight(context) / 35.0,
                                      ),
                                      Positioned(
                                        top: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          width: myHeight(context) / 100.0,
                                          height: myHeight(context) / 100.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Notifications',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.bar_chart_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Rapports',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 30.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Row(
                                children: [
                                  Icon(
                                    AmazingIcon.settings_line,
                                    color: textInverseModeColor,
                                    size: myHeight(context) / 35.0,
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 10.0,
                                  ),
                                  Text(
                                    'Configurations',
                                    style: TextStyle(
                                        color: textInverseModeColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: myHeight(context) / 45.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 20.0,
                            ),
                            Text(
                              'MENU',
                              style: TextStyle(
                                  color: textInverseModeColor.withOpacity(.45),
                                  fontWeight: FontWeight.w500,
                                  fontSize: myHeight(context) / 45.0),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Politique de confidentialite',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Termes et conditions',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'A Propos',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            SizedBox(
                              height: myHeight(context) / 55.0,
                            ),
                            GestureDetector(
                              onTap: () => launchURL(url: websiteUrl),
                              child: Text(
                                'Aide',
                                style: TextStyle(
                                    color: textInverseModeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: myHeight(context) / 45.0),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: myHeight(context) / 60.0),
                              child: GestureDetector(
                                onTap: () {
                                  this._overlayEntry2.remove();
                                  _logoutUser();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      AmazingIcon.logout_box_line,
                                      color: textInverseModeColor,
                                      size: myHeight(context) / 30.0,
                                    ),
                                    SizedBox(
                                      width: myWidth(context) / 10.0,
                                    ),
                                    Text(
                                      'Deconnexion',
                                      style: TextStyle(
                                          color: textInverseModeColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: myHeight(context) / 40.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    header2(
                        context,
                        user.isAdmin == 1 ? 'Mon Site' : 'Mon Snack',
                        user.isAdmin == 1 ? _showUser : _showAdmin,
                        0),
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Categories',
                          style: TextStyle(
                              fontSize: myHeight(context) / 40.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(),
                          height: myHeight(context) / 23.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: index == _categories.length - 1
                                        ? 0.0
                                        : myHeight(context) / 40),
                                child: GestureDetector(
                                  onTap: () => index == 0
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductPage()))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProductPage(
                                                    category:
                                                        _categories[index],
                                                  ))),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: gradient2.withOpacity(.2),
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: myHeight(context) / 40,
                                      ),
                                      child: index == 0
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  AmazingIcon.archive_line,
                                                  size:
                                                      myHeight(context) / 40.0,
                                                  color: gradient1,
                                                ),
                                                SizedBox(
                                                  width:
                                                      myHeight(context) / 65.0,
                                                ),
                                                Text(
                                                  '${_categories[index].name}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          myHeight(context) /
                                                              50.0,
                                                      color: gradient1,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              '${_categories[index].name}',
                                              style: TextStyle(
                                                  fontSize:
                                                      myHeight(context) / 50.0,
                                                  color: gradient1,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: myHeight(context) / 30.0,
                        ),
                        Container(
                          height: myHeight(context) / 3.5,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                height: myHeight(context) / 4.5,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: gradient1,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                          text: TextSpan(
                                              text: allSales == null
                                                  ? '0'
                                                  : '${formatPrice(allSales)}',
                                              style: TextStyle(
                                                  fontSize:
                                                      myHeight(context) / 20.0),
                                              children: [
                                            TextSpan(
                                                text: ' Ventes',
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            30.0)),
                                            TextSpan(
                                                text:
                                                    '\n${months[DateTime.now().month - 1]} ${DateTime.now().year}',
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            45.0,
                                                    color: Colors.white38))
                                          ])),
                                      SizedBox(
                                          height: myHeight(context) / 100.0),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SalePage())),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Voir toutes les ventes',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    myHeight(context) / 45.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: myHeight(context) / 100.0,
                                            ),
                                            Icon(
                                              AmazingIcon.arrow_right_s_line,
                                              color: Colors.white,
                                              size: myHeight(context) / 35.0,
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ManageSales())),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Gerer les ventes',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    myHeight(context) / 45.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: myHeight(context) / 100.0,
                                            ),
                                            Icon(
                                              AmazingIcon.arrow_right_s_line,
                                              color: Colors.white,
                                              size: myHeight(context) / 35.0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0.0,
                                child: Container(
                                  height: myHeight(context) / 3.5,
                                  child: Image.asset(
                                    'img/boy.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: myHeight(context) / 50.0,
                        ),
                        Container(
                          height: myHeight(context) / 3.8,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                height: myHeight(context) / 5.2,
                                decoration: BoxDecoration(
                                    color:
                                        textInverseModeColor.withOpacity(.12),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                                text: TextSpan(
                                                    text: allPurchases == null
                                                        ? "0"
                                                        : '${formatPrice(allPurchases)}',
                                                    style: TextStyle(
                                                        color: gradient1,
                                                        fontSize:
                                                            myHeight(context) /
                                                                20.0),
                                                    children: [
                                                  TextSpan(
                                                      text: ' Achats',
                                                      style: TextStyle(
                                                          fontSize: myHeight(
                                                                  context) /
                                                              30.0)),
                                                  TextSpan(
                                                      text:
                                                          '\n${months[DateTime.now().month - 1]} ${DateTime.now().year}',
                                                      style: TextStyle(
                                                          fontSize: myHeight(
                                                                  context) /
                                                              45.0,
                                                          color:
                                                              Colors.black38))
                                                ])),
                                            GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PurchasePage())),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Voir tous les achats',
                                                    style: TextStyle(
                                                      color:
                                                          textInverseModeColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          myHeight(context) /
                                                              45.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: myHeight(context) /
                                                        100.0,
                                                  ),
                                                  Icon(
                                                    AmazingIcon
                                                        .arrow_right_s_line,
                                                    color: textInverseModeColor,
                                                    size: myHeight(context) /
                                                        35.0,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0.0,
                                bottom: 0.0,
                                child: Container(
                                  height: myHeight(context) / 4,
                                  child: Image.asset(
                                    'img/girl.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
        ),
      ),
    );
  }
}
