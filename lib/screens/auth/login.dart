import 'package:easytrack/icons/amazingIcon.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  FocusNode _loginNode = new FocusNode();
  FocusNode _passwordNode = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 70.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      child: Row(
                    children: <Widget>[
                      Icon(AmazingIcon.arrow_left_solid_icon, size: 13),
                      SizedBox(width: 10.0),
                      Text('Retour',
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 16.0))
                    ],
                  )),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/recover'),
                  child: Text('Mot de passe oublie',
                      style:
                          TextStyle(color: Color(0xff000000), fontSize: 16.0)),
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                      'Connexion',
                      style:
                          TextStyle(color: Color(0xff000000), fontSize: 33.0),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 80.0),
                    Text(
                      'Authentification pour acces',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.7),
                          fontSize: 18.0),
                    ),
                    Text(
                      'a la plate-forme',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.7),
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 11,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                              color: Color(0xff000000).withOpacity(.06),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
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
                                return 'Veuilez renseigner le nom d\'utilisateur';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                prefixIcon: Icon(AmazingIcon.user_icon,
                                    color: Color(0xff000000), size: 15.0),
                                hintText: 'Nom d\'utilisateur',
                                hintStyle: TextStyle(
                                    color: Color(0xff000000).withOpacity(.35),
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
                          decoration: BoxDecoration(
                              color: Color(0xff000000).withOpacity(.06),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
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
                                return 'Veuillez renseignez le mot de passe';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                prefixIcon: Icon(AmazingIcon.password_icon,
                                    color: Color(0xff000000), size: 15.0),
                                hintText: 'Mot de passe',
                                fillColor: Colors.black,
                                hintStyle: TextStyle(
                                    color: Color(0xff000000).withOpacity(.35),
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
                          Navigator.pushNamed(context, '/home');
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
                                colors: [
                                  Color(0xfff267FC9),
                                  Color(0xff26B1C3)
                                ]),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                    color: Color(0xffffffff), fontSize: 18),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
