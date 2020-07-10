import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/home/calendar.dart';
import 'package:easytrack/screens/home/chat.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:easytrack/screens/home/shopping.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class CustNavigationBar extends StatefulWidget {
  final int index;
  CustNavigationBar({this.index});
  @override
  _CustNavigationBarState createState() => _CustNavigationBarState();
}

class _CustNavigationBarState extends State<CustNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        iconSize: screenSize(context).height / 35,
        onTap: (int index) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _items[index].redirection));
        },
        currentIndex: widget.index,
        items: _items.map((_item) {
          return BottomNavigationBarItem(
              title: Text(""),
              icon: Container(
                  width: screenSize(context).height / 17,
                  height: screenSize(context).height / 17,
                  decoration: _item.id != widget.index
                      ? BoxDecoration(color: Colors.transparent)
                      : BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          color: gradient1.withOpacity(.1)),
                  child: Icon(_item.icon,
                      color: _item.id == widget.index
                          ? gradient1
                          : Colors.black38)));
        }).toList());
  }
}

class BottomItems {
  final int id;
  final IconData icon;
  final Widget redirection;

  BottomItems({this.id, this.icon, this.redirection});
}

List<BottomItems> _items = [
  BottomItems(icon: AmazingIcon.home_line, id: 0, redirection: HomePage()),
  BottomItems(
      icon: AmazingIcon.shopping_cart_line, id: 1, redirection: ShoppingPage()),
  BottomItems(
      icon: AmazingIcon.calendar_line, id: 2, redirection: CalendarPage()),
  BottomItems(icon: AmazingIcon.chat_1_line, id: 3, redirection: ChatPage()),
];
