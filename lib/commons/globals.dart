import 'dart:convert';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/company.dart';
import 'package:easytrack/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../styles/style.dart';

Widget successAlertIcon(BuildContext context) {
  return Container(
    width: 100.0,
    height: 100.0,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: lightBlueColor.withOpacity(.1),
        borderRadius: BorderRadius.all(Radius.circular(50.0))),
    child: Icon(AmazingIcon.check_fill, color: lightBlueColor, size: 50),
  );
}

Widget errorAlertIcon(BuildContext context) {
  return Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        color: redColor.withOpacity(.1),
        borderRadius: BorderRadius.all(Radius.circular(50.0))),
    child: Icon(AmazingIcon.alert_line, color: redColor, size: 50),
  );
}

storeToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', token);
  await prefs.setBool('isLogged', true);
}

storeUserDetails(
    userData, siteData, userHasSite, companyData, userHasCompany) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String prefsUser = json.encode(userData), roleData = json.encode(userRole);
  await prefs.setString('user', prefsUser);
  await prefs.setString('roles', roleData);
  if (userHasCompany) {
    String prefsCompany = json.encode(companyData);
    await prefs.setString('company', prefsCompany);
  }
  if (userHasSite) {
    String prefsSite = json.encode(siteData);
    String prefsCompany = json.encode(companyData);
    await prefs.setString('site', prefsSite);
    await prefs.setString('company', prefsCompany);
  }
}

getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return json.decode(prefs.getString('user'));
}

getUserSite() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return json.decode(prefs.getString('site'));
}

getUserSnack() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return json.decode(prefs.getString('snack'));
}

getUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

getUserRoles() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('roles') == null
      ? []
      : prefs.getStringList('roles');
}

nextNode(BuildContext context, FocusNode oldNode, FocusNode newNode) {
  oldNode.unfocus();
  FocusScope.of(context).requestFocus(newNode);
}

userLogged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogged') == null ? false : prefs.getBool('isLogged');
}

setFirstConnexion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstConnexion', false);
}

getFirstConnexion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('firstConnexion') == null
      ? true
      : prefs.getBool('firstConnexion');
}

disconnectUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLogged', false);
}

final String endPoint =
    'https://easytracknew-easytrackdev.azurewebsites.net/api';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

int errorStatusCode, userId;
Map userRole;
String userToken;
User user;
Site site;
Company company;
