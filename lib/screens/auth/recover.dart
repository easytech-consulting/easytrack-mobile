import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/screens/auth/waiting.dart';
import 'package:flutter/material.dart';
import '../../styles/style.dart';

class RecoverPage extends StatefulWidget {
  @override
  _RecoverPageState createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  openSuccessBoxDialog() {
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
                    successAlertIcon(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Envoie reussie',
                      style: alertDialogTitleStyle,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      'Nous vous avons envoye un mail',
                      style: alertDialogContentStyle,
                    ),
                    Text('pour la reinitialisation de votre',
                        style: alertDialogContentStyle),
                    Text(
                      'mot de passe',
                      style: alertDialogContentStyle,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WaitingResetPassword())),
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
                                'Ouvrir ma boite mail',
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
                      Icon(
                          /* AmazingIcon.arrow_left_solid_icon */ Icons
                              .arrow_back,
                          size: 13),
                      SizedBox(width: 10.0),
                      Text('Retour', style: bottomTextStyle),
                    ],
                  )),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Text('J\'ai deja un compte', style: bottomTextStyle),
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
                      height: MediaQuery.of(context).size.height / 10.0,
                    ),
                    Image.asset(
                      'img/Logo.png',
                      scale: 7.0,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20.0,
                    ),
                    Text(
                      'Mot de passe',
                      style: subLogoTitleStyle,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Saisissez votre adresse electronique',
                      style: subLogoSubtitleStyle,
                    ),
                    Text(
                      'et nous vous enverrons un lien',
                      style: subLogoSubtitleStyle,
                    ),
                    Text(
                      'pour le reinitialiser.',
                      style: subLogoSubtitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                              height: 48.0,
                              decoration: textFormFieldBoxDecoration),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextFormField(
                            controller: _emailController,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.isEmpty) return 'Champs obligatoire';
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                prefixIcon: Icon(
                                    /* AmazingIcon.account_icon */ Icons
                                        .account_box,
                                    color: Color(0xff000000),
                                    size: 17.0),
                                hintText: 'Votre email',
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
                      height: MediaQuery.of(context).size.height / 35.0,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          openSuccessBoxDialog();
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Envoyer',
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
