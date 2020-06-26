import 'dart:async';

import 'package:easytrack/commons/globals.dart';
import 'package:flutter/material.dart';

import '../../styles/style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  FocusNode _loginNode = new FocusNode();
  FocusNode _passwordNode = new FocusNode();

  bool isLoading = false;
  bool isError = true;

  void showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                height: 275.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    errorAlertIcon(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Erreur d\'authentification',
                      style: alertDialogTitleStyle,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      'Desole, nous n\'avons pas pu vous',
                      style: alertDialogContentStyle,
                    ),
                    Text(
                      'identifier. Votre nom d\'utilisateur',
                      style: alertDialogContentStyle,
                    ),
                    Text(
                      'ou mot de passe incorrecte.',
                      style: alertDialogContentStyle,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlineButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            borderSide: BorderSide(color: Color(0xff000000)),
                            onPressed: () => Navigator.pop(context),
                            child: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                child: Text('Fermer')),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  void homeRedirection() {
    new Timer(
        Duration(seconds: 3), () => Navigator.pushNamed(context, '/home'));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 15.0,
                          ),
                          Image.asset(
                            'img/Logo.png',
                            scale: 7.0,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 25.0,
                          ),
                          Text('Connexion', style: subLogoTitleStyle),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height / 80.0),
                          Text(
                            'Authentification pour acces',
                            style: subLogoSubtitleStyle,
                          ),
                          Text(
                            'a la plate-forme',
                            style: subLogoSubtitleStyle,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 11,
                          ),
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 48.0,
                                  decoration: textFormFieldBoxDecoration,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  controller: _loginController,
                                  focusNode: _loginNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    _loginNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_passwordNode);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Champs obligatoire';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 50.0),
                                      prefixIcon: Icon(
                                          /* AmazingIcon.user_icon, */ Icons
                                              .account_circle,
                                          color: Color(0xff000000),
                                          size: 15.0),
                                      hintText: 'Nom d\'utilisateur',
                                      hintStyle: TextStyle(
                                          color: Color(0xff000000)
                                              .withOpacity(.35),
                                          fontSize: 18.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 31.0,
                          ),
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.5),
                                child: Container(
                                    height: 48.0,
                                    decoration: textFormFieldBoxDecoration),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  focusNode: _passwordNode,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) {
                                    _passwordNode.unfocus();
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Champs obligatoire';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 50.0),
                                      prefixIcon: Icon(
                                          /* 
                                          AmazingIcon.password_icon, */
                                          Icons.security,
                                          color: Color(0xff000000),
                                          size: 15.0),
                                      hintText: 'Mot de passe',
                                      fillColor: Colors.black,
                                      hintStyle: TextStyle(
                                          color: Color(0xff000000)
                                              .withOpacity(.35),
                                          fontSize: 18.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      )),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 31.0,
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                if (isError &&
                                    (_loginController.text != 'yvan' ||
                                        _passwordController.text != 'yvan')) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showErrorMessage();
                                } else {
                                  homeRedirection();
                                }
                              }
                            },
                            child: Container(
                                height: 48.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [gradient1, gradient2])),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: Text(
                                      'Se connecter',
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontSize: 18),
                                    ),
                                  ),
                                )),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 10.0),
                            child: Container(
                              height: 70.0,
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                        child: Row(
                                      children: <Widget>[
                                        Icon(
                                            /* AmazingIcon.arrow_left_solid_icon */ Icons
                                                .arrow_back,
                                            size: 13),
                                        SizedBox(width: 10.0),
                                        Text('Retour', style: bottomTextStyle)
                                      ],
                                    )),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/recover'),
                                    child: Text('Mot de passe oublie',
                                        style: bottomTextStyle),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Color(0xffffffff).withOpacity(.89),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    gradient1),
                              ),
                            ))
                        : Container(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
