import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/current_discussion.dart';
import 'package:easytrack/screens/home/calendar.dart';
import 'package:easytrack/screens/home/shopping.dart';
import 'package:easytrack/screens/home/stats.dart';
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
    _currentIndex = widget.index == null ? 0 : widget.index;
    _pageController = new PageController(initialPage: _currentIndex);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                content: Container(
                    height: myHeight(context) / 2.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        errorAlertIcon(context),
                        SizedBox(
                          height: myHeight(context) / 40,
                        ),
                        Text(
                          'Quitter l\'application',
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: myWidth(context) / 22),
                        ),
                        SizedBox(height: myHeight(context) / 80),
                        Text(
                          'Vous allez sortir de l\'application',
                          style: TextStyle(
                              color: Color(0xff000000).withOpacity(.5),
                              fontSize: myWidth(context) / 25),
                        ),
                        SizedBox(
                          height: myHeight(context) / 40,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                color: gradient1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                onPressed: () => true,
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 40.0,
                                    child: Text(
                                      'Continuer',
                                      style:
                                          TextStyle(color: textSameModeColor),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: OutlineButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                borderSide:
                                    BorderSide(color: Color(0xff000000)),
                                onPressed: () => false,
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 40.0,
                                    child: Text('Fermer')),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))))) ??
        false;
  }

  
  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> _bottomItems = [
      BottomNavigationBarItem(
          activeIcon: Container(
              width: myHeight(context) / 17,
              height: myHeight(context) / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.home_line, color: gradient1)),
          icon: Icon(AmazingIcon.home_line),
          title: Text('Accueil')),
      BottomNavigationBarItem(
          activeIcon: Container(
              width: myHeight(context) / 17,
              height: myHeight(context) / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.shopping_cart_line, color: gradient1)),
          icon: Icon(AmazingIcon.shopping_cart_line),
          title: Text('Produits')),
      BottomNavigationBarItem(
          activeIcon: Container(
              width: myHeight(context) / 17,
              height: myHeight(context) / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.calendar_line, color: gradient1)),
          icon: Icon(AmazingIcon.calendar_line),
          title: Text('Promotions')),
      BottomNavigationBarItem(
          activeIcon: Container(
              width: myHeight(context) / 17,
              height: myHeight(context) / 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: gradient1.withOpacity(.1)),
              child: Icon(AmazingIcon.chat_1_line, color: gradient1)),
          icon: Icon(AmazingIcon.chat_1_line),
          title: Text('Commandes')),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: textSameModeColor,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            selectedItemColor: gradient1,
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
            children: _items,
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
