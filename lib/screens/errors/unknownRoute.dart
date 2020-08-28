import 'package:flutter/material.dart';

class UnknownRoute extends StatefulWidget {
  @override
  _UnknownRouteState createState() => _UnknownRouteState();
}

class _UnknownRouteState extends State<UnknownRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Route inconnue mon ami(e)'),),
    );
  }
}