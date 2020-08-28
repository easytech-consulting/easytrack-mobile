import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget otherHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'img/logos/LogoWithText.png',
          width: myHeight(context) / 6.0,
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: myHeight(context) / 50.0),
          child: Icon(AmazingIcon.search_2_line),
        ),
        Container(
          width: myWidth(context) / 7.5,
          height: myWidth(context) / 7.5,
          alignment: Alignment.center,
          child: Container(
            decoration:
                BoxDecoration(color: Colors.black12, shape: BoxShape.circle),
            child: Padding(
              padding: EdgeInsets.all(myHeight(context) / 50.0),
              child: Text(
                '${user.name.substring(0, 2).toUpperCase()}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: myHeight(context) / 50.0),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
