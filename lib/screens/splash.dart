import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/company.dart';
import 'package:easytrack/models/user.dart';
import 'package:easytrack/screens/errors/lostconnection.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _userLogged;
  bool _login;
  bool _alreadyDone;

  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LostConnection(),
            ));
      }
    });
    _userLogged = userLogged();
    _login = false;
    _alreadyDone = false;
    _fetchMode();
    oneSignalInitialisation();
  }

  _fetchMode() async {
    appThemeMode = await getThemeMode() ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      loadModeColor(appThemeMode);
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  _redirection() async {
    if (!_alreadyDone) {
      _alreadyDone = true;
      if (_login) {
        String tokenExpireDate = await getTokenExpireDate();
        bool tokenAlreadyValid =
            DateTime.now().isBefore(DateTime.parse(tokenExpireDate));

        print(tokenExpireDate);
        if (tokenAlreadyValid) {
          userToken = await getUserToken();
          user = User.fromJson(await getUser());
          userRole = await getUserRoles();
          if (user.isAdmin == 2) {
            company = Company.fromJson(await getUserSnack());
          }
          if (user.isAdmin == 1) {
            site = Site.fromJson(await getUserSite());
          }
          await logUserOnFirebase();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        } else {
          Navigator.pushNamed(context, '/login');
        }
      } else {
        await getFirstConnexion().then((res) {
          if (res) {
            Navigator.pushNamed(context, '/welcome');
          } else {
            Navigator.pushNamed(context, '/login');
          }
        });
      }
    }
  }

  _navigation() {
    _redirection();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: SafeArea(
        top: true,
        child: Scaffold(
            backgroundColor: backgroundColor,
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
                  _navigation();
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Image.asset('img/Logo.png',
                            width: screenSize(context).height / 5),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      Text(
                        'easytrack',
                        style: TextStyle(
                            color: textInverseModeColor,
                            fontSize: screenSize(context).height / 20),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
