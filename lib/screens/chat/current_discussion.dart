import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/gradientIcon.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/chat/all.dart';
import 'package:easytrack/screens/chat/show.dart';
import 'package:easytrack/screens/notifications/all.dart';
import 'package:easytrack/screens/site/all.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class CurrentDiscussion extends StatefulWidget {
  @override
  _CurrentDiscussionState createState() => _CurrentDiscussionState();
}

class _CurrentDiscussionState extends State<CurrentDiscussion> {
  bool _isLoading;
  OverlayEntry _overlayEntryAdmin, _overlayEntry2;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  _showAbonnement() {
    this._overlayEntryAdmin.remove();
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
      this._overlayEntryAdmin = this._createOverlayEntryAdmin();
      Overlay.of(context).insert(this._overlayEntryAdmin);
    });
  }

  //Create Menu
  OverlayEntry _createOverlayEntryAdmin() {
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
                      onTap: () => this._overlayEntryAdmin.remove(),
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
                                this._overlayEntryAdmin.remove();
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
                                this._overlayEntryAdmin.remove();
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
                                  this._overlayEntryAdmin.remove();
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

  checkUser({String id}) async {
    QueryDocumentSnapshot result;
    result = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get()
        .then((value) => value.docs.first);

    return result;
  }

  searchMethod(List items, filter) {
    List result = [];
    for (var item in items) {
      if (item['name'].toLowerCase().contains(filter.toLowerCase())) {
        if (!result.contains(item)) {
          result.add(item);
        }
      }
    }
    return filter == '' ? items : result;
  }

  colorsSendOnFirebase(bool isText, int index) {
    List colors;
    if (isText) {
      colors = ["2680C9", "26B0C3", "23B0C3", "61B820", "324CDE", "9A1CDD"];
    } else {
      colors = ['C9DFF2', 'C8EBF0', 'C9F6FB', 'D7EDC7', 'CBD2F7', 'E6C6F7'];
    }

    return colors[index % colors.length];
  }

  generateBackgroundColor(int index) {
    List colors = [
      Color(0xFFC9DFF2),
      Color(0xFFC8EBF0),
      Color(0xFFC9F6FB),
      Color(0xFFD7EDC7),
      Color(0xFFCBD2F7),
      Color(0xFFE6C6F7)
    ];

    return colors[index % colors.length];
  }

  generateTextColor(int index) {
    List colors = [
      Color(0xFF2680C9),
      Color(0xFF26B0C3),
      Color(0xFF23B0C3),
      Color(0xFF61B820),
      Color(0xFF324CDE),
      Color(0xFF9A1CDD)
    ];

    return colors[index % colors.length];
  }

  OverlayEntry _overlayEntryDelete;
  onClick(String code) {
    setState(() {
      _overlayEntryDelete = this._createOverlayEntryDelete(code);
      Overlay.of(context).insert(this._overlayEntryDelete);
    });
  }

  _createOverlayEntryDelete(code) {
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
                      onTap: () => this._overlayEntryDelete.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    height: myHeight(context) * .18,
                    padding: EdgeInsets.only(top: 10),
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
                            height: myHeight(context) / 60,
                          ),
                          InkWell(
                            onTap: () {
                              this._overlayEntryDelete.remove();
                              FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                transaction.set(
                                  FirebaseFirestore.instance
                                      .collection('messages')
                                      .doc(code),
                                  {
                                    'delete': 1,
                                  },
                                );
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.file_shred_line,
                                    size: myHeight(context) / 30.0,
                                    color: gradient1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: myHeight(context) / 25.0),
                                    child: Text(
                                      'Retirer la conversation',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: myHeight(context) / 40.0,
                                          color: textInverseModeColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              this._overlayEntryDelete.remove();
                              setState(() {
                                _isLoading = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('messages')
                                  .doc(code)
                                  .collection(code)
                                  .get()
                                  .then((value) {
                                value.docs.map((e) => e.reference
                                    .delete()
                                    .then((_) => print('Ending deletion $e')));
                              }).then((value) => FirebaseFirestore.instance
                                      .collection('messages')
                                      .doc(code)
                                      .delete()
                                      .then((__) => setState(() {
                                            _isLoading = false;
                                          })));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.delete_bin_6_line,
                                    size: myHeight(context) / 30.0,
                                    color: Colors.red,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: myHeight(context) / 25.0),
                                    child: Text(
                                      'Supprimer',
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: myHeight(context) / 40.0,
                                          color: textInverseModeColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllContacts()),
        ),
        child: GradientIcon(AmazingIcon.chat_new_line, myHeight(context) / 33,
            LinearGradient(colors: [gradient1, gradient2])),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                header2(context, 'Chat',
                    user.isAdmin == 1 ? _showUser : _showAdmin, 5),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .where('delete', isEqualTo: 0)
                      .where('users', arrayContains: user.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: snapshot.data.docs == null ||
                                snapshot.data.docs.length == 0
                            ? Center(
                                child: Text('Aucune conversation'),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  String _id;
                                  print(snapshot.data.docs[index]
                                      .data()['users']
                                      .map((value) {
                                    if (value != user.id &&
                                        value != user.id.toString()) {
                                      _id = value.toString();
                                    }
                                  }));
                                  return FutureBuilder(
                                    future: checkUser(id: _id),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        return GestureDetector(
                                          onLongPress: () => onClick(
                                              user.id < int.parse(_id)
                                                  ? '${user.id}-$_id'
                                                  : '$_id-${user.id}'),
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowDiscussion(
                                                          textColor:
                                                              colorsSendOnFirebase(
                                                                  true, index),
                                                          bgcolor:
                                                              colorsSendOnFirebase(
                                                                  false, index),
                                                          user: userSnapshot
                                                              .data
                                                              .data()))),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.black12))),
                                            height: myHeight(context) / 8,
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  myHeight(context) / 30.0,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width:
                                                      myHeight(context) / 15.0,
                                                  height:
                                                      myHeight(context) / 15.0,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    userSnapshot.data
                                                        .data()['name']
                                                        .substring(0, 2)
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color:
                                                            generateTextColor(
                                                                index),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            myHeight(context) /
                                                                55),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          generateBackgroundColor(
                                                              index)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          myHeight(context) /
                                                              50.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width:
                                                            myWidth(context) /
                                                                2,
                                                        child: Text(
                                                          capitalize(
                                                              userSnapshot.data
                                                                      .data()[
                                                                  'name']),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  45.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                          width:
                                                              myWidth(context) /
                                                                  2,
                                                          child: Text(
                                                            snapshot.data
                                                                        .docs[index]
                                                                        .data()[
                                                                    'lastmessage'] ??
                                                                '...'
                                                                    .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(formatHour(DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                            snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                'date']))
                                                    .toString())
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black12))),
                                        height: myHeight(context) / 8,
                                        padding: EdgeInsets.symmetric(
                                          vertical: myHeight(context) / 30.0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: myHeight(context) / 15.0,
                                              height: myHeight(context) / 15.0,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black12),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      myHeight(context) / 50.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width:
                                                          myWidth(context) / 2,
                                                      height:
                                                          myHeight(context) /
                                                              40.0,
                                                      color: Colors.black12),
                                                  SizedBox(
                                                    height: myHeight(context) /
                                                        500.0,
                                                  ),
                                                  Container(
                                                    color: Colors.black12,
                                                    height: myHeight(context) /
                                                        40.0,
                                                    width:
                                                        myWidth(context) / 1.7,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }),
                      );
                    }

                    return Expanded(
                        child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(gradient1),
                      ),
                    ));
                  },
                ),
              ],
            ),
          )),
          _isLoading
              ? Container(
                  height: myHeight(context),
                  width: double.infinity,
                  color: textSameModeColor.withOpacity(.89),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(gradient1),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
