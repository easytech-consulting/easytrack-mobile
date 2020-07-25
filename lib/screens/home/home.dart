import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/home/calendar.dart';
import 'package:easytrack/screens/home/chat.dart';
import 'package:easytrack/screens/home/shopping.dart';
import 'package:easytrack/screens/home/stats.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _currentIndex;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = new PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> _bottomItems = [
      BottomNavigationBarItem(
          activeIcon: Container(
              width: screenSize(context).height / 17,
              height: screenSize(context).height / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.home_line, color: gradient1)),
          icon: Icon(AmazingIcon.home_line),
          title: Text('Accueil')),
      BottomNavigationBarItem(
          activeIcon: Container(
              width: screenSize(context).height / 17,
              height: screenSize(context).height / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.shopping_cart_line, color: gradient1)),
          icon: Icon(AmazingIcon.shopping_cart_line),
          title: Text('Produits')),
      BottomNavigationBarItem(
          activeIcon: Container(
              width: screenSize(context).height / 17,
              height: screenSize(context).height / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.calendar_line, color: gradient1)),
          icon: Icon(AmazingIcon.calendar_line),
          title: Text('Promotions')),
      BottomNavigationBarItem(
          activeIcon: Container(
              width: screenSize(context).height / 17,
              height: screenSize(context).height / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.chat_1_line, color: gradient1)),
          icon: Icon(AmazingIcon.chat_1_line),
          title: Text('Commandes')),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: gradient1,
          iconSize: screenSize(context).height / 35,
          onTap: (int index) {
            if (_pageController.hasClients) {
              setState(() {
                _currentIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          },
          currentIndex: _currentIndex,
          items: _bottomItems),
      body: PageView(
        controller: _pageController,
        pageSnapping: true,
        onPageChanged: (index) {
          if (index < _items.length) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        scrollDirection: Axis.horizontal,
        children: _items,
      ),
    );
  }
}

List<Widget> _items = <Widget>[
  StatsPage(),
  ShoppingPage(),
  CalendarPage(),
  ChatPage()
];
