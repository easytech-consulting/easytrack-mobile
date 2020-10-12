import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/screens/home/agenda/calendar.dart';
import 'package:easytrack/screens/home/shopping.dart';
import 'package:flutter/material.dart';
import '../home/home.dart';

class Search extends StatefulWidget {
  Search();
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<Search> {
  @override
  void initState() {
    super.initState();
  }

  int currentTab;
  final List<Widget> screens = [
    MainPage(),
    ShoppingPage(),
    CalendarPage(),
  ];
  Widget currentScreen = MainPage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(backgroundColor: backgroundColor, body: Container()),
    );
  }
}
