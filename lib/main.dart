import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/screens/auth/recover.dart';
import 'package:easytrack/screens/auth/register.dart';
import 'package:easytrack/screens/errors/unknownRoute.dart';
import 'package:easytrack/screens/home/home.dart';
import 'package:easytrack/screens/splash.dart';
import 'package:easytrack/screens/welcome/welcomePage.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easytrack',
      theme: appTheme,
      initialRoute: '/welcome',
      onUnknownRoute: (context) =>
          MaterialPageRoute(builder: (context) => UnknownRoute()),
      routes: {
        '/': (context) => SplashPage(),
        '/welcome': (context) => WelcomPage(),
        '/login': (context) => LoginPage(),
        '/recover': (context) => RecoverPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => MainPage(),
      },
    );
  }
}
