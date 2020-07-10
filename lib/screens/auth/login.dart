import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/userService.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginController;
  TextEditingController _passwordController;

  FocusNode _loginNode;
  FocusNode _passwordNode;

  bool _isLoading;
  var _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _isLoading = false;

    _loginNode = new FocusNode();
    _passwordNode = new FocusNode();

    _loginController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _connectionAttempt() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> params = Map<String, dynamic>();
      params['login'] = _loginController.text;
      params['password'] = _passwordController.text;

      await login(params).then((success) async {
        if (success) {
          await fetchUserDetails(userId).then((user) {
            if (user != null) {
              Navigator.pushNamed(context, '/home');
            } else {
              _retrieveUserDataError();
            }
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          _showErrorMessage();
        }
      });
    }
  }

  _showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                  height: screenSize(context).height / 2.5,
                  child: errorStatusCode == 401
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            errorAlertIcon(context),
                            SizedBox(
                              height: screenSize(context).height / 40,
                            ),
                            Text(
                              'Erreur d\'authentification',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: screenSize(context).width / 22),
                            ),
                            SizedBox(height: screenSize(context).height / 80),
                            Text(
                              'Desole, nous n\'avons pas pu vous',
                              style: TextStyle(
                                  color: Color(0xff000000).withOpacity(.5),
                                  fontSize: screenSize(context).width / 25),
                            ),
                            Text(
                              'identifier. Votre nom d\'utilisateur',
                              style: TextStyle(
                                  color: Color(0xff000000).withOpacity(.5),
                                  fontSize: screenSize(context).width / 25),
                            ),
                            Text(
                              'ou mot de passe est incorrecte.',
                              style: TextStyle(
                                  color: Color(0xff000000).withOpacity(.5),
                                  fontSize: screenSize(context).width / 25),
                            ),
                            SizedBox(
                              height: screenSize(context).height / 40,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    borderSide:
                                        BorderSide(color: Color(0xff000000)),
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
                        )
                      : errorStatusCode == 404
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                errorAlertIcon(context),
                                SizedBox(
                                  height: screenSize(context).height / 40,
                                ),
                                Text(
                                  'Erreur d\'authentification',
                                  style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: screenSize(context).width / 22),
                                ),
                                SizedBox(
                                    height: screenSize(context).height / 80),
                                Text(
                                  'Desole, nous n\'avons pas pu vous',
                                  style: TextStyle(
                                      color: Color(0xff000000).withOpacity(.5),
                                      fontSize: screenSize(context).width / 25),
                                ),
                                Text(
                                  'identifier. Votre nom d\'utilisateur',
                                  style: TextStyle(
                                      color: Color(0xff000000).withOpacity(.5),
                                      fontSize: screenSize(context).width / 25),
                                ),
                                Text(
                                  'n\'existe pas dans notre base.',
                                  style: TextStyle(
                                      color: Color(0xff000000).withOpacity(.5),
                                      fontSize: screenSize(context).width / 25),
                                ),
                                SizedBox(
                                  height: screenSize(context).height / 40,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: OutlineButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0))),
                                        borderSide: BorderSide(
                                            color: Color(0xff000000)),
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
                            )
                          : errorStatusCode == 500
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    errorAlertIcon(context),
                                    SizedBox(
                                      height: screenSize(context).height / 40,
                                    ),
                                    Text(
                                      'Erreur de serveur',
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontSize:
                                              screenSize(context).width / 22),
                                    ),
                                    SizedBox(
                                        height:
                                            screenSize(context).height / 80),
                                    Text(
                                      'Desole, nous n\'avons pas pu vous',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.5),
                                          fontSize:
                                              screenSize(context).width / 25),
                                    ),
                                    Text(
                                      'identifier car Notre serveur est',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.5),
                                          fontSize:
                                              screenSize(context).width / 25),
                                    ),
                                    Text(
                                      'indisponible pour l\'instant',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.5),
                                          fontSize:
                                              screenSize(context).width / 25),
                                    ),
                                    SizedBox(
                                      height: screenSize(context).height / 40,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: OutlineButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0))),
                                            borderSide: BorderSide(
                                                color: Color(0xff000000)),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Container(
                                                alignment: Alignment.center,
                                                height: 40.0,
                                                child: Text('Fermer')),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    errorAlertIcon(context),
                                    SizedBox(
                                      height: screenSize(context).height / 40,
                                    ),
                                    Text(
                                      'Erreur de connectivite',
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontSize:
                                              screenSize(context).width / 22),
                                    ),
                                    SizedBox(
                                        height:
                                            screenSize(context).height / 80),
                                    Text(
                                      'Desole, nous n\'avons pas pu vous',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.5),
                                          fontSize:
                                              screenSize(context).width / 25),
                                    ),
                                    Text(
                                      'identifier. Verifier votre acces',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.5),
                                          fontSize:
                                              screenSize(context).width / 25),
                                    ),
                                    Text(
                                      'internet.',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.5),
                                          fontSize:
                                              screenSize(context).width / 25),
                                    ),
                                    SizedBox(
                                      height: screenSize(context).height / 40,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: OutlineButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0))),
                                            borderSide: BorderSide(
                                                color: Color(0xff000000)),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Container(
                                                alignment: Alignment.center,
                                                height: 40.0,
                                                child: Text('Fermer')),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
            ));
  }

  _retrieveUserDataError() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                  height: screenSize(context).height / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      errorAlertIcon(context),
                      SizedBox(
                        height: screenSize(context).height / 40,
                      ),
                      Text(
                        'Erreur d\'authentification',
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: screenSize(context).width / 22),
                      ),
                      SizedBox(height: screenSize(context).height / 80),
                      Text(
                        'Desole, nous n\'avons pas pu vous',
                        style: TextStyle(
                            color: Color(0xff000000).withOpacity(.5),
                            fontSize: screenSize(context).width / 25),
                      ),
                      Text(
                        'recuperer toutes vos informations',
                        style: TextStyle(
                            color: Color(0xff000000).withOpacity(.5),
                            fontSize: screenSize(context).width / 25),
                      ),
                      Text(
                        'veuillez reessayer plus tard.',
                        style: TextStyle(
                            color: Color(0xff000000).withOpacity(.5),
                            fontSize: screenSize(context).width / 25),
                      ),
                      SizedBox(
                        height: screenSize(context).height / 40,
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
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      height: screenSize(context).height,
                      width: screenSize(context).width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: screenSize(context).height / 15.0,
                          ),
                          Image.asset(
                            'img/Logo.png',
                            width: screenSize(context).height / 13,
                          ),
                          SizedBox(
                            height: screenSize(context).height / 30.0,
                          ),
                          Text('Connexion',
                              style: TextStyle(
                                  fontSize: screenSize(context).height / 20)),
                          SizedBox(height: screenSize(context).height / 80.0),
                          Text(
                            'Authentifiez-vous pour acceder',
                            style: TextStyle(
                                color: Color(0xff000000).withOpacity(.7),
                                fontSize: screenSize(context).height / 39),
                          ),
                          Text(
                            'a la plate-forme',
                            style: TextStyle(
                                color: Color(0xff000000).withOpacity(.7),
                                fontSize: screenSize(context).height / 39),
                          ),
                          SizedBox(
                            height: screenSize(context).height / 18,
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
                                  onFieldSubmitted: (_) => nextNode(
                                      context, _loginNode, _passwordNode),
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
                                      prefixIcon: Icon(AmazingIcon.user_6_line,
                                          color: Color(0xff000000), size: 15.0),
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
                            height: screenSize(context).height / 31.0,
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
                                          AmazingIcon.lock_password_line,
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
                            height: screenSize(context).height / 31.0,
                          ),
                          InkWell(
                            onTap: () => _connectionAttempt(),
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
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 0.0, 10.0, 10.0),
                            child: Container(
                              height: screenSize(context).height / 10,
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/register'),
                                    child: Container(
                                        child: Text('Inscription',
                                            style: TextStyle(
                                                fontSize:
                                                    screenSize(context).height /
                                                        43))),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/recover'),
                                    child: Text('Mot de passe oublie',
                                        style: TextStyle(
                                            fontSize:
                                                screenSize(context).height /
                                                    43)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            _isLoading
                ? Container(
                    width: screenSize(context).width,
                    height: screenSize(context).height,
                    color: Color(0xffffffff).withOpacity(.89),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(gradient1),
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
