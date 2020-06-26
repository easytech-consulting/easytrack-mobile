import 'package:flutter/material.dart';

import '../../styles/style.dart';

class ResponsePasswordReset extends StatefulWidget {
  @override
  _ResponsePasswordResetState createState() => _ResponsePasswordResetState();
}

class _ResponsePasswordResetState extends State<ResponsePasswordReset> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 30.0,
          child: Center(
              child: Text(
            'Version 1.0.0',
            style: TextStyle(
                color: Color(0xff000000).withOpacity(.4), fontSize: 14),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'img/Logo.png',
                  scale: 3.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  'Termine',
                  style: subLogoTitleStyle,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  'Votre mot de passe a ete',
                  style: subLogoSubtitleStyle,
                ),
                Text(
                  'reinitialise avec succes',
                  style: subLogoSubtitleStyle,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Container(
                    height: 55.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        gradient: LinearGradient(
                            colors: [gradient1, gradient2],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Connectez-vous',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          Spacer(),
                          Icon(
                            /* 
                            AmazingIcon.arrow_right_icon, */
                            Icons.arrow_forward_ios,
                            size: 11.0,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
