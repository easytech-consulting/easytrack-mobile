import 'dart:async';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';
import 'response.dart';

class RecoverNewValuePage extends StatefulWidget {
  @override
  _RecoverNewValuePageState createState() => _RecoverNewValuePageState();
}

class _RecoverNewValuePageState extends State<RecoverNewValuePage> {
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _cPasswordController = new TextEditingController();

  FocusNode _passwordNode = new FocusNode();
  FocusNode _cPasswordNode = new FocusNode();

  bool isLoading = false;
  bool isError = true;

  void showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                height: 256.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    errorAlertIcon(context),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Erreur de validation',
                      style: alertDialogTitleStyle,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      'Les deux mots de',
                      style: alertDialogContentStyle,
                    ),
                    Text(
                      'passe ne coincident pas',
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
                            borderSide: BorderSide(color: Colors.black),
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

  void finalisationRecoverRedirection() {
    new Timer(
        Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ResponsePasswordReset())));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
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
                          Text(
                            'Reinitialisation',
                            style: subLogoTitleStyle,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height / 80.0),
                          Text('Entrez votre nouveau',
                              style: subLogoSubtitleStyle),
                          Text(
                            'mot de passe',
                            style: subLogoSubtitleStyle,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 11,
                          ),
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 48.0,
                                decoration: textFormFieldBoxDecoration,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  controller: _passwordController,
                                  focusNode: _passwordNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    _passwordNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_cPasswordNode);
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
                                          AmazingIcon.lock_password_line,
                                          color: Color(0xff000000),
                                          size: 15.0),
                                      hintText: 'Mot de passe',
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
                              Container(
                                height: 48.0,
                                decoration: textFormFieldBoxDecoration,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: _cPasswordController,
                                  focusNode: _cPasswordNode,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) {
                                    _cPasswordNode.unfocus();
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
                                          AmazingIcon.lock_password_line,
                                          color: Color(0xff000000),
                                          size: 15.0),
                                      hintText: 'Ressaisissez le mot de passe',
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
                                if (_cPasswordController.text !=
                                    _passwordController.text) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showErrorMessage();
                                } else {
                                  finalisationRecoverRedirection();
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
                                      colors: [gradient1, gradient2]),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: Text(
                                      'Confirmer',
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
                                  vertical: 40.0, horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  'Version 1.0.0',
                                  style: versionStyle,
                                ),
                              )),
                        ],
                      ),
                    ),
                    isLoading
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Color(0xffffffff).withOpacity(.8),
                            child: Center(
                              child: CircularProgressIndicator(),
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
