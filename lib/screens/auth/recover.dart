import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/services/authService.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';

class RecoverPage extends StatefulWidget {
  @override
  _RecoverPageState createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  TextEditingController _fieldController;
  var _formKey;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _fieldController = TextEditingController();
    _isLoading = false;
  }

  _recoverPassword() async {
    Map<String, dynamic> params = Map();
    params['login'] = _fieldController.text;

    await recover(params).then((success) {
      if (success) {
        _openSuccessBoxDialog();
      } else {
        setState(() {
          _isLoading = false;
        });

        _showErrorMessage();
      }
    });
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
                              'Erreur de donnees',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: screenSize(context).width / 22),
                            ),
                            SizedBox(height: screenSize(context).height / 80),
                            Text(
                              'Desole, nous n\'avons pas pu',
                              style: TextStyle(
                                  color: Color(0xff000000).withOpacity(.5),
                                  fontSize: screenSize(context).width / 25),
                            ),
                            Text(
                              'reinitialiser votre mot de passe car',
                              style: TextStyle(
                                  color: Color(0xff000000).withOpacity(.5),
                                  fontSize: screenSize(context).width / 25),
                            ),
                            Text(
                              'cet utilisateur n\'existe pas',
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
                                      fontSize: screenSize(context).width / 22),
                                ),
                                SizedBox(
                                    height: screenSize(context).height / 80),
                                Text(
                                  'Desole, nous ne pouvons pas traiter',
                                  style: TextStyle(
                                      color: Color(0xff000000).withOpacity(.5),
                                      fontSize: screenSize(context).width / 25),
                                ),
                                Text(
                                  'votre demande pour le moment car',
                                  style: TextStyle(
                                      color: Color(0xff000000).withOpacity(.5),
                                      fontSize: screenSize(context).width / 25),
                                ),
                                Text(
                                  'notre serveur est indisponible',
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
                                      fontSize: screenSize(context).width / 22),
                                ),
                                SizedBox(
                                    height: screenSize(context).height / 80),
                                Text(
                                  'Desole, nous ne pouvons pas reinitialiser',
                                  style: TextStyle(
                                      color: Color(0xff000000).withOpacity(.5),
                                      fontSize: screenSize(context).width / 25),
                                ),
                                Text(
                                  'pour le moment. Verifier votre acces',
                                  style: TextStyle(
                                      color: Color(0xff000000).withOpacity(.5),
                                      fontSize: screenSize(context).width / 25),
                                ),
                                Text(
                                  'a internet puis reessayer.',
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
                            )),
            ));
  }

  _openSuccessBoxDialog() {
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
                    successAlertIcon(context),
                    SizedBox(
                      height: screenSize(context).height / 40,
                    ),
                    Text(
                      'Envoie reussie',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: screenSize(context).width / 22),
                    ),
                    SizedBox(
                      height: screenSize(context).height / 80,
                    ),
                    Text(
                      'Nous vous avons envoye un message',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.5),
                          fontSize: screenSize(context).width / 25),
                    ),
                    Text('dans lequel vous trouverez votre',
                        style: TextStyle(
                            color: Color(0xff000000).withOpacity(.5),
                            fontSize: screenSize(context).width / 25)),
                    Text(
                      'nouveau mot de passe',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.5),
                          fontSize: screenSize(context).width / 25),
                    ),
                    SizedBox(
                      height: screenSize(context).height / 80,
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/login'),
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
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      width: screenSize(context).width,
                      height: screenSize(context).height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: screenSize(context).height / 10.0,
                          ),
                          Image.asset(
                            'img/Logo.png',
                            scale: screenSize(context).height / 90,
                          ),
                          SizedBox(
                            height: screenSize(context).height / 30.0,
                          ),
                          Text(
                            'Mot de passe',
                            style: TextStyle(
                                fontSize: screenSize(context).height / 20),
                          ),
                          SizedBox(height: screenSize(context).height / 80.0),
                          Text(
                            'Saisissez votre adresse electronique',
                            style: TextStyle(
                                color: Color(0xff000000).withOpacity(.7),
                                fontSize: screenSize(context).height / 39),
                          ),
                          Text(
                            'et nous vous enverrons un lien',
                            style: TextStyle(
                                color: Color(0xff000000).withOpacity(.7),
                                fontSize: screenSize(context).height / 39),
                          ),
                          Text(
                            'pour le reinitialiser.',
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
                                    decoration: buildTextFormFieldContainer(
                                        decorationColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  controller: _fieldController,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Champs obligatoire';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 50.0),
                                      prefixIcon: Icon(
                                          AmazingIcon.account_circle_line,
                                          color: Color(0xff000000),
                                          size: 17.0),
                                      hintText: 'telephone, login, email',
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
                            height: screenSize(context).height / 35.0,
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _recoverPassword();
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
                                      'Envoyer',
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontSize: 18),
                                    ),
                                  ),
                                )),
                          ),
                          Spacer(),
                          Container(
                            height: 70.0,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 20.0),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                        child: Row(
                                      children: <Widget>[
                                        Icon(AmazingIcon.arrow_left_line,
                                            size: 13),
                                        SizedBox(width: 10.0),
                                        Text('Retour', style: bottomTextStyle),
                                      ],
                                    )),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/login'),
                                    child: Text('J\'ai deja un compte',
                                        style: bottomTextStyle),
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
