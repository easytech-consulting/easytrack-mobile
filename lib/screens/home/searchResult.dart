import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/home/calendar.dart';
import 'package:easytrack/screens/home/chat.dart';
import 'package:easytrack/screens/home/shopping.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';
import 'home.dart';

class SearchResult extends StatefulWidget {
  final int index;
  SearchResult({this.index});
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  void initState() {
    super.initState();
    currentTab = widget.index;
  }

  TextEditingController _controller = TextEditingController();
  int currentTab;
  final List<Widget> screens = [
    MainPage(),
    ShoppingPage(),
    CalendarPage(),
    ChatPage()
  ];
  Widget currentScreen = MainPage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: screenSize(context).height / 10,
              decoration: BoxDecoration(
                  gradient: widget.index == 0
                      ? LinearGradient(
                          colors: [gradient1, gradient2],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)
                      : LinearGradient(
                          colors: [Color(0xffffffff), Color(0xffffffff)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 36.0,
                        decoration: textFormFieldBoxDecoration,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        height: 36.0,
                        child: TextFormField(
                          controller: _controller,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                              color: widget.index == 0
                                  ? Color(0xffffffff)
                                  : Color(0xff000000)),
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              prefixIcon: Icon(
                                  /* AmazingIcon.user_icon, */ Icons.search,
                                  color: widget.index == 0
                                      ? Color(0xffffffff)
                                      : Color(0xff000000),
                                  size: 20.0),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  /* AmazingIcon.user_icon, */ icon: Icon(
                                      Icons.close,
                                      color: widget.index == 0
                                          ? Color(0xffffffff)
                                          : Color(0xff000000),
                                      size: 20.0)),
                              hintText: 'Recherche...',
                              hintStyle: TextStyle(
                                  color: widget.index == 0
                                      ? Color(0xffffffff).withOpacity(.35)
                                      : Color(0xff000000).withOpacity(.35),
                                  fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Divider(),
            ),
            SizedBox(height: screenSize(context).height / 20.0),
            Icon(
              AmazingIcon.emotion_sad_line,
              size: 109.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                'Desole',
                style: subLogoTitleStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                'Nous n\'avons pas trouve',
                style: subLogoSubtitleStyle,
              ),
            ),
            Center(
              child: Text(
                'de resultats pour votre recherche',
                style: subLogoSubtitleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
