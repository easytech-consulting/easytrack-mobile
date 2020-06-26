import 'package:flutter/material.dart';

import '../styles/style.dart';

Widget successAlertIcon() {
  return Container(
    width: 100.0,
    height: 100.0,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: lightBlueColor.withOpacity(.1),
        borderRadius: BorderRadius.all(Radius.circular(50.0))),
    child: Icon(Icons.check, color: lightBlueColor, size: 42.21),
  );
}

Widget errorAlertIcon() {
  return Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        color: redColor.withOpacity(.1),
        borderRadius: BorderRadius.all(Radius.circular(50.0))),
    child: Icon(Icons.warning, color: redColor, size: 42.67),
  );
}
