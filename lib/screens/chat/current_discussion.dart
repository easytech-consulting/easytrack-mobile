import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/chat/show.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class CurrentDiscussion extends StatefulWidget {
  @override
  _CurrentDiscussionState createState() => _CurrentDiscussionState();
}

class _CurrentDiscussionState extends State<CurrentDiscussion> {
  TextEditingController _controller;
  FocusNode _node;
  List dataToShow, allData;
  bool _searchMode = false;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _node = FocusNode();
    loadData();
  }

  loadData() {
    dataToShow = allUserContacts;
    allData = allUserContacts;
  }

  searchMethod(List items, filter) {
    List result = [];
    for (var item in items) {
      if (item['name'].toLowerCase().contains(filter.toLowerCase())) {
        if (!result.contains(item)) {
          result.add(item);
        }
      }
    }
    return filter == '' ? items : result;
  }

  generateBackgroundColor(int index) {
    List colors = [
      Color(0xFFC9DFF2),
      Color(0xFFC8EBF0),
      Color(0xFFC9F6FB),
      Color(0xFFD7EDC7),
      Color(0xFFCBD2F7),
      Color(0xFFE6C6F7)
    ];

    return colors[index % colors.length];
  }

  generateTextColor(int index) {
    List colors = [
      Color(0xFF2680C9),
      Color(0xFF26B0C3),
      Color(0xFF23B0C3),
      Color(0xFF61B820),
      Color(0xFF324CDE),
      Color(0xFF9A1CDD)
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header2(context, 'Chat', () {}),
                Expanded(
                  child: ListView.builder(
                      itemCount: dataToShow.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowDiscussion(
                                      user: dataToShow[index]))),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.black12))),
                            height: myHeight(context) / 8,
                            padding: EdgeInsets.symmetric(
                              vertical: myHeight(context) / 30.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: myHeight(context) / 15.0,
                                  height: myHeight(context) / 15.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    dataToShow[index]['name']
                                        .substring(0, 2)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: generateTextColor(index),
                                        fontWeight: FontWeight.bold,
                                        fontSize: myHeight(context) / 55),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: generateBackgroundColor(index)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: myHeight(context) / 50.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: myWidth(context) / 2,
                                        child: Text(
                                          dataToShow[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                                  myHeight(context) / 45.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                          width: myWidth(context) / 2,
                                          child: Text(
                                            'Demarrer la conversation',
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Text('10:30')
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ));
  }
}

/* GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowDiscussion(
                                              user: dataToShow[index]))),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: myHeight(context) / 100.0,
                                        horizontal: 20.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: myHeight(context) / 15.0,
                                          height: myHeight(context) / 15.0,
                                          alignment: Alignment.center,
                                          child: dataToShow[index]['photo'] ==
                                                  null
                                              ? Text(
                                                  dataToShow[index]['name']
                                                      .substring(0, 2)
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          myHeight(context) /
                                                              45),
                                                )
                                              : SizedBox(
                                                  height: 0.0,
                                                ),
                                          decoration: dataToShow[index]
                                                      ['photo'] ==
                                                  null
                                              ? BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: generateColor(index))
                                              : BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'img/persons/${dataToShow[index]['photo']}'),
                                                      fit: BoxFit.cover)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  myHeight(context) / 50.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dataToShow[index]['name'],
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            45.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height:
                                                    myHeight(context) / 150.0,
                                              ),
                                              Container(
                                                  child: Text(
                                                      'Demarrer la conversation')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                 */

/* Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Container(
              height: myHeight(context) * .89,
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        title: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'img/logos/LogoWithText.png',
                                      width: myHeight(context) / 6.0,
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _searchMode = true;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                myHeight(context) / 50.0),
                                        child: Icon(AmazingIcon.search_2_line),
                                      ),
                                    ),
                                    Container(
                                      width: myWidth(context) / 7.5,
                                      height: myWidth(context) / 7.5,
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: textInverseModeColor
                                                .withOpacity(.12),
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              myHeight(context) / 50.0),
                                          child: Text(
                                            '${user.name.substring(0, 2).toUpperCase()}',
                                            style: TextStyle(
                                                color: textSameModeColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    myHeight(context) / 50.0),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        floating: true,
                        primary: true,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(
                            myHeight(context) / 10.0,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(myHeight(context) / 33.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: myHeight(context) / 30.0,
                                      ),
                                      onTap: () => Navigator.pop(context)),
                                  SizedBox(
                                    width: myHeight(context) / 30.0,
                                  ),
                                  Text(
                                    'Chats',
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Icon(AmazingIcon.list_settings_fill)
                                ],
                              ),
                            ),
                          ),
                        ),
                        expandedHeight: myHeight(context) / 5.5,
                      ),
                      SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => childCount: dataToShow.length,
                              ),
                            )
                    ],
                  ),
                  dataToShow == null || dataToShow.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          child: Text('Aucun contact'),
                        )
                      : Container(
                          height: 0.0,
                        )
                ],
              ))),
    ); */
