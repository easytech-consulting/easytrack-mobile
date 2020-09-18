import 'dart:ui';
import 'package:flutter/material.dart';

ThemeData appTheme =
    ThemeData(primaryColor: Colors.white, fontFamily: 'Roboto');

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
TextStyle subLogoTitleStyle =
    TextStyle(color: Color(0xff000000), fontSize: 33.0);
TextStyle subLogoSubtitleStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.7), fontSize: 18.0);
TextStyle bottomTextStyle = TextStyle(color: Color(0xff000000), fontSize: 16.0);
TextStyle versionStyle =
    TextStyle(color: Color(0xff000000).withOpacity(.4), fontSize: 14);

TextStyle mainPartTitleStyle =
    TextStyle(color: Color(0xff000000), fontSize: 16.0);

buildTextFormFieldContainer(Color color) {
  return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(30.0)));
}
