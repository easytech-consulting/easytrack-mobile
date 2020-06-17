import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/auth/waiting.dart';
import 'package:flutter/material.dart';

class RecoverPage extends StatefulWidget {
  @override
  _RecoverPageState createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  TextEditingController _emailController = TextEditingController();
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
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Text('J\'ai deja un compte',
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
                      height: MediaQuery.of(context).size.height / 30.0,
                    ),
                    Image.asset('img/logo.png'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 23.0,
                    ),
                    Text(
                      'Mot de passe',
                      style:
                          TextStyle(color: Color(0xff000000), fontSize: 33.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Remplissez le formulaire ci-dessous pour',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.7),
                          fontSize: 18.0),
                    ),
                    Text(
                      'reinitialiser votre mot de passe',
                      style: TextStyle(
                          color: Color(0xff000000).withOpacity(.7),
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 8.5,
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
                            controller: _emailController,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Veuillez renseigner votre adresse mail';
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                prefixIcon: Icon(Icons.account_circle,
                                    color: Color(0xff000000), size: 17.0),
                                hintText: 'Email',
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WaitingResetPassword()));
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
