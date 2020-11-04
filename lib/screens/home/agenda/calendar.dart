import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/gradientIcon.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/home/agenda/show.dart';
import 'package:easytrack/services/agendaService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int indexOfCurrentSite;
  Map siteMap;
  Future _teams;
  bool _isLoading;
  List userSites;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    userSites = [];
    fetchSites();
  }

  loadSite() {
    indexOfCurrentSite = 0;
    siteMap = userSites[0];
    setState(() {
      _teams = fetchTeamsOfSites(siteMap['id']);
    });
  }

  fetchSites() async {
    setState(() {
      _isLoading = true;
    });
    await fetchSitesOfUser().then((value) {
      setState(() {
        _isLoading = false;
      });
      if (user.isAdmin == 2) {
        userSites = value;
      } else {
        userSites.add(value);
      }
      loadSite();
    });
  }

  OverlayEntry _overlayEntry;
  onAvatorClick() {
    setState(() {
      _overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry);
    });
  }

  var teamsNumber;

  identication(String day) {
    if (day == 'LUNDI') {
      return 1;
    }
    if (day == 'MARDI') {
      return 2;
    }
    if (day == 'MERCREDI') {
      return 3;
    }
    if (day == 'JEUDI') {
      return 4;
    }
    if (day == 'VENDREDI') {
      return 5;
    }
    if (day == 'SAMEDI') {
      return 6;
    }
    if (day == 'DIMANCHE') {
      return 7;
    }
  }

  loadData(datas) {
    teamsNumber = [];
    var temp = [];
    if (datas.length == 0) {
      temp = [0, 0, 0, 0, 0, 0, 0];
    } else {
      for (var data in datas) {
        temp.add(data);
      }
      int max = 7 - temp.length;
      for (var i = 0; i < max; i++) {
        temp.add(0);
      }
    }

    if (getDay(DateTime.now().subtract(Duration(days: 1))) == 'LUNDI') {
      teamsNumber = temp;
    } else if (getDay(DateTime.now().subtract(Duration(days: 1))) == 'MARDI') {
      for (var i = 1; i < temp.length + 1; i++) {
        teamsNumber.add(temp[i % 7]);
      }
    } else if (getDay(DateTime.now().subtract(Duration(days: 1))) ==
        'MERCREDI') {
      for (var i = 2; i < temp.length + 2; i++) {
        teamsNumber.add(temp[i % 7]);
      }
    } else if (getDay(DateTime.now().subtract(Duration(days: 1))) == 'JEUDI') {
      for (var i = 3; i < temp.length + 3; i++) {
        teamsNumber.add(temp[i % 7]);
      }
    } else if (getDay(DateTime.now().subtract(Duration(days: 1))) ==
        'VENDREDI') {
      for (var i = 4; i < temp.length + 4; i++) {
        teamsNumber.add(temp[i % 7]);
      }
    } else if (getDay(DateTime.now().subtract(Duration(days: 1))) == 'SAMEDI') {
      for (var i = 5; i < temp.length + 5; i++) {
        teamsNumber.add(temp[i % 7]);
      }
    } else if (getDay(DateTime.now().subtract(Duration(days: 1))) ==
        'DIMANCHE') {
      for (var i = 6; i < temp.length + 6; i++) {
        teamsNumber.add(temp[i % 7]);
      }
    }
    print(teamsNumber);
  }

  _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0.0,
            height: myHeight(context),
            width: myWidth(context),
            child: Material(
              color: Colors.black38,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => this._overlayEntry.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    height: myHeight(context) * .8,
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(myHeight(context) / 70.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth(context) / 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: myWidth(context) / 7,
                                height: myHeight(context) / 150.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(
                                        myHeight(context) / 100.0))),
                          ),
                          SizedBox(
                            height: myHeight(context) / 60,
                          ),
                          Container(
                            height: myHeight(context) / 17.0,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(
                                    myHeight(context) / 10.0)),
                            child: TextFormField(
                              style:
                                  TextStyle(fontSize: myHeight(context) / 42.0),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    AmazingIcon.search_2_line,
                                    color: Colors.black,
                                    size: myHeight(context) / 32.0,
                                  ),
                                  hintText: 'Recherche',
                                  hintStyle: TextStyle(
                                      fontSize: myHeight(context) / 42.0),
                                  contentPadding: EdgeInsets.only(
                                      left: myHeight(context) / 30.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          Expanded(
                            child: userSites == null || userSites.length == 0
                                ? Center(
                                    child: Text('Aucun site'),
                                  )
                                : ListView.builder(
                                    itemCount: userSites.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          this._overlayEntry.remove();
                                          setState(() {
                                            indexOfCurrentSite = index;
                                            siteMap = userSites[index];
                                            _teams = fetchTeamsOfSites(
                                                siteMap['id']);
                                          });
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: myHeight(context) /
                                                    40.0),
                                            height: myHeight(context) / 8.5,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        myHeight(context) /
                                                            100.0)),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  myHeight(context) / 50.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                            myWidth(context) /
                                                                1.5,
                                                        child: Text(
                                                          userSites[index]
                                                              ['name'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  33.0),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      index ==
                                                              indexOfCurrentSite
                                                          ? GradientIcon(
                                                              AmazingIcon
                                                                  .check_fill,
                                                              myHeight(
                                                                      context) /
                                                                  30.0,
                                                              LinearGradient(
                                                                  colors: [
                                                                    gradient1,
                                                                    gradient2
                                                                  ]))
                                                          : Container(
                                                              height: 0.0,
                                                            )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        AmazingIcon
                                                            .map_pin_2_line,
                                                        size:
                                                            myHeight(context) /
                                                                50.0,
                                                        color: Colors.black54,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            myWidth(context) /
                                                                30.0,
                                                      ),
                                                      Text(
                                                        '${userSites[index]["street"]}, ${userSites[index]["town"]}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: myHeight(
                                                                    context) /
                                                                47.0),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                      );
                                    }),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  getColors(index) {
    List colors = [
      [Color(0xFF267EC9), Color(0xFF26B1C3)],
      [Color(0xFF3F26C9), Color(0xFFBD26C3)],
      [Color(0xFFDE2222), Color(0xFFEDAB17)],
      [Color(0xFF97C926), Color(0xFF13AD84)],
      [Color(0xFF26C9C3), Color(0xFF00A7FF)],
      [Color(0xFFFFC400), Color(0xFFFFEA91)],
      [Color(0xFFFF53D7), Color(0xFFFF2B2B)]
    ];
    return colors[index % 7];
  }

  getColor(index) {
    List colors = [
      Color(0xFF267EC9),
      Color(0xFF3F26C9),
      Color(0xFFDE2222),
      Color(0xFF97C926),
      Color(0xFF26C9C3),
      Color(0xFFFFC400),
      Color(0xFFFF53D7)
    ];
    return colors[index % 7];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    header2(context, 'Agenda',
                        user.isAdmin == 1 ? () {} : onAvatorClick,
                        search: false),
                    Expanded(
                      child: FutureBuilder(
                        future: _teams,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            loadData(snapshot.data);
                            return Container(
                              margin:
                                  EdgeInsets.only(top: myHeight(context) / 100),
                              height: myHeight(context) * .8,
                              child: ListView.builder(
                                  itemCount: 7,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShowAgendaDayPage(
                                                  siteId: siteMap['id'],
                                                  day: getDay(DateTime.now()
                                                      .add(Duration(
                                                          days: index - 1))),
                                                  id: identication(getDay(
                                                      DateTime.now().add(Duration(
                                                          days:
                                                              index - 1))))))),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius: BorderRadius.circular(
                                              myHeight(context) / 70.0),
                                          color: Colors.white,
                                        ),
                                        margin: EdgeInsets.only(
                                            bottom: myHeight(context) / 37.0),
                                        height: myHeight(context) / 5.8,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              myHeight(context) / 35.0,
                                              myHeight(context) / 33.0,
                                              0.0,
                                              myHeight(context) / 30.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: myWidth(context) / 6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      (DateTime.now()
                                                              .add(Duration(
                                                                  days: index))
                                                              .day
                                                              .toString())
                                                          .toString(),
                                                      style: new TextStyle(
                                                          letterSpacing: -0.5,
                                                          fontSize: myHeight(
                                                                  context) /
                                                              15,
                                                          foreground: Paint()
                                                            ..shader =
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: getColors(
                                                                  index),
                                                            ).createShader(Rect
                                                                    .fromLTWH(
                                                                        0.0,
                                                                        0.0,
                                                                        200.0,
                                                                        70.0))),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          myHeight(context) /
                                                              100.0,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: myHeight(
                                                                  context) /
                                                              10.0),
                                                      height: 1.9,
                                                      width: myWidth(context) /
                                                          12.0,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              getColor(index)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: myWidth(context) / 30.0,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      spaceWord(getDay(
                                                          DateTime.now().add(
                                                              Duration(
                                                                  days: index -
                                                                      1)))),
                                                      style: TextStyle(
                                                          fontSize: myHeight(
                                                                  context) /
                                                              35.0),
                                                    ),
                                                    Text(
                                                      siteMap['name'],
                                                      style: TextStyle(
                                                          fontSize: myHeight(
                                                                  context) /
                                                              40.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${teamsNumber[index]} Equipe(s)',
                                                      style: TextStyle(
                                                          fontSize: myHeight(
                                                                  context) /
                                                              50.0),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(gradient1),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              _isLoading
                  ? Container(
                      width: myWidth(context),
                      height: myHeight(context),
                      color: textSameModeColor.withOpacity(.89),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(gradient1),
                        ),
                      ))
                  : Container(),
            ],
          ),
        ));
  }
}
