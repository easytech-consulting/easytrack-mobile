import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/screens/views/add.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class ProductPage2 extends StatefulWidget {
  @override
  _ProductPage2State createState() => _ProductPage2State();
}

class _ProductPage2State extends State<ProductPage2> {
  bool selectionMode = false;
  bool selectedItem = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  showSnackBar(GlobalKey<ScaffoldState> _key) {
    _key.currentState.showSnackBar(SnackBar(
      content: GestureDetector(
          onTap: () {
            _key.currentState.hideCurrentSnackBar();
            setState(() {
              selectedItem = false;
              selectionMode = true;
            });
          },
          child: Text('Selection')),
    ));
  }

  _cancelMode(GlobalKey<ScaffoldState> _key) {
    setState(() {
      selectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              top: true,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              height: 48.0,
                              decoration: textFormFieldBoxDecoration,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 48.0,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                style: TextStyle(color: Color(0xffffffff)),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    suffixIcon: Icon(
                                      AmazingIcon.close_fill,
                                    ),
                                    hintText: 'Recherche...',
                                    prefixIcon: Icon(AmazingIcon.search_2_line),
                                    hintStyle: TextStyle(
                                        color:
                                            Color(0xff000000).withOpacity(.35),
                                        fontSize: 18.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Add())),
                        child: Icon(
                          AmazingIcon.arrow_down_s_line,
                          size: 40,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.brightness_1,
                    color: Colors.green,
                    size: 26,
                  ),
                  SizedBox(
                    width: 10.9,
                  ),
                  Text(
                    'Paye',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Icon(Icons.add),
                  SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        selectionMode
                            ? _cancelMode(_scaffoldKey)
                            : showSnackBar(_scaffoldKey);
                      },
                      child: Icon(AmazingIcon.list_settings_fill)),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: screenSize(context).height / 5.8,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AnimatedContainer(
                      curve: Curves.bounceInOut,
                      duration: Duration(seconds: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'S0-1301',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                Spacer(),
                                Icon(Icons.more_vert),
                              ],
                            ),
                            Text(
                              '3x Booster 2x Guiness',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17.0),
                            ),
                            Spacer(),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 50.0,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'AG',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        transform:
                                            Matrix4.translationValues(23, 0, 0),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'JM',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        transform:
                                            Matrix4.translationValues(46, 0, 0),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '+3',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Total'),
                                      Text(
                                        '3500 FCFA',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    selectionMode
                        ? AnimatedContainer(
                            curve: Curves.bounceInOut,
                            duration: Duration(seconds: 4),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(.9),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedItem = !selectedItem;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                              color: selectedItem
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Icon(
                                            Icons.check,
                                            color: selectedItem
                                                ? Colors.blueGrey
                                                : Colors.transparent,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Selectionner',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        : Container(
                            height: 0.0,
                          )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 10.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.brightness_1,
                    size: 12.0,
                    color: Colors.black26,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.brightness_1,
                    size: 12.0,
                    color: Colors.black26,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
