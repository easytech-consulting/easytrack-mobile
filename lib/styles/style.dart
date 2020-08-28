import 'dart:ui';

import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
    primaryColor: Color(0xffffffff),
    fontFamily: 'Helvetica',
    scaffoldBackgroundColor: Colors.white);

Color gradient1 = Color(0xfff267FC9);
Color gradient2 = Color(0xff26B1C3);
Color redColor = Color(0xffED1A22);
Color greenColor = Color(0xff024F59);
Color orangeColor = Color(0xffFFC400);
Color greyColor = Color(0xff000000).withOpacity(.2);

Color lightBlueColor = Color(0xff2BD9F0);

TextStyle alertDialogContentStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.5));
TextStyle alertDialogTitleStyle = TextStyle(fontSize: 20.0);
TextStyle recapInfo = TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold);
TextStyle subLogoTitleStyle =
    TextStyle(color: Color(0xff000000), fontSize: 33.0);
TextStyle subLogoSubtitleStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.7), fontSize: 18.0);
TextStyle bottomTextStyle = TextStyle(color: Color(0xff000000), fontSize: 16.0);
TextStyle policiesTextStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.7), fontSize: 14.0);
BoxDecoration textFormFieldBoxDecoration = BoxDecoration(
    color: Color(0xff000000).withOpacity(.1),
    borderRadius: BorderRadius.all(Radius.circular(30.0)));
TextStyle versionStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.4), fontSize: 14);

TextStyle topCardDescriptionStyle =
    TextStyle(color: Color(0xff000000), fontSize: 15.0);
TextStyle topCardPercentStyle =
    TextStyle(color: Color(0xff000000), fontSize: 44.0);
TextStyle mainPartTitleStyle =
    TextStyle(color: Color(0xff000000), fontSize: 16.0);
TextStyle listCardItemTitleStyle =
    TextStyle(color: Color(0xff000000), fontSize: 25.0);

TextStyle listItemCardProductStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.55), fontSize: 15.0);

TextStyle listItemCardDateStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.3), fontSize: 14.0);

TextStyle listItemCardStateOrderedStyle =
    TextStyle(color: greenColor, fontSize: 16.0);

TextStyle listItemCardStateWaitingStyle =
    TextStyle(color: Colors.deepOrangeAccent, fontSize: 16.0);

TextStyle listItemCardStateCanceledStyle =
    TextStyle(color: redColor, fontSize: 16.0);

TextStyle shoppingMainPartTitleStyle =
    TextStyle(color: Color(0xff000000), fontSize: 25.0);
