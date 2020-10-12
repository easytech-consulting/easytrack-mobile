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
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: myHeight(context) / 10.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [gradient1, gradient2],
            begin: Alignment.center,
            end: Alignment.centerRight,
            stops: [0.0, 0.8]
          )),
          child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(.4)),
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
