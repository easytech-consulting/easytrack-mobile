import 'dart:convert';
import 'dart:math';
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
    /* 
    String prefsCompany = json.encode(companyData); */
    await prefs.setString('site', prefsSite);
    /* 
    await prefs.setString('company', prefsCompany); */
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

double myHeight(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait
      ? MediaQuery.of(context).size.height
      : MediaQuery.of(context).size.width;
}

double myWidth(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.height;
}

checkNumberValidity(String value, {canBeEmpty = false}) {
  if (value.isEmpty) {
    return canBeEmpty ? null : 'Champs obligatoire';
  }
  if (value.length != 9) {
    return 'Numero doit avoir 9 chiffres';
  }
  if (value.substring(0, 1) != "6") {
    return 'Numero commence par 6';
  }
  if (!["5", "6", "7", "8", "9"].contains(value.substring(1, 2))) {
    return "Numero invalide";
  }
  return null;
}

List months = [
  'Janvier',
  'Fevrier',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Aout',
  'Septembre',
  'Octobre',
  'Novembre',
  'Decembre'
];

checkEmailValidity(String value, {canBeEmpty = false}) {
  RegExp _emailValidity = new RegExp(r'[a-zA-Z0-9]{2,}@[a-z]{2,5}.[a-z]{2,3}');
  if (value.isEmpty) {
    return canBeEmpty ? null : 'Champs obligatoire';
  }
  if (!_emailValidity.hasMatch(value)) {
    return 'Email incorrect';
  }
  return null;
}

formatHour(DateTime date) {
  return '${date.add(Duration(hours: 1)).hour}: ${date.minute}';
}

formatDate(DateTime date) {
  DateTime now = DateTime.now().subtract(Duration(hours: 1));
  return now.difference(date).inSeconds <= 0
      ? 'A l\'instant'
      : now.difference(date).inSeconds <= 60
          ? '${now.difference(date).inSeconds} secs'
          : now.difference(date).inMinutes <= 60
              ? '${now.difference(date).inMinutes} mins'
              : now.difference(date).inHours <= 24
                  ? '${now.difference(date).inHours} hrs'
                  : now.difference(date).inDays <= 7
                      ? '${now.difference(date).inDays} jrs'
                      : now.difference(date).inDays ~/ 7 <= 4
                          ? '${(now.difference(date).inDays ~/ 7)} smns'
                          : now.difference(date).inDays ~/ 30 < 12
                              ? '${(now.difference(date).inDays ~/ 30)} mois'
                              : '${(now.difference(date).inDays ~/ 365)} ans';
}

generateColor() {
  List colors = [
    Colors.amber.withOpacity(.5),
    Colors.amberAccent.withOpacity(.5),
    Colors.blue.withOpacity(.5),
    Colors.blueAccent.withOpacity(.5),
    Colors.blueGrey.withOpacity(.5),
    Colors.brown.withOpacity(.5),
    Colors.cyan.withOpacity(.5),
    Colors.cyanAccent.withOpacity(.5),
    Colors.deepOrange.withOpacity(.5),
    Colors.deepOrangeAccent.withOpacity(.5),
    Colors.deepPurple.withOpacity(.5),
    Colors.green.withOpacity(.5),
    Colors.greenAccent.withOpacity(.5),
    Colors.indigo.withOpacity(.5),
    Colors.grey.withOpacity(.5),
    Colors.indigoAccent.withOpacity(.5),
    Colors.lightBlue.withOpacity(.5),
    Colors.lightBlueAccent.withOpacity(.5),
    Colors.lightGreenAccent.withOpacity(.5),
    Colors.lime.withOpacity(.5),
    Colors.limeAccent.withOpacity(.5),
    Colors.orange.withOpacity(.5),
    Colors.orangeAccent.withOpacity(.5),
    Colors.pink.withOpacity(.5),
    Colors.purple.withOpacity(.5),
    Colors.purpleAccent.withOpacity(.5),
    Colors.red.withOpacity(.5),
    Colors.redAccent.withOpacity(.5),
    Colors.teal.withOpacity(.5),
    Colors.tealAccent.withOpacity(.5),
    Colors.yellow.withOpacity(.5),
    Colors.yellowAccent.withOpacity(.5)
  ];

  int generatedIndex = Random().nextInt(colors.length);
  return colors[generatedIndex];
}

int errorStatusCode, userId;
Map userRole;
String userToken;
User user;
Site site;
Company company;
int allSales,
    allPurchases,
    dailySales,
    dailyPurchases,
    allIncomes,
    dailyIncomes;
