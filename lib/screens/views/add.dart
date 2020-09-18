import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/views/general.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .9,
          height: MediaQuery.of(context).size.height * .8,
          decoration: BoxDecoration(
              color: textSameModeColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [BoxShadow(blurRadius: 100, offset: Offset(0, 0))]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Ajouter',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(AmazingIcon.close_line)),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 45.0,
                      decoration: buildTextFormFieldContainer(decorationColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: Text(''),
                        icon: Icon(AmazingIcon.arrow_down_s_line,
                            color: textInverseModeColor),
                        items: [],
                        onChanged: (value) {},
                        hint: Text('Selectionner un produit'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 90.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: textInverseModeColor.withOpacity(.12))),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Booster',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text('800 FCFA')
                              ],
                            ),
                            Container(
                              height: 35.0,
                              child: VerticalDivider(
                                thickness: 2.0,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.remove),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    '2',
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(Icons.add),
                                ],
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                  text: 'SOUS TOTAL',
                                  style: TextStyle(
                                      color: textInverseModeColor, fontSize: 11.0),
                                  children: [
                                    TextSpan(
                                      text: '  1,600 FCFA',
                                      style: TextStyle(
                                          color: textInverseModeColor, fontSize: 14.0),
                                    ),
                                  ]),
                            ),
                            Spacer(),
                            Text(
                              'SUPPRIMER',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 16.0),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RichText(
                    text: TextSpan(
                        text: 'REDUCTION',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: textInverseModeColor,
                            wordSpacing: 3.0),
                        children: [
                      TextSpan(
                          text: '  1,600 FCFA',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, wordSpacing: 0.0)),
                      TextSpan(text: '   SOUS TOTAL'),
                      TextSpan(
                          text: '  1,600 FCFA',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, wordSpacing: 0.0)),
                      TextSpan(text: '   TAX'),
                      TextSpan(
                          text: '  1,600 FCFA',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, wordSpacing: 0.0)),
                      TextSpan(text: '   COUPON'),
                      TextSpan(
                          text: '  1,600 FCFA',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, wordSpacing: 0.0))
                    ])),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('TOTAL:', style: TextStyle(fontSize: 11.5)),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('1,600 FCFA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => General())),
                  child: Container(
                    width: double.infinity,
                    height: 40.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [gradient1, gradient2]),
                        borderRadius: BorderRadius.circular(40.0)),
                    child: Text(
                      'Enregistrer',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: textSameModeColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
