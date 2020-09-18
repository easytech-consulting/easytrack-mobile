import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                top: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'img/logos/LogoWithText.png',
                        width: 120.0,
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(AmazingIcon.search_2_line),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: textInverseModeColor.withOpacity(.12), shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'EB',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 170.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: gradient1,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                                text: TextSpan(
                                    text: '30',
                                    style: TextStyle(fontSize: 40.0),
                                    children: [
                                  TextSpan(
                                      text: 'K Ventes',
                                      style: TextStyle(fontSize: 28.0)),
                                  TextSpan(
                                      text: '\nJuillet 2020',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: textSameModeColor.withOpacity(.38)))
                                ])),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Voir toutes les ventes',
                                  style: TextStyle(
                                    color: textSameModeColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  AmazingIcon.arrow_right_s_line,
                                  color: textSameModeColor,
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Gerer les ventes',
                                  style: TextStyle(
                                    color: textSameModeColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  AmazingIcon.arrow_right_s_line,
                                  color: textSameModeColor,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: SvgPicture.asset(
                        'svg/blue-man-character.svg',
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 200,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: 170.0,
                      decoration: BoxDecoration(
                          color: textInverseModeColor.withOpacity(.12),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                      text: TextSpan(
                                          text: '3',
                                          style: TextStyle(
                                              fontSize: 40.0, color: gradient1),
                                          children: [
                                        TextSpan(
                                            text: 'K Achats',
                                            style: TextStyle(fontSize: 28.0)),
                                        TextSpan(
                                            text: '\nJuillet 2020',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: textInverseModeColor.withOpacity(.38)))
                                      ])),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Gerer les achats',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        AmazingIcon.arrow_right_s_line,
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Mes fournisseurs',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        AmazingIcon.arrow_right_s_line,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      child: SvgPicture.asset(
                        'svg/blue-girl-character.svg',
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Categories',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(),
                    height: 32.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: gradient2.withOpacity(.2),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5.0),
                            child: Text(
                              'Bierres',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: gradient1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: gradient2.withOpacity(.2),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5.0),
                            child: Text(
                              'Bierres',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: gradient1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: gradient2.withOpacity(.2),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5.0),
                            child: Text(
                              'Bierres',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: gradient1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 12.0,
                            color: textSameModeColor,
                            offset: Offset(-10.0, 0)),
                        BoxShadow(
                            blurRadius: 30.0,
                            color: textSameModeColor,
                            offset: Offset(-20.0, 0)),
                        BoxShadow(
                            blurRadius: 100.0,
                            color: textSameModeColor,
                            offset: Offset(-50.0, 0))
                      ]),
                      child: GestureDetector(
                        child: Icon(
                          Icons.add,
                          color: gradient1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                height: 300.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: textInverseModeColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Stack(
                    children: <Widget>[
                      SvgPicture.asset('svg/blue-man-boxes-character.svg'),
                      Align(
                        alignment: Alignment.topRight,
                        child: RichText(
                            text: TextSpan(
                                text: '110',
                                style:
                                    TextStyle(fontSize: 60.0, color: gradient1),
                                children: [
                              TextSpan(
                                  text: '\nProduits\nen stock',
                                  style: TextStyle(fontSize: 20.0)),
                            ])),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, '/sales'),
                          child: Container(
                            height: screenSize(context).height / 15,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                gradient: LinearGradient(
                                    colors: [gradient1, gradient2],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Gerer les produits',
                                    style: TextStyle(
                                        color: textSameModeColor,
                                        fontSize:
                                            screenSize(context).height / 47),
                                  ),
                                  Spacer(),
                                  Icon(
                                    AmazingIcon.arrow_drop_right_line,
                                    color: textSameModeColor,
                                    size: screenSize(context).height / 25,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
