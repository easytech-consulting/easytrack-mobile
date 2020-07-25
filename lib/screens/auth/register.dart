import 'dart:async';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/plan.dart';
import 'package:easytrack/services/authService.dart';
import 'package:easytrack/services/planService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading, _obscureText, _cObscureText;
  var _formKey;
  int _currentPage;
  Plan _selectedPlan;
  Future<List<Plan>> _plans;
  List<Plan> _listOfPlans;

  TextEditingController _usernameController;
  TextEditingController _useraddressController;
  TextEditingController _userphoneController;
  TextEditingController _useremailController;
  TextEditingController _userloginController;
  TextEditingController _userpasswordController;
  TextEditingController _usercPasswordController;
  TextEditingController _snacknameController;
  TextEditingController _snackemailController;
  TextEditingController _snacktownController;
  TextEditingController _snackstreetController;
  TextEditingController _snackphone1Controller;
  TextEditingController _snackphone2Controller;
  TextEditingController _siteemailController;
  TextEditingController _sitetownController;
  TextEditingController _sitestreetController;
  TextEditingController _sitephone1Controller;
  TextEditingController _sitephone2Controller;

  FocusNode _usernameNode;
  FocusNode _useraddressNode;
  FocusNode _userphoneNode;
  FocusNode _useremailNode;
  FocusNode _userloginNode;
  FocusNode _userpasswordNode;
  FocusNode _usercPasswordNode;
  FocusNode _snacknameNode;
  FocusNode _snackemailNode;
  FocusNode _snacktownNode;
  FocusNode _snackstreetNode;
  FocusNode _snackphone1Node;
  FocusNode _snackphone2Node;
  FocusNode _siteemailNode;
  FocusNode _sitetownNode;
  FocusNode _sitestreetNode;
  FocusNode _sitephone1Node;
  FocusNode _sitephone2Node;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _isLoading = false;
    _listOfPlans = [];
    _currentPage = 0;
    _obscureText = true;
    _cObscureText = true;
    _plans = fetchAllPlans();

    _usernameController = new TextEditingController();
    _useraddressController = new TextEditingController();
    _userphoneController = new TextEditingController();
    _useremailController = new TextEditingController();
    _userloginController = new TextEditingController();
    _userpasswordController = new TextEditingController();
    _usercPasswordController = new TextEditingController();
    _snacknameController = new TextEditingController();
    _snackemailController = new TextEditingController();
    _snacktownController = new TextEditingController();
    _snackstreetController = new TextEditingController();
    _snackphone1Controller = new TextEditingController();
    _snackphone2Controller = new TextEditingController();
    _siteemailController = new TextEditingController();
    _sitetownController = new TextEditingController();
    _sitestreetController = new TextEditingController();
    _sitephone1Controller = new TextEditingController();
    _sitephone2Controller = new TextEditingController();

    _usernameNode = new FocusNode();
    _useraddressNode = new FocusNode();
    _userphoneNode = new FocusNode();
    _useremailNode = new FocusNode();
    _userloginNode = new FocusNode();
    _userpasswordNode = new FocusNode();
    _usercPasswordNode = new FocusNode();
    _snacknameNode = new FocusNode();
    _snackemailNode = new FocusNode();
    _snacktownNode = new FocusNode();
    _snackstreetNode = new FocusNode();
    _snackphone1Node = new FocusNode();
    _snackphone2Node = new FocusNode();
    _siteemailNode = new FocusNode();
    _sitetownNode = new FocusNode();
    _sitestreetNode = new FocusNode();
    _sitephone1Node = new FocusNode();
    _sitephone2Node = new FocusNode();
  }

  _connectionAttempt() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> _params = Map();
    _params['username'] = _usernameController.text;
    _params['useraddress'] = _useraddressController.text;
    _params['userphone'] = _userphoneController.text;
    _params['useremail'] = _useremailController.text;
    _params['userusername'] = _userloginController.text;
    _params['userpassword'] = _userpasswordController.text;

    _params['companyname'] = _snacknameController.text;
    _params['companyemail'] = _snackemailController.text;
    _params['companytown'] = _snacktownController.text;
    _params['companystreet'] = _snackstreetController.text;
    _params['companyphone1'] = _snackphone1Controller.text;
    if (_snackphone2Controller.text.isNotEmpty) {
      _params['companyphone2'] = _snackphone2Controller.text;
    }

    _params['sitename'] =
        "${_snacknameController.text} ${_sitestreetController.text}";
    _params['siteemail'] = _siteemailController.text;
    _params['sitetown'] = _sitetownController.text;
    _params['sitestreet'] = _sitestreetController.text;
    _params['sitephone1'] = _sitephone1Controller.text;
    if (_sitephone2Controller.text.isNotEmpty) {
      _params['sitephone2'] = _sitephone2Controller.text;
    }

    _params['type'] = _selectedPlan.id.toString();

    await register(_params).then((success) {
      setState(() {
        _isLoading = false;
      });
      if (success) {
        _showSuccessMessage();
      } else {
        _showErrorMessage();
      }
    });
  }

  _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

   _cToggle() {
    setState(() {
      _cObscureText = !_cObscureText;
    });
  }

  _setPage(_current) {
    setState(() {
      _currentPage = _current;
    });
  }

  Widget _firstPage() {
    return FutureBuilder(
      future: _plans,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          _listOfPlans = snapshot.data;
          _selectedPlan = _listOfPlans[0];
        } else if (snapshot.connectionState == ConnectionState.none) {
          errorStatusCode = 0;
          _showErrorMessage();
        }
        return Column(
          children: <Widget>[
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
                    controller: _usernameController,
                    focusNode: _usernameNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        nextNode(context, _usernameNode, _useraddressNode),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champs obligatoire';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        prefixIcon: Icon(AmazingIcon.account_circle_line,
                            color: Color(0xff000000), size: 15.0),
                        hintText: 'Nom complet',
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
              height: screenSize(context).height / 31.0,
            ),
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.5),
                  child: Container(
                      height: 48.0, decoration: textFormFieldBoxDecoration),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    obscureText: false,
                    controller: _useraddressController,
                    focusNode: _useraddressNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        nextNode(context, _useraddressNode, _userphoneNode),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champs obligatoire';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                            color: Color(0xff000000), size: 15.0),
                        hintText: 'Adresse',
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
              height: screenSize(context).height / 31.0,
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
                    controller: _userphoneController,
                    focusNode: _userphoneNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) =>
                        nextNode(context, _userphoneNode, _useremailNode),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champs obligatoire';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        prefixIcon: Icon(AmazingIcon.phone_line,
                            color: Color(0xff000000), size: 15.0),
                        hintText: 'Telephone',
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
              height: screenSize(context).height / 31.0,
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
                    controller: _useremailController,
                    focusNode: _useremailNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) =>
                        nextNode(context, _useremailNode, _userloginNode),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champs obligatoire';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        prefixIcon: Icon(AmazingIcon.at_line,
                            color: Color(0xff000000), size: 15.0),
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
              height: screenSize(context).height / 31.0,
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
                    controller: _userloginController,
                    focusNode: _userloginNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        nextNode(context, _userloginNode, _userpasswordNode),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champs obligatoire';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        prefixIcon: Icon(AmazingIcon.user_6_line,
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
              height: screenSize(context).height / 31.0,
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
                    obscureText: _obscureText,
                    controller: _userpasswordController,
                    focusNode: _userpasswordNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => nextNode(
                        context, _userpasswordNode, _usercPasswordNode),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champs obligatoire';
                      }
                      if (value.length < 8) {
                        return 'Au minimum 8 carateres';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        prefixIcon: Icon(AmazingIcon.lock_password_line,
                            color: Color(0xff000000), size: 15.0),
                        hintText: 'Mot de passe',
                        suffixIcon: IconButton(
                          onPressed: () => _toggle(),
                          icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xff000000),
                              size: 15.0),
                        ),
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
              height: screenSize(context).height / 31.0,
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
                    obscureText: _cObscureText,
                    controller: _usercPasswordController,
                    focusNode: _usercPasswordNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _usercPasswordNode.unfocus();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champs obligatoire';
                      }
                      if (value.length < 8) {
                        return 'Au minimum 8 carateres';
                      }
                      if (_usercPasswordController.text
                              .compareTo(_userpasswordController.text) !=
                          0) {
                        return 'les mots de passe ne coincident pas';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        prefixIcon: Icon(AmazingIcon.lock_password_line,
                            color: Color(0xff000000), size: 15.0),
                        hintText: 'Confirmation de mot de passe',
                        suffixIcon: IconButton(
                          onPressed: () => _cToggle(),
                          icon: Icon(
                              _cObscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xff000000),
                              size: 15.0),
                        ),
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
          ],
        );
      },
    );
  }

  Widget _secondPage() {
    return Column(
      children: <Widget>[
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
                controller: _snacknameController,
                focusNode: _snacknameNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    nextNode(context, _snacknameNode, _snackemailNode),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.community_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Nom du snack',
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
          height: screenSize(context).height / 31.0,
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
                controller: _snackemailController,
                focusNode: _snackemailNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) =>
                    nextNode(context, _snackemailNode, _snacktownNode),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.at_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'email',
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
          height: screenSize(context).height / 31.0,
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
                controller: _snacktownController,
                focusNode: _snacktownNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    nextNode(context, _snacktownNode, _snackstreetNode),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Ville',
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
          height: screenSize(context).height / 31.0,
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
                controller: _snackstreetController,
                focusNode: _snackstreetNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    nextNode(context, _snackstreetNode, _snackphone1Node),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.community_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Rue',
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
          height: screenSize(context).height / 31.0,
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
                controller: _snackphone1Controller,
                focusNode: _snackphone1Node,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) =>
                    nextNode(context, _snackphone1Node, _snackphone2Node),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.phone_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Telephone No 1',
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
          height: screenSize(context).height / 31.0,
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
                controller: _snackphone2Controller,
                focusNode: _snackphone2Node,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  _snackphone2Node.unfocus();
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.phone_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Telephone No 2',
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
      ],
    );
  }

  Widget _thirdPage() {
    return Column(
      children: <Widget>[
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
                controller: _siteemailController,
                focusNode: _siteemailNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) =>
                    nextNode(context, _siteemailNode, _sitetownNode),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.at_line,
                        color: Color(0xff000000), size: 15.0),
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
          height: screenSize(context).height / 31.0,
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
                controller: _sitetownController,
                focusNode: _sitetownNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    nextNode(context, _sitetownNode, _sitestreetNode),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Ville',
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
          height: screenSize(context).height / 31.0,
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
                controller: _sitestreetController,
                focusNode: _sitestreetNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    nextNode(context, _sitestreetNode, _sitephone1Node),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Quartier',
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
          height: screenSize(context).height / 31.0,
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
                controller: _sitephone1Controller,
                focusNode: _sitephone1Node,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) =>
                    nextNode(context, _sitephone1Node, _sitephone2Node),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.phone_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Telephone No 1',
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
          height: screenSize(context).height / 31.0,
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
                controller: _sitephone2Controller,
                focusNode: _sitephone2Node,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  _sitephone2Node.unfocus();
                },
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 50.0),
                    prefixIcon: Icon(AmazingIcon.phone_line,
                        color: Color(0xff000000), size: 15.0),
                    hintText: 'Telephone No 2',
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
      ],
    );
  }

  Widget _lastPage() {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenSize(context).height / 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Pack',
                    style: TextStyle(fontSize: screenSize(context).height / 43),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(_selectedPlan.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize(context).height / 35)),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Duree',
                    style: TextStyle(fontSize: screenSize(context).height / 43),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("${_selectedPlan.duration.toString()} Mois",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize(context).height / 35)),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Montant',
          style: TextStyle(fontSize: screenSize(context).height / 43),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text("${_selectedPlan.price.toString()} XFA",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenSize(context).height / 35)),
        SizedBox(
          height: 20.0,
        ),
        Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                  height: 48.0, decoration: textFormFieldBoxDecoration),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 5.0),
              child: DropdownButton<Plan>(
                underline: Text(''),
                icon: Icon(
                  AmazingIcon.arrow_down_s_line,
                  color: Color(0xff000000).withOpacity(.4),
                ),
                isExpanded: true,
                value: _selectedPlan,
                onChanged: (Plan plan) {
                  setState(() {
                    _selectedPlan = plan;
                  });
                },
                items: _listOfPlans.map((Plan plan) {
                  return DropdownMenuItem<Plan>(
                    onTap: () {},
                    value: plan,
                    child: Row(
                      children: <Widget>[
                        Icon(AmazingIcon.community_line),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          plan.title,
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _recapPage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Nom',
            style: TextStyle(fontSize: screenSize(context).height / 43),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(_usernameController.text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize(context).height / 35)),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Nom d\'utilisateur',
            style: TextStyle(fontSize: screenSize(context).height / 43),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(_userloginController.text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize(context).height / 35)),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Snack',
            style: TextStyle(fontSize: screenSize(context).height / 43),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(_snacknameController.text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize(context).height / 35)),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Site',
            style: TextStyle(fontSize: screenSize(context).height / 43),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text('${_sitetownController.text}, ${_sitestreetController.text}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize(context).height / 35)),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Licence',
            style: TextStyle(fontSize: screenSize(context).height / 43),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(_selectedPlan.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize(context).height / 35)),
        ],
      ),
    );
  }

  _showErrorMessage({error}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                  height: 275.0,
                  child: errorStatusCode == 401
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            errorAlertIcon(context),
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
                              'ou mot de passe est incorrecte.',
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
                                  height: 20.0,
                                ),
                                Text(
                                  'Erreur de serveur',
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
                                  'identifier car Notre serveur est',
                                  style: alertDialogContentStyle,
                                ),
                                Text(
                                  'indisponible pour l\'instant',
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
                                  height: 20.0,
                                ),
                                Text(
                                  'Erreur de connectivite',
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
                                  'identifier. Verifier votre acces',
                                  style: alertDialogContentStyle,
                                ),
                                Text(
                                  'internet.',
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

  _showSuccessMessage() {
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
                    Container(
                      width: 100.0,
                      height: 100.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: lightBlueColor.withOpacity(.1),
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      child: Icon(AmazingIcon.checkbox_circle_line,
                          color: Colors.green, size: 100),
                    ),
                    SizedBox(
                      height: screenSize(context).height / 40,
                    ),
                    Text(
                      'Inscription',
                      style: subLogoTitleStyle,
                    ),
                    Text(
                      'Reussie',
                      style: subLogoTitleStyle,
                    ),
                    SizedBox(
                      height: 20.0,
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
                ))));
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
                  child: Container(
                    width: screenSize(context).width,
                    height: screenSize(context).height,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: screenSize(context).height / 30,
                          ),
                          Center(
                            child: Image.asset(
                              _currentPage < 4
                                  ? 'img/Logo.png'
                                  : 'img/logos/LogoWithText.png',
                              width: _currentPage < 4
                                  ? screenSize(context).height / 13
                                  : screenSize(context).height / 5,
                            ),
                          ),
                          SizedBox(
                            height: screenSize(context).height / 30.0,
                          ),
                          _currentPage < 4
                              ? Column(
                                  children: <Widget>[
                                    Text('Inscription',
                                        style: TextStyle(
                                            fontSize:
                                                screenSize(context).height /
                                                    20)),
                                    SizedBox(
                                        height:
                                            screenSize(context).height / 100),
                                    Text(
                                      _currentPage == 0
                                          ? 'Creer un compte pour acceder'
                                          : _currentPage == 1
                                              ? 'Ajouter un snack sur'
                                              : _currentPage == 2
                                                  ? 'Ajouter un site a'
                                                  : 'Selectionner la licence',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.7),
                                          fontSize:
                                              screenSize(context).height / 39),
                                    ),
                                    Text(
                                      _currentPage == 0
                                          ? 'a la plate-forme'
                                          : _currentPage == 1
                                              ? 'la plate-forme'
                                              : _currentPage == 2
                                                  ? 'votre snack'
                                                  : 'pour votre snack',
                                      style: TextStyle(
                                          color:
                                              Color(0xff000000).withOpacity(.7),
                                          fontSize:
                                              screenSize(context).height / 39),
                                    ),
                                  ],
                                )
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Recapitulatif',
                                    style: TextStyle(
                                        fontSize:
                                            screenSize(context).height / 21),
                                  ),
                                ),
                          SizedBox(height: screenSize(context).height / 30),
                          _currentPage == 0
                              ? _firstPage()
                              : _currentPage == 1
                                  ? _secondPage()
                                  : _currentPage == 2
                                      ? _thirdPage()
                                      : _currentPage == 3
                                          ? _lastPage()
                                          : _recapPage(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize(context).height / 31.0,
                            ),
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  _currentPage < 4
                                      ? _setPage(++_currentPage)
                                      : _connectionAttempt();
                                }
                              },
                              child: Container(
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [gradient1, gradient2])),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Center(
                                      child: Text(
                                        _currentPage < 4
                                            ? 'continuer'
                                            : 'Terminer',
                                        style: TextStyle(
                                            color: Color(0xffffffff),
                                            fontSize: 18),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          _currentPage > 0
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    bottom: screenSize(context).height / 31.0,
                                  ),
                                  child: InkWell(
                                    onTap: () => _setPage(--_currentPage),
                                    child: Container(
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xff000000)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: Center(
                                            child: Text(
                                              'Retour',
                                              style: TextStyle(
                                                  color: Color(0xff000000),
                                                  fontSize: 18),
                                            ),
                                          ),
                                        )),
                                  ),
                                )
                              : Container(),
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
