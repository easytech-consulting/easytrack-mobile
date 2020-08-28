import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:flutter/material.dart';

import '../../styles/style.dart';

class WelcomPage extends StatefulWidget {
  @override
  _WelcomPageState createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: myHeight(context) / 4.3),
              Container(
                height: myHeight(context) / 5.0,
                child: Image.asset(
                  'img/Logo.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                height: myHeight(context) / 50,
              ),
              Center(
                child: Text(
                  'easytrack',
                  style: TextStyle(fontSize: myHeight(context) / 20),
                ),
              ),
              SizedBox(
                height: myHeight(context) / 50,
              ),
              Center(
                child: Text(
                  'La meilleure plateforme pour',
                  style: TextStyle(
                      color: Color(0xff000000).withOpacity(.7),
                      fontSize: myHeight(context) / 39),
                ),
              ),
              Center(
                child: Text(
                  'votre gestion de stock',
                  style: TextStyle(
                      color: Color(0xff000000).withOpacity(.7),
                      fontSize: myHeight(context) / 39),
                ),
              ),
              SizedBox(
                height: myHeight(context) / 11,
              ),
              InkWell(
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Container(
                  height: myHeight(context) / 13,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
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
                          'Demarrer',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: myHeight(context) / 47),
                        ),
                        Spacer(),
                        Icon(
                          AmazingIcon.arrow_drop_right_line,
                          color: Colors.white,
                          size: myHeight(context) / 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: myHeight(context) / 20),
              InkWell(
                  onTap: launchNDA,
                  child: Center(
                    child: Text(
                      'voir notre politique de confidentialite',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.7),
                          fontSize: myHeight(context) / 50),
                    ),
                  )),
              SizedBox(height: myHeight(context) / 10),
              Container(
                height: myHeight(context) / 30,
                child: Center(
                    child: Text('Version 1.0.0',
                        style: TextStyle(fontSize: myHeight(context) / 70))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
