import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:flutter/material.dart';

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
        bottomNavigationBar: Container(
          height: 30.0,
          child: Center(
              child: Text(
            'Version 1.0.0',
            style: TextStyle(
                color: Color(0xff000000).withOpacity(.4), fontSize: 14),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 4.3),
              Image.asset(
                'img/logo.png',
                scale: .75,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text(
                'Easytrack',
                style: TextStyle(color: Color(0xff2681C9), fontSize: 40.0),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Text(
                'La meilleure plateforme pour',
                style: TextStyle(color: Color(0xff000000), fontSize: 17.0),
              ),
              Text(
                'votre gestion de stock',
                style: TextStyle(color: Color(0xff000000), fontSize: 17.0),
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
                          colors: [Color(0xff267EC9), Color(0xff26B1C3)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Demarrer',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        Spacer(),
                        Icon(
                          AmazingIcon.arrow_right_icon,
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
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}
