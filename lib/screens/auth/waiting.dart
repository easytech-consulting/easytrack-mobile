import 'dart:async';
import 'package:easytrack/screens/auth/recoverNewValue.dart';
import 'package:flutter/material.dart';

import '../../styles/style.dart';

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
            MaterialPageRoute(builder: (context) => RecoverNewValuePage())));
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
            style: versionStyle,
          )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'img/Logo.png',
                scale: 3.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text(
                'Reinitialisation',
                style: subLogoTitleStyle,
              ),
              Text(
                'du mot de passe',
                style: subLogoTitleStyle,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text('Traitement en cours...', style: subLogoSubtitleStyle),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}
