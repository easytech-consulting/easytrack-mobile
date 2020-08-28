import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/screens/auth/login.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;

  _logoutUser() async {
    setState(() {
      _isLoading = true;
    });
    await logout().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SafeArea(
                  top: true,
                  child:
                      Center(child: Text('Tableau de bord mobile easytech'))),
              OutlineButton(
                onPressed: () => _logoutUser(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                child: Text('Retour',
                    style: TextStyle(
                      color: Colors.red,
                    )),
              )
            ],
          ),
          _isLoading
              ? Container(
                  width: screenSize(context).width,
                  height: screenSize(context).height,
                  color: Color(0xffffffff).withOpacity(.89),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(gradient1),
                    ),
                  ))
              : Container(),
        ],
      ),
    ));
  }
}
