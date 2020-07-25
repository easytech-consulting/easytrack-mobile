import 'package:easytrack/commons/globals.dart';
import 'package:flutter/material.dart';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les Snacks',
          style: TextStyle(
              fontSize: screenSize(context).height / 35.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(child: Text('Non implemeter')),
    );
  }
}
