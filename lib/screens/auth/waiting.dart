import 'dart:async';

import 'package:easytrack/screens/auth/response.dart';
import 'package:flutter/material.dart';

class WaitingResetPassword extends StatefulWidget {
  @override
  _WaitingResetPasswordState createState() => _WaitingResetPasswordState();
}

class _WaitingResetPasswordState extends State<WaitingResetPassword> {
  @override
  void initState() {
    super.initState();
    _counter();
  }

  _counter() {
    Timer(
        Duration(seconds: 5),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ResponsePasswordReset())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 30.0,
          child: Center(
              child: Text(
            'Version 1.0.0',
            style: TextStyle(
                color: Color(0xff000000).withOpacity(.4), fontSize: 14),
          )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'img/logo.png',
                scale: .75,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text(
                'Reinitialisation',
                style: TextStyle(color: Color(0xff000000), fontSize: 33.0),
              ),
              Text(
                'du mot de passe',
                style: TextStyle(color: Color(0xff000000), fontSize: 33.0),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text(
                'Traitement en cours...',
                style: TextStyle(
                    color: Color(0xff000000).withOpacity(.7), fontSize: 14.0),
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}
