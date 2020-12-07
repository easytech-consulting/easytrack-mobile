import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/gradientIcon.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class LostConnection extends StatefulWidget {
  @override
  _LostConnectionState createState() => _LostConnectionState();
}

class _LostConnectionState extends State<LostConnection> {
  bool _connectionEstablished;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    _connectionEstablished = false;
    attemptReconnexion();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  attemptReconnexion() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        connectionEstablishedRedirection();
      }
    });
  }

  connectionEstablishedRedirection() {
    setState(() {
      _connectionEstablished = true;
    });
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            )));
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
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            body: SafeArea(
                child: Stack(
          children: [
            user.isAdmin == 2
                ? Scaffold(
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
                          unselectedIconTheme: IconThemeData(
                              color: Colors.white.withOpacity(.4)),
                          iconSize: myHeight(context) / 35,
                          currentIndex: 0,
                          items: _bottomItems),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => null,
                      backgroundColor: Colors.white,
                      child: GradientIcon(
                        Icons.add,
                        myHeight(context) / 22,
                        LinearGradient(
                            colors: [gradient1, gradient2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                    ),
                    body: Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              header(context, () {}),
                              SizedBox(
                                height: myHeight(context) / 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: myHeight(context) / 30.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: myWidth(context) * .75,
                                          height: myHeight(context) / 80,
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            elevation: 10.0,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: textInverseModeColor
                                                        .withOpacity(.05)),
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            10.0))),
                                          ),
                                        ),
                                        Container(
                                          width: myWidth(context) * .8,
                                          height: myHeight(context) / 80,
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            elevation: 10.0,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: textInverseModeColor
                                                        .withOpacity(.05)),
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            10.0))),
                                          ),
                                        ),
                                        Container(
                                          height: myHeight(context) / 4.5,
                                          child: Card(
                                            elevation: 10.0,
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: textInverseModeColor
                                                        .withOpacity(.05)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 19.5,
                                                      vertical: 15.25),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text('Ventes',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: myHeight(
                                                                      context) /
                                                                  50.0)),
                                                      Spacer(),
                                                      GestureDetector(
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Global',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      myHeight(
                                                                              context) /
                                                                          50.0),
                                                            ),
                                                            SizedBox(
                                                                width: myWidth(
                                                                        context) /
                                                                    40),
                                                            Icon(
                                                              AmazingIcon
                                                                  .arrow_down_s_line,
                                                              color: Colors
                                                                  .black87,
                                                              size: myHeight(
                                                                      context) /
                                                                  40.0,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        '100K',
                                                        style: TextStyle(
                                                            color:
                                                                textInverseModeColor,
                                                            fontSize: myHeight(
                                                                    context) /
                                                                20.0),
                                                      ),
                                                      Text(
                                                        ' Fcfa',
                                                        style: TextStyle(
                                                            color:
                                                                textInverseModeColor,
                                                            fontSize: myHeight(
                                                                    context) /
                                                                20.0),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      height:
                                                          myHeight(context) /
                                                              13.5,
                                                      width: double.infinity,
                                                      child: Image.asset(
                                                          'img/charts.png',
                                                          fit: BoxFit.cover))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: myHeight(context) / 30.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: myHeight(context) / 30.0),
                                    child: Text(
                                      'Commandes recentes',
                                      style: mainPartTitleStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: myHeight(context) / 60.0,
                                  ),
                                  Container(
                                      height: myHeight(context) / 2.5,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: myHeight(context) / 30.0),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return Container(
                                            child: InkWell(
                                                child: Container(
                                                    height:
                                                        myHeight(context) / 6.4,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          myWidth(context) /
                                                              50.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                myHeight(
                                                                        context) /
                                                                    90.0)),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .1))),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: myWidth(
                                                                      context) /
                                                                  30.0,
                                                              vertical: myHeight(
                                                                      context) /
                                                                  70.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                'S0-532934',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            33.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Spacer(),
                                                              Icon(
                                                                Icons.more_vert,
                                                                size: myWidth(
                                                                        context) /
                                                                    16.0,
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: myHeight(
                                                                        context) /
                                                                    62),
                                                            child: Container(
                                                              width: myWidth(
                                                                  context),
                                                              height: 30.0,
                                                              child: ListView
                                                                  .builder(
                                                                      physics:
                                                                          null,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemCount:
                                                                          1,
                                                                      itemBuilder:
                                                                          (context,
                                                                              ind) {
                                                                        return Text(
                                                                          '3x Guinness',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: textInverseModeColor.withOpacity(.54),
                                                                              fontSize: myHeight(context) / 45.0),
                                                                        );
                                                                      }),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: myHeight(
                                                                        context) /
                                                                    200.0),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  index % 7 == 2
                                                                      ? 'Paye'
                                                                      : index % 3 ==
                                                                              1
                                                                          ? 'Servie'
                                                                          : 'En attente',
                                                                  style: TextStyle(
                                                                      color: index %
                                                                                  7 ==
                                                                              2
                                                                          ? Colors
                                                                              .green
                                                                          : index % 3 == 1
                                                                              ? Colors
                                                                                  .orange
                                                                              : gradient1,
                                                                      fontSize:
                                                                          screenSize(context).height /
                                                                              53.0),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  'Il y\'a 3min',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black26,
                                                                      fontSize:
                                                                          screenSize(context).height /
                                                                              60.0),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ))),
                                          );
                                        },
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
                : Scaffold(
                    body: Stack(
                      children: [
                        Column(
                          children: [
                            header(context, () {}),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: myHeight(context) / 50.0,
                                        horizontal: myHeight(context) / 40.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          child: Text(
                                            'Commandes',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    myHeight(context) / 35.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(
                                          width: myWidth(context) / 30.0,
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            'Utilisateur',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    myHeight(context) / 45.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                myWidth(context) / 30.0),
                                        child: Container(
                                          child: InkWell(
                                              child: Container(
                                                  height:
                                                      myHeight(context) / 6.4,
                                                  margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        myWidth(context) / 50.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              myHeight(
                                                                      context) /
                                                                  90.0)),
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  .1))),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: myWidth(
                                                                    context) /
                                                                30.0,
                                                            vertical: myHeight(
                                                                    context) /
                                                                70.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              'S0-12345',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      myHeight(
                                                                              context) /
                                                                          33.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Spacer(),
                                                            Icon(
                                                              Icons.more_vert,
                                                              size: myWidth(
                                                                      context) /
                                                                  16.0,
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: myHeight(
                                                                      context) /
                                                                  62),
                                                          child: Container(
                                                            width: myWidth(
                                                                context),
                                                            height: 30.0,
                                                            child: ListView
                                                                .builder(
                                                                    physics:
                                                                        null,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount:
                                                                        1,
                                                                    itemBuilder:
                                                                        (context,
                                                                            ind) {
                                                                      return Text(
                                                                        '3x Guinness...',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: textInverseModeColor.withOpacity(.54),
                                                                            fontSize: myHeight(context) / 45.0),
                                                                      );
                                                                    }),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: myHeight(
                                                                      context) /
                                                                  200.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                index % 7 == 1
                                                                    ? 'Paye'
                                                                    : index % 3 ==
                                                                            2
                                                                        ? 'Servie'
                                                                        : 'En attente',
                                                                style: TextStyle(
                                                                    color: index %
                                                                                7 ==
                                                                            1
                                                                        ? Colors
                                                                            .green
                                                                        : index % 3 ==
                                                                                2
                                                                            ? Colors
                                                                                .orange
                                                                            : gradient1,
                                                                    fontSize:
                                                                        screenSize(context).height /
                                                                            53.0),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                'Il y\'a 3min',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black26,
                                                                    fontSize:
                                                                        screenSize(context).height /
                                                                            60.0),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ))),
                                        ),
                                      );
                                    },
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
            Container(
                color: Colors.white.withOpacity(.98),
                width: double.infinity,
                height: double.infinity,
                child: _connectionEstablished
                    ? Column(
                        children: [
                          Spacer(),
                          networkIcon(
                              context,
                              Color(0xff267FC9).withOpacity(.25),
                              Color(0xff267FC9),
                              AmazingIcon.check_fill),
                          SizedBox(
                            height: myHeight(context) / 30.0,
                          ),
                          Text(
                            'Connexion retablie',
                            style: TextStyle(
                                fontSize: myHeight(context) / 45.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: myHeight(context) / 100.0,
                          ),
                          Text(
                            'Vous etes de nouveau connecte a notre serveur',
                            style: TextStyle(
                              fontSize: myHeight(context) / 50.0,
                            ),
                          ),
                          Text(
                            'Continuer de travailler en toute securite',
                            style: TextStyle(
                              fontSize: myHeight(context) / 50.0,
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Spacer(),
                          networkIcon(
                              context,
                              Color(0xffFFC42A).withOpacity(.25),
                              Color(0xffFFC42A),
                              AmazingIcon.global_line),
                          SizedBox(
                            height: myHeight(context) / 30.0,
                          ),
                          Text(
                            'Connexion perdue',
                            style: TextStyle(
                                fontSize: myHeight(context) / 45.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: myHeight(context) / 100.0,
                          ),
                          Text(
                            'Impossible d\'etablir une connexion avec notre',
                            style: TextStyle(
                              fontSize: myHeight(context) / 50.0,
                            ),
                          ),
                          Text(
                            'serveur. Verifier votre acces internet',
                            style: TextStyle(
                              fontSize: myHeight(context) / 50.0,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: attemptReconnexion,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      myHeight(context) / 10.0),
                                  border: Border.all(color: Colors.black)),
                              margin: EdgeInsets.symmetric(
                                  horizontal: myWidth(context) / 5.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: myWidth(context) / 20.0,
                                vertical: myWidth(context) / 50.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Actualiser',
                                    style: TextStyle(
                                        fontSize: myHeight(context) / 43.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    AmazingIcon.refresh_line,
                                    size: myHeight(context) / 40,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Spacer()
                        ],
                      )),
          ],
        ))));
  }
}
