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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenSize(context).height / 4.3),
              Image.asset(
                'img/Logo.png',
                width: screenSize(context).height / 5,
              ),
              SizedBox(
                height: screenSize(context).height / 50,
              ),
              Text(
                'easytrack',
                style: TextStyle(fontSize: screenSize(context).height / 20),
              ),
              SizedBox(
                height: screenSize(context).height / 50,
              ),
              Text(
                'La meilleure plateforme pour',
                style: TextStyle(
                    color: Color(0xff000000).withOpacity(.7),
                    fontSize: screenSize(context).height / 39),
              ),
              Text(
                'votre gestion de stock',
                style: TextStyle(
                    color: Color(0xff000000).withOpacity(.7),
                    fontSize: screenSize(context).height / 39),
              ),
              SizedBox(
                height: screenSize(context).height / 11,
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Container(
                  height: screenSize(context).height / 13,
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
                              fontSize: screenSize(context).height / 47),
                        ),
                        Spacer(),
                        Icon(
                          AmazingIcon.arrow_drop_right_line,
                          color: Colors.white,
                          size: screenSize(context).height / 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: launchNDA,
                  child: Text(
                    'voir notre politique de confidentialite',
                    style: TextStyle(
                        color: Color(0xff000000).withOpacity(.7),
                        fontSize: screenSize(context).height / 50),
                  )),
              SizedBox(height: screenSize(context).height / 20),
              Container(
                height: screenSize(context).height / 30,
                child: Center(
                    child: Text('Version 1.0.0',
                        style: TextStyle(
                            fontSize: screenSize(context).height / 70))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
