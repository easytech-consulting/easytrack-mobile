import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/role.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/user.dart';
import 'package:easytrack/services/employeeService.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/services/roleService.dart';
import 'package:easytrack/services/siteService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final Map site;

  const UserPage({Key key, this.site}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var _formKey;
  Future _futureRoles;
  bool _isLoading, _showErrorRole;
  List _roles;
  Role _role;
  int _selectedRoleId;
  bool _obscureText;
  TextEditingController _controller;
  List _users = [], _userRole = [];
  Site _site;
  Future _futureEmployees;
  bool _searchMode;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _usernameController;
  TextEditingController _useraddressController;
  TextEditingController _userphoneController;
  TextEditingController _useremailController;
  TextEditingController _userloginController;
  TextEditingController _userpasswordController;

  FocusNode _usernameNode;
  FocusNode _useraddressNode;
  FocusNode _userphoneNode;
  FocusNode _useremailNode;
  FocusNode _userloginNode;
  FocusNode _userpasswordNode;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _futureRoles = fetchRoles();
    _controller = new TextEditingController();
    _searchMode = false;
    _isLoading = false;
    _scaffoldKey = GlobalKey();
    _site = Site.fromJson(widget.site);
    if (widget.site != null && widget.site['employees'].isNotEmpty) {
      _users = widget.site['employees']
          .map((e) => User.fromJson(e['user']))
          .toList();
      _userRole = widget.site['employees']
          .map((e) => Role.fromJson(e['user']['role']))
          .toList();
    }

    _usernameController = new TextEditingController();
    _useraddressController = new TextEditingController();
    _userphoneController = new TextEditingController();
    _useremailController = new TextEditingController();
    _userloginController = new TextEditingController();
    _userpasswordController = new TextEditingController();

    _usernameNode = new FocusNode();
    _useraddressNode = new FocusNode();
    _userphoneNode = new FocusNode();
    _useremailNode = new FocusNode();
    _userloginNode = new FocusNode();
    _userpasswordNode = new FocusNode();

    _obscureText = true;
    _showErrorRole = false;
  }

  _attemptUpdate(User _user) async {
    Map<String, dynamic> _params = Map();
    _params['name'] = _usernameController.text.isEmpty
        ? _user.name
        : _usernameController.text.isEmpty;
    _params['email'] = _useremailController.text.isEmpty
        ? _user.email
        : _useremailController.text;
    _params['username'] = _userloginController.text.isEmpty
        ? _user.username
        : _userloginController.text;
    _params['address'] = _useraddressController.text.isEmpty
        ? _user.address
        : _useraddressController.text;
    _params['phone'] = _userphoneController.text.isEmpty
        ? _user.tel
        : _userphoneController.text;

    /* setState(() {
      _isLoading = true;
    }); */
    print(_params);
    Navigator.pop(context);
    /* await createEmployee(_params).then((employee) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SitePage()));
    }); */
  }

  _deleteSite(int index) {
    _showConfirmationMessage(index);
  }

  _showDetails(User _user, Role _role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: myHeight(context) * .76,
          width: myWidth(context) * .82,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: myHeight(context) / 60,
                horizontal: myHeight(context) / 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      _user.name,
                      style: TextStyle(
                          fontSize: myHeight(context) / 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(AmazingIcon.close_line))
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 50.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      AmazingIcon.map_pin_2_line,
                    ),
                    SizedBox(
                      width: myWidth(context) / 50,
                    ),
                    Text(
                      '${_user.address}, Cameroun',
                      style: TextStyle(
                          color: textInverseModeColor.withOpacity(.54),
                          fontSize: myHeight(context) / 38.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: myHeight(context) / 50.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: myWidth(context) / 80),
                  child: Text(
                    _role.name,
                    style: TextStyle(
                        color: gradient1, fontSize: myHeight(context) / 40.0),
                  ),
                ),
                SizedBox(
                  height: myHeight(context) / 60.0,
                ),
                Divider(
                  thickness: 1.5,
                  color: greyColor,
                ),
                SizedBox(
                  height: myHeight(context) / 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${company.name}',
                      style: TextStyle(
                          fontSize: myHeight(context) / 33,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: myWidth(context) / 50,
                    ),
                    Text(
                      'Site ${_site.street}',
                      style: TextStyle(
                          color: textInverseModeColor.withOpacity(.54),
                          fontSize: myHeight(context) / 38.0),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Telephone',
                      style: TextStyle(
                          color: textInverseModeColor.withOpacity(.54),
                          fontSize: myHeight(context) / 38.0),
                    ),
                    SizedBox(
                      width: myWidth(context) / 50,
                    ),
                    Text(
                      _user.tel,
                      style: TextStyle(
                          fontSize: myHeight(context) / 33,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () => launchMail(_user.email),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Email',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.54),
                            fontSize: myHeight(context) / 38.0),
                      ),
                      SizedBox(
                        width: myWidth(context) / 50,
                      ),
                      Text(
                        '${_user.email}',
                        style: TextStyle(
                            fontSize: myHeight(context) / 33,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: myHeight(context) / 50.0,
                ),
                Spacer(),
                InkWell(
                  child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [gradient1, gradient2]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            'Appeler',
                            style: TextStyle(
                                color: textInverseModeColor, fontSize: 18),
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _attemptSave() async {
    Map<String, dynamic> _params = Map();
    _params['name'] = _usernameController.text;
    _params['email'] = _useremailController.text;
    _params['username'] = _userloginController.text;
    _params['address'] = _useraddressController.text;
    _params['phone'] = _userphoneController.text;
    _params['password'] = _userpasswordController.text;
    _params['role_id'] = _selectedRoleId.toString();
    _params['site_id'] = _site.id.toString();

    setState(() {
      _isLoading = true;
    });
    Navigator.pop(context);
    await createEmployee(_params).then((employee) {
      setState(() {
        _isLoading = false;
        _futureEmployees = fetchEmployeesOfSite(_site.id);
      });
    });
  }

  _updateUser(User _user) {
    _usernameController = new TextEditingController();
    _useraddressController = new TextEditingController();
    _userphoneController = new TextEditingController();
    _useremailController = new TextEditingController();
    _userloginController = new TextEditingController();
    _userpasswordController = new TextEditingController();

    showDialog(
      context: context,
      builder: (context) => ListView(
        children: <Widget>[
          AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: myHeight(context) / 60,
                      horizontal: myHeight(context) / 100),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Nouvel employe',
                              style: TextStyle(
                                  fontSize: myHeight(context) / 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(AmazingIcon.close_line))
                          ],
                        ),
                        SizedBox(
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: _usernameController,
                                focusNode: _usernameNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _usernameNode, _useraddressNode),
                                validator: (value) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    prefixIcon: Icon(
                                        AmazingIcon.account_circle_line,
                                        color: textInverseModeColor,
                                        size: 15.0),
                                    hintText: '${_user.name}',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.5),
                              child: Container(
                                  height: 48.0,
                                  decoration: buildTextFormFieldContainer(
                                      decorationColor)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                obscureText: false,
                                controller: _useraddressController,
                                focusNode: _useraddressNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _useraddressNode, _userphoneNode),
                                validator: (value) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: '${_user.address}',
                                    fillColor: textInverseModeColor,
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: _userphoneController,
                                focusNode: _userphoneNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _userphoneNode, _useremailNode),
                                validator: (value) => checkNumberValidity(value,
                                    canBeEmpty: true),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    prefixIcon: Icon(AmazingIcon.phone_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: '${_user.tel}',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: _useremailController,
                                focusNode: _useremailNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _useremailNode, _userloginNode),
                                validator: (value) =>
                                    checkEmailValidity(value, canBeEmpty: true),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    prefixIcon: Icon(AmazingIcon.at_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: '${_user.email}',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                controller: _userloginController,
                                focusNode: _userloginNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _userloginNode, _userpasswordNode),
                                validator: (value) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    prefixIcon: Icon(AmazingIcon.user_6_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: '${_user.username}',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              _attemptUpdate(_user);
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
                                    'Sauvegarder',
                                    style: TextStyle(
                                        color: textInverseModeColor, fontSize: 18),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                );
              })),
        ],
      ),
    );
  }

  _createUser() {
    _usernameController = new TextEditingController();
    _useraddressController = new TextEditingController();
    _userphoneController = new TextEditingController();
    _useremailController = new TextEditingController();
    _userloginController = new TextEditingController();
    _userpasswordController = new TextEditingController();

    showDialog(
      context: context,
      builder: (context) => ListView(
        children: <Widget>[
          AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: myHeight(context) / 60,
                      horizontal: myHeight(context) / 100),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Nouvel employe',
                              style: TextStyle(
                                  fontSize: myHeight(context) / 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(AmazingIcon.close_line))
                          ],
                        ),
                        SizedBox(
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: _usernameController,
                                focusNode: _usernameNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _usernameNode, _useraddressNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Champs obligatoire';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 50.0),
                                    prefixIcon: Icon(
                                        AmazingIcon.account_circle_line,
                                        color: textInverseModeColor,
                                        size: 15.0),
                                    hintText: 'Nom complet',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.5),
                              child: Container(
                                  height: 48.0,
                                  decoration: buildTextFormFieldContainer(
                                      decorationColor)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                obscureText: false,
                                controller: _useraddressController,
                                focusNode: _useraddressNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _useraddressNode, _userphoneNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Champs obligatoire';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 50.0),
                                    prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: 'Adresse',
                                    fillColor: textInverseModeColor,
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: _userphoneController,
                                focusNode: _userphoneNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _userphoneNode, _useremailNode),
                                validator: (value) =>
                                    checkNumberValidity(value),
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 50.0),
                                    prefixIcon: Icon(AmazingIcon.phone_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: 'Telephone',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: _useremailController,
                                focusNode: _useremailNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _useremailNode, _userloginNode),
                                validator: (value) => checkEmailValidity(value),
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 50.0),
                                    prefixIcon: Icon(AmazingIcon.at_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: _userloginController,
                                focusNode: _userloginNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => nextNode(
                                    context, _userloginNode, _userpasswordNode),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Champs obligatoire';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 50.0),
                                    prefixIcon: Icon(AmazingIcon.user_6_line,
                                        color: textInverseModeColor, size: 15.0),
                                    hintText: 'Nom d\'utilisateur',
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                height: 48.0,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                obscureText: _obscureText,
                                controller: _userpasswordController,
                                focusNode: _userpasswordNode,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) =>
                                    _userpasswordNode.unfocus(),
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
                                        const EdgeInsets.only(left: 50.0),
                                    prefixIcon: Icon(
                                        AmazingIcon.lock_password_line,
                                        color: textInverseModeColor,
                                        size: 15.0),
                                    hintText: 'Mot de passe',
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: textInverseModeColor,
                                          size: 15.0),
                                    ),
                                    hintStyle: TextStyle(
                                        color:
                                            textInverseModeColor.withOpacity(.35),
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
                          height: myHeight(context) / 31.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            height: 48.0,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: DropdownButton<Role>(
                                underline: Text(''),
                                isExpanded: true,
                                icon: Icon(AmazingIcon.arrow_down_s_line,
                                    color: textInverseModeColor, size: 15.0),
                                hint: Text('Selectionnez un role'),
                                items: _roles.map((role) {
                                  return DropdownMenuItem<Role>(
                                    child: Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              child: Icon(
                                                  AmazingIcon.community_line,
                                                  size: 15.0)),
                                          Text(role.name),
                                        ],
                                      ),
                                    ),
                                    value: role,
                                  );
                                }).toList(),
                                onChanged: (Role role) {
                                  setState(() {
                                    _selectedRoleId = role.id;
                                    _role = role;
                                  });
                                },
                                value: _role,
                              ),
                            ),
                          ),
                        ),
                        _showErrorRole
                            ? Positioned(
                                left: 0.0,
                                child: Text(
                                  'choisissez un role',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15.0),
                                ),
                              )
                            : Container(
                                height: 0.0,
                              ),
                        SizedBox(
                          height: myHeight(context) / 31.0,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              if (_selectedRoleId == null) {
                                setState(() {
                                  _showErrorRole = true;
                                });
                              } else {
                                _attemptSave();
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
                                    'Sauvegarder',
                                    style: TextStyle(
                                        color: textInverseModeColor, fontSize: 18),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                );
              })),
        ],
      ),
    );
  }

  _showConfirmationMessage(int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: Container(
                  height: myHeight(context) / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      errorAlertIcon(context),
                      SizedBox(
                        height: myHeight(context) / 40,
                      ),
                      Text(
                        'Operation de suppression',
                        style: TextStyle(
                            color: textInverseModeColor,
                            fontSize: myWidth(context) / 22),
                      ),
                      SizedBox(height: myHeight(context) / 80),
                      Text(
                        'Vous allez supprimer cet employe.',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 25),
                      ),
                      Text(
                        'Attention cette operation',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 25),
                      ),
                      Text(
                        'est irreversible.',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.5),
                            fontSize: myWidth(context) / 25),
                      ),
                      SizedBox(
                        height: myHeight(context) / 40,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlineButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              borderSide: BorderSide(color: textInverseModeColor),
                              onPressed: () => Navigator.pop(context),
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  child: Text('Supprimer')),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ));
  }

  _filterData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: myHeight(context) / 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Trier par',
                  style: TextStyle(fontSize: myHeight(context) / 40.0)),
              SizedBox(
                height: myHeight(context) / 50.0,
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Nom',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Quantite',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Prix',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              ListTile(
                leading: Icon(AmazingIcon.list_settings_fill),
                title: Text('Date',
                    style: TextStyle(fontSize: myHeight(context) / 40.0)),
              ),
              Divider(
                thickness: 2.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _futureEmployees = fetchEmployeesOfSite(_site.id);
                  });
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  leading: Icon(AmazingIcon.refresh_line),
                  title: Text('Actualiser',
                      style: TextStyle(
                          fontSize: myHeight(context) / 40.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: textSameModeColor,
            onPressed: () => _createUser(),
            child: Icon(
              Icons.add,
              color: gradient1,
            ),
          ),
          backgroundColor: backgroundColor,
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    height: myHeight(context) * .06,
                    alignment: Alignment.bottomCenter,
                    child: _searchMode
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    height: 36.0,
                                    decoration: buildTextFormFieldContainer(
                                        decorationColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Container(
                                    height: 36.0,
                                    child: TextFormField(
                                      onFieldSubmitted: (_) {
                                        setState(() {
                                          _searchMode = false;
                                        });
                                      },
                                      controller: _controller,
                                      textInputAction: TextInputAction.done,
                                      style:
                                          TextStyle(color: textInverseModeColor),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 50.0),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _searchMode = false;
                                                });
                                              },
                                              icon: Icon(AmazingIcon.close_fill,
                                                  size: 20.0)),
                                          hintText: 'Recherche...',
                                          prefixIcon:
                                              Icon(AmazingIcon.search_2_line),
                                          hintStyle: TextStyle(
                                              color: textInverseModeColor
                                                  .withOpacity(.35),
                                              fontSize: 18.0),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(Icons.arrow_back)),
                                SizedBox(
                                  width: myHeight(context) / 40.0,
                                ),
                                Text(
                                  'Site ${_site.street}',
                                  style: TextStyle(
                                      fontSize: myHeight(context) / 35.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _searchMode = true;
                                        });
                                      },
                                      child: Icon(AmazingIcon.search_2_line)),
                                ),
                                InkWell(
                                    onTap: () => _filterData(),
                                    child: Icon(AmazingIcon.list_settings_fill))
                              ],
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, myHeight(context) / 80.0,
                        15.0, myWidth(context) / 110.0),
                    child: Divider(
                      thickness: 1.5,
                      color: greyColor,
                    ),
                  ),
                  _futureEmployees != null
                      ? FutureBuilder(
                          future: _futureEmployees,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              _users = snapshot.data['employees']
                                  .map((e) => User.fromJson(e['user']))
                                  .toList();
                              _userRole = snapshot.data['employees']
                                  .map((e) => Role.fromJson(e['user']['role']))
                                  .toList();
                              return Container(
                                width: myWidth(context),
                                height: myHeight(context) * .86,
                                child: ListView.builder(
                                    itemCount: _users.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                              height: myHeight(context) / 5.2,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  border: Border.all(
                                                      color:
                                                          textInverseModeColor
                                                              .withOpacity(
                                                                  .38))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: screenSize(
                                                                        context)
                                                                    .width /
                                                                80),
                                                        child: Row(
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () =>
                                                                  _showDetails(
                                                                      _users[
                                                                          index],
                                                                      _userRole[
                                                                          index]),
                                                              child: Text(
                                                                _users[index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenSize(context).height /
                                                                            30,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                                onTap: () {
                                                                  _scaffoldKey
                                                                      .currentState
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    duration: Duration(
                                                                        seconds:
                                                                            30),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    content:
                                                                        Container(
                                                                      height:
                                                                          145.0,
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(color: greyColor, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                                            height:
                                                                                5.0,
                                                                            width:
                                                                                150.0,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15.0,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 10.0),
                                                                            child:
                                                                                Row(
                                                                              children: <Widget>[
                                                                                Icon(
                                                                                  AmazingIcon.edit_2_line,
                                                                                  size: 15.0,
                                                                                  color: gradient1,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    _scaffoldKey.currentState.hideCurrentSnackBar();
                                                                                    _updateUser(_users[index]);
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 20.0),
                                                                                    child: Text(
                                                                                      'Modifier',
                                                                                      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: textInverseModeColor),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 10.0),
                                                                            child:
                                                                                Row(
                                                                              children: <Widget>[
                                                                                Icon(
                                                                                  AmazingIcon.repeat_2_line,
                                                                                  size: 15.0,
                                                                                  color: gradient1,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 20.0),
                                                                                  child: Text(
                                                                                    'Dupliquer',
                                                                                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: textInverseModeColor),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _scaffoldKey.currentState.hideCurrentSnackBar();
                                                                              _deleteSite(index);
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Icon(
                                                                                    AmazingIcon.delete_bin_6_line,
                                                                                    size: 15.0,
                                                                                    color: redColor,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 20.0),
                                                                                    child: Text(
                                                                                      'Supprimer',
                                                                                      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: textInverseModeColor),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ));
                                                                },
                                                                child: Icon(
                                                                  AmazingIcon
                                                                      .more_2_fill,
                                                                  size: 25.0,
                                                                  color: Colors
                                                                      .black54,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            screenSize(context)
                                                                    .height /
                                                                40.0,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            AmazingIcon
                                                                .map_pin_2_line,
                                                          ),
                                                          SizedBox(
                                                            width: screenSize(
                                                                        context)
                                                                    .width /
                                                                70,
                                                          ),
                                                          Text(
                                                            '${_users[index].address}, Cameroun',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: screenSize(
                                                                            context)
                                                                        .height /
                                                                    38.0),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            screenSize(context)
                                                                    .height /
                                                                40.0,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: screenSize(
                                                                        context)
                                                                    .width /
                                                                80),
                                                        child: Text(
                                                          _userRole[index].name,
                                                          style: TextStyle(
                                                              color: gradient1,
                                                              fontSize: screenSize(
                                                                          context)
                                                                      .height /
                                                                  40.0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )));
                                    }),
                              );
                            }
                            return Container(
                              height: myHeight(context) * .86,
                              color: Colors.transparent,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      new AlwaysStoppedAnimation(gradient1),
                                ),
                              ),
                            );
                          },
                        )
                      : FutureBuilder(
                          future: _futureRoles,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              _roles = snapshot.data;
                              return Container(
                                width: myWidth(context),
                                height: myHeight(context) * .86,
                                child: _users.length == 0
                                    ? Center(
                                        child: Text('Aucun personnel'),
                                      )
                                    : ListView.builder(
                                        itemCount: _users.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                  height: screenSize(context)
                                                          .height /
                                                      5.2,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .all(Radius
                                                              .circular(10.0)),
                                                      border: Border.all(
                                                          color:
                                                              textInverseModeColor
                                                                  .withOpacity(
                                                                      .38))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                left: screenSize(
                                                                            context)
                                                                        .width /
                                                                    80),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                InkWell(
                                                                  onTap: () => _showDetails(
                                                                      _users[
                                                                          index],
                                                                      _userRole[
                                                                          index]),
                                                                  child: Text(
                                                                    _users[index]
                                                                        .name,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            myHeight(context) /
                                                                                30,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                InkWell(
                                                                    onTap: () {
                                                                      _scaffoldKey
                                                                          .currentState
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        duration:
                                                                            Duration(seconds: 30),
                                                                        backgroundColor:
                                                                            textSameModeColor,
                                                                        content:
                                                                            Container(
                                                                          height:
                                                                              145.0,
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                decoration: BoxDecoration(color: greyColor, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                                                height: 5.0,
                                                                                width: 150.0,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15.0,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Icon(
                                                                                      AmazingIcon.edit_2_line,
                                                                                      size: 15.0,
                                                                                      color: gradient1,
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        _scaffoldKey.currentState.hideCurrentSnackBar();
                                                                                        _updateUser(_users[index]);
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 20.0),
                                                                                        child: Text(
                                                                                          'Modifier',
                                                                                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: textInverseModeColor),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Icon(
                                                                                      AmazingIcon.repeat_2_line,
                                                                                      size: 15.0,
                                                                                      color: gradient1,
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 20.0),
                                                                                      child: Text(
                                                                                        'Dupliquer',
                                                                                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: textInverseModeColor),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  _scaffoldKey.currentState.hideCurrentSnackBar();
                                                                                  _deleteSite(index);
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Icon(
                                                                                        AmazingIcon.delete_bin_6_line,
                                                                                        size: 15.0,
                                                                                        color: redColor,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 20.0),
                                                                                        child: Text(
                                                                                          'Supprimer',
                                                                                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: textInverseModeColor),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ));
                                                                    },
                                                                    child: Icon(
                                                                      AmazingIcon
                                                                          .more_2_fill,
                                                                      size:
                                                                          25.0,
                                                                      color: Colors
                                                                          .black54,
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: screenSize(
                                                                        context)
                                                                    .height /
                                                                40.0,
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                AmazingIcon
                                                                    .map_pin_2_line,
                                                              ),
                                                              SizedBox(
                                                                width: screenSize(
                                                                            context)
                                                                        .width /
                                                                    70,
                                                              ),
                                                              Text(
                                                                '${_users[index].address}, Cameroun',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        screenSize(context).height /
                                                                            38.0),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: screenSize(
                                                                        context)
                                                                    .height /
                                                                40.0,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                left: screenSize(
                                                                            context)
                                                                        .width /
                                                                    80),
                                                            child: Text(
                                                              _userRole[index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  color:
                                                                      gradient1,
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          40.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )));
                                        }),
                              );
                            }
                            return Container(
                              height: myHeight(context) * .86,
                              color: Colors.transparent,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      new AlwaysStoppedAnimation(gradient1),
                                ),
                              ),
                            );
                          },
                        )
                ],
              ),
              _isLoading
                  ? Container(
                      height: myHeight(context),
                      color: textSameModeColor.withOpacity(.9),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation(gradient1),
                        ),
                      ),
                    )
                  : Container(
                      height: 0.0,
                    )
            ],
          ),
        ));
  }
}
