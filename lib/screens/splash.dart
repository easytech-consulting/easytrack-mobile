/* import 'dart:async';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/company.dart';
import 'package:easytrack/models/user.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _userLogged;
  bool _login;
  bool _alreadyDone;

  @override
  void initState() {
    super.initState();
    _userLogged = userLogged();
    _login = false;
    _alreadyDone = false;
  }

  _redirection() async {
    if (!_alreadyDone) {
      _alreadyDone = true;

      if (_login) {
        userToken = await getUserToken();
        user = User.fromJson(await getUser());
        site = Site.fromJson(await getUserSite());
        userRole = await getUserRoles();
        company = Company.fromJson(await getUserSnack());
        Timer(
            Duration(seconds: 3),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _login ? MainPage(): LoginPage())));
      } else {
        await getFirstConnexion().then((res) {
          if (res) {
            Navigator.pushNamed(context, '/welcome');
          }
        });
      }
    }
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
              style: TextStyle(fontSize: screenSize(context).height / 70),
            )),
          ),
          body: FutureBuilder(
            future: _userLogged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                _login = snapshot.data;
                _redirection();
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('img/Logo.png',
                        width: screenSize(context).height / 5),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Text(
                      'easytrack',
                      style:
                          TextStyle(fontSize: screenSize(context).height / 20),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Text(
                      'Bienvenue...',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.7),
                          fontSize: screenSize(context).height / 39),
                    ),
                    SizedBox(height: 20.0)
                  ],
                ),
              );
            },
          )),
    );
  }
}
 */