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
              SizedBox(height: MediaQuery.of(context).size.height / 4.3),
              Image.asset(
                'img/Logo.png',
                scale: 3.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text(
                'easytrack',
                style: subLogoTitleStyle,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text(
                'La meilleure plateforme pour',
                style: subLogoSubtitleStyle,
              ),
              Text(
                'votre gestion de stock',
                style: subLogoSubtitleStyle,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 11,
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Container(
                  height: 55.0,
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
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        Spacer(),
                        Icon(/* 
                          AmazingIcon.arrow_right_icon, */
                          Icons.arrow_forward_ios,
                          size: 11.0,
                          color: Colors.white,
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
                      color: Color(0xff000000).withOpacity(.7), fontSize: 14.0),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 30.0,
                child: Center(
                    child: Text(
                  'Version 1.0.0',
                  style: versionStyle,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
