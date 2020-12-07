import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/current_discussion.dart';
import 'package:easytrack/screens/home/agenda/calendar.dart';
import 'package:easytrack/screens/home/shopping.dart';
import 'package:easytrack/screens/home/stats/stats.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final int index;
  final Widget element;
  MainPage({this.index, this.element});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _currentIndex;
  bool bottom = true;
  @override
  void initState() {
    super.initState();
    
    _currentIndex = widget.index ?? 0;
    _pageController = new PageController(initialPage: _currentIndex);
  }


  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> _bottomItems = [
      BottomNavigationBarItem(
          activeIcon: Icon(AmazingIcon.logo___white,
              color: Colors.white, size: myHeight(context) / 25),
          icon: Icon(AmazingIcon.logo___white),
          title: Text('Accueil')),
      BottomNavigationBarItem(
          activeIcon: Icon(AmazingIcon.building_2_line,
              color: Colors.white, size: myHeight(context) / 25),
          icon: Icon(AmazingIcon.building_2_line),
          title: Text('Produits')),
      BottomNavigationBarItem(
          activeIcon: Icon(AmazingIcon.calendar_line,
              color: Colors.white, size: myHeight(context) / 25),
          icon: Icon(AmazingIcon.calendar_line),
          title: Text('Promotions')),
      BottomNavigationBarItem(
          activeIcon: Icon(AmazingIcon.chat_1_line,
              color: Colors.white, size: myHeight(context) / 25),
          icon: Icon(AmazingIcon.chat_1_line),
          title: Text('Chat')),
    ];

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        bottomNavigationBar: Container(
          height: myHeight(context) / 10.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [gradient1, gradient2],
                  begin: Alignment.center,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.8])),
          child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              unselectedIconTheme:
                  IconThemeData(color: Colors.white.withOpacity(.4)),
              iconSize: myHeight(context) / 35,
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
        ),
        body: Scaffold(
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
            children: [_items[_currentIndex]],
          ),
        ),
      ),
    );
  }
}

List<Widget> _items = <Widget>[
  StatsPage(),
  ShoppingPage(),
  CalendarPage(),
  CurrentDiscussion()
];
