import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/company.dart';
import 'package:easytrack/models/user.dart';
import 'package:easytrack/services/agendaService.dart';
import 'package:easytrack/services/contactService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

storeTokenExpireDate(String date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('expire_date', date);
}

getTokenExpireDate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('expire_date');
}

storeUserDetails(userData, siteData, userHasSite, companyData, userHasCompany,
    userRole) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String prefsUser = json.encode(userData), roleData = json.encode(userRole);
  await prefs.setString('user', prefsUser);
  await prefs.setString('role', roleData);
  if (userHasCompany) {
    String prefsCompany = json.encode(companyData);
    await prefs.setString('company', prefsCompany);
  }
  if (userHasSite) {
    String prefsSite = json.encode(siteData);
    await prefs.setString('site', prefsSite);
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
  return json.decode(prefs.getString('company'));
}

getUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

getUserRoles() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return json.decode(prefs.getString('role'));
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
  return prefs.getBool('firstConnexion') ?? true;
}

disconnectUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLogged', false);
}

changeMode(bool isDarkMode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool('is_dark_mode', isDarkMode);
}

getThemeMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_dark_mode') ?? false;
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
                          ? '${(now.difference(date).inDays ~/ 7)} sem'
                          : now.difference(date).inDays ~/ 30 < 12
                              ? '${(now.difference(date).inDays ~/ 30)} mois'
                              : '${(now.difference(date).inDays ~/ 365)} ans';
}

capitalize(String data) {
  List words = data.split(' ');
  String result = '';
  int index = 0;
  for (var word in words) {
    
    result += index == words.length - 1
        ? '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}'
        : '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()} ';
  }

  return result;
}

loadModeColor(ThemeMode themeMode) {
  if (ThemeMode.dark == themeMode) {
    textInverseModeColor = Colors.white;
    textSameModeColor = Colors.black;
    decorationColor = Colors.white.withOpacity(.07);
    iconColor = Colors.white;
    backgroundColor = Color(0xff101d25);
    outlineBtnColor = Colors.white;
    raisedBtnColor = Colors.white;
    flatButtonColor = Colors.white;
  } else {
    textInverseModeColor = Colors.black;
    textSameModeColor = Colors.white;
    decorationColor = Colors.black.withOpacity(.05);
    iconColor = Colors.black;
    backgroundColor = Colors.white;
    outlineBtnColor = Colors.black;
    raisedBtnColor = Colors.black;
    flatButtonColor = Colors.black;
  }
}

logUserOnFirebase() async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: user.id.toString())
      .get();
  if (result != null) {
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      FirebaseFirestore.instance.collection('users').doc().set({
        'email': user.email.toString(),
        'id': user.id.toString(),
        'name': user.name.toString(),
        'phone': user.tel.toString(),
        'photo': user.photo.toString(),
        'username': user.username.toString()
      });
    }
  }
}

formatPrice(int price) {
  if (price == null) return '0';
  String result = price.toString();
  if (price > 1000) {
    result = '${price ~/ 1000}k';
  }

  if (price > 1000000) {
    result = '${price ~/ 1000000}m';
  }

  return result;
}

String spaceWord(String word) {
  String newWord = '';
  for (var i = 0; i < word.length; i++) {
    newWord += word[i] + ' ';
  }
  return newWord;
}

String getDay(DateTime date) {
  String eng = DateFormat('EEEE').format(date.add(Duration(days: 1)));
  if (eng == 'Monday') {
    return 'LUNDI';
  } else if (eng == 'Tuesday') {
    return 'MARDI';
  } else if (eng == 'Wednesday') {
    return 'MERCREDI';
  } else if (eng == 'Thursday') {
    return 'JEUDI';
  } else if (eng == 'Friday') {
    return 'VENDREDI';
  } else if (eng == 'Saturday') {
    return 'SAMEDI';
  }
  return 'DIMANCHE';
}

int errorStatusCode, userId;
bool showBottom;
Map userRole;
String userToken;
User user;
Site site;
Company company;
ThemeMode appThemeMode;
Color textInverseModeColor,
    textSameModeColor,
    decorationColor,
    iconColor,
    backgroundColor,
    outlineBtnColor,
    raisedBtnColor,
    flatButtonColor;
int allSales,
    allPurchases,
    dailySales,
    dailyPurchases,
    allIncomes,
    dailyIncomes;
