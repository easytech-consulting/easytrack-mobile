import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/data.dart';
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
  List _users = [], _userRole = [];
  Site _site;
  Future _futureEmployees;
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

  OverlayEntry _overlay;

  _show(index, user) {
    setState(() {
      this._overlay = this._createOverlayEntry(index, user);
      Overlay.of(context).insert(this._overlay);
    });
  }

  _createOverlayEntry(index, user) {
    return OverlayEntry(
        builder: (context) => Positioned(
            bottom: 0.0,
            height: myHeight(context),
            width: myWidth(context),
            child: Material(
              color: Colors.black38,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => this._overlay.remove(),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: myHeight(context) * .23,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(myHeight(context) / 70.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth(context) / 13),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            height: 7.0,
                            width: 50.0,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          InkWell(
                            onTap: () {
                              this._overlay.remove();
                              _updateUser(user);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.edit_2_line,
                                    size: 15.0,
                                    color: gradient1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Modifier',
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: textInverseModeColor),
                                    ),
                                  )
                                ],
                              ),
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
                                InkWell(
                                  onTap: () {
                                    this._overlay.remove();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Dupliquer',
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: textInverseModeColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              this._overlay.remove();
                              _deleteUser(user.id);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
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
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: textInverseModeColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _futureRoles = fetchRoles();
    _isLoading = false;
    _scaffoldKey = GlobalKey();
    _site = Site.fromJson(widget.site);
    _futureEmployees = fetchEmployeesOfSite(_site.id);
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

    setState(() {
      _isLoading = true;
    });
    Navigator.pop(context);
    await updateEmployee(_params, user.id).then((employee) {
      setState(() {
        _isLoading = false;
        _futureEmployees = fetchEmployeesOfSite(_site.id);
      });
    });
  }

  _deleteUser(int index) {
    _showConfirmationMessage(index);
  }

  _showDetails(User _user, Role _role) {
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: myHeight(context) / 30,
                horizontal: myHeight(context) / 25),
            height: myHeight(context) * .8,
            width: myWidth(context) * .9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: myWidth(context) / 2,
                      child: Text(
                        _user.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: myHeight(context) / 30,
                            fontWeight: FontWeight.bold),
                      ),
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
                    Container(
                      width: myWidth(context) / 1.7,
                      child: Text(
                        '${_user.address}, Cameroun',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.54),
                            fontSize: myHeight(context) / 38.0),
                      ),
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
                      height: 48,
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ));
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

  _updateUser(User user) {
    _usernameController = new TextEditingController();
    _useraddressController = new TextEditingController();
    _userphoneController = new TextEditingController();
    _useremailController = new TextEditingController();
    _userloginController = new TextEditingController();
    _userpasswordController = new TextEditingController();
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: myHeight(context) / 30,
                  horizontal: myHeight(context) / 25),
              height: myHeight(context) * .7,
              width: myWidth(context) * .9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: StatefulBuilder(builder: (context, setState) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: myWidth(context) / 2,
                            child: Text(
                              'Mise a jour',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: myHeight(context) / 30,
                                  fontWeight: FontWeight.bold),
                            ),
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
                            padding: const EdgeInsets.only(left: 8.5),
                            child: Container(
                                height: 48,
                                decoration: buildTextFormFieldContainer(
                                    decorationColor)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              obscureText: false,
                              controller: _usernameController,
                              focusNode: _usernameNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _usernameNode, _useraddressNode),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(
                                      AmazingIcon.account_circle_line,
                                      color: textInverseModeColor,
                                      size: 15.0),
                                  hintText: user.name,
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
                            padding: const EdgeInsets.only(left: 8.5),
                            child: Container(
                                height: 48,
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
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: user.address,
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
                              height: 48,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
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
                                  checkNumberValidity(value, canBeEmpty: true),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.phone_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: user.tel,
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
                              height: 48,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
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
                              validator: (value) =>
                                  checkEmailValidity(value, canBeEmpty: true),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.at_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: user.email,
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
                              height: 48,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
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
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.user_6_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: user.username,
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
                            this._attemptUpdate(user);
                          }
                        },
                        child: Container(
                            height: myHeight(context) / 17.0,
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
                                  'Enregistrer',
                                  style: TextStyle(
                                      color: textSameModeColor,
                                      fontSize: myHeight(context) / 40.0),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                );
              })),
        ));
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
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: myHeight(context) / 30,
                  horizontal: myHeight(context) / 25),
              height: myHeight(context) * .82,
              width: myWidth(context) * .9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: StatefulBuilder(builder: (context, setState) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: myWidth(context) / 2,
                            child: Text(
                              'Nouvel employee',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: myHeight(context) / 30,
                                  fontWeight: FontWeight.bold),
                            ),
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
                            padding: const EdgeInsets.only(left: 8.5),
                            child: Container(
                                height: 48,
                                decoration: buildTextFormFieldContainer(
                                      decorationColor)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              obscureText: false,
                              controller: _usernameController,
                              focusNode: _usernameNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _usernameNode, _useraddressNode),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(
                                      AmazingIcon.account_circle_line,
                                      color: textInverseModeColor,
                                      size: 15.0),
                                  hintText: 'Nom complet',
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
                            padding: const EdgeInsets.only(left: 8.5),
                            child: Container(
                                height: 48,
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
                              height: 48,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
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
                              validator: (value) => checkNumberValidity(value),
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
                              height: 48,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
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
                              height: 48,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
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
                              height: 48,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
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
                          height: 48,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Icon(
                                              AmazingIcon.community_line,
                                              size: 15.0)),
                                      Text(role.name),
                                    ],
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
                            this._attemptSave();
                          }
                        },
                        child: Container(
                            height: myHeight(context) / 17.0,
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
                                  'Enregistrer',
                                  style: TextStyle(
                                      color: textSameModeColor,
                                      fontSize: myHeight(context) / 40.0),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                );
              })),
        ));
  }

  _deleteFunction(int id) async {
    setState(() {
      _isLoading = true;
    });
    Navigator.pop(context);
    await deleteEmployee(id).then((employee) {
      setState(() {
        _isLoading = false;
        _futureEmployees = fetchEmployeesOfSite(_site.id);
      });
    });
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
                              borderSide:
                                  BorderSide(color: textInverseModeColor),
                              onPressed: () => _deleteFunction(index),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
            backgroundColor: backgroundColor,
            key: _scaffoldKey,
            body: Stack(
              children: [
                FutureBuilder(
                  future: _futureEmployees,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      _users = snapshot.data['employees']
                          .map((e) => User.fromJson(e['user']))
                          .toList();
                      globalEmployees = _users;
                      _userRole = snapshot.data['employees']
                          .map((e) => Role.fromJson(e['user']['role']))
                          .toList();
                      if (_roles == null) {
                        return FutureBuilder(
                          future: _futureRoles,
                          builder: (context, snapshotRole) {
                            if (snapshotRole.hasData) {
                              _roles = snapshotRole.data;
                              return CustomScrollView(
                                slivers: [
                                  sliverHeader(context,
                                      'Site ${widget.site["name"]}', 'Employee',
                                      canAdd: true, onClick: _createUser),
                                  _users == null || _users.length == 0
                                      ? SliverList(
                                          delegate:
                                              SliverChildListDelegate.fixed([
                                            Container(
                                              height: myHeight(context) / 1.5,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Aucun employe',
                                                style: TextStyle(
                                                    fontSize:
                                                        myHeight(context) /
                                                            50.0),
                                              ),
                                            )
                                          ]),
                                        )
                                      : SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                            return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: index == 0
                                                        ? myHeight(context) /
                                                            50.0
                                                        : myHeight(context) /
                                                            100.0,
                                                    horizontal:
                                                        myHeight(context) /
                                                            40.0),
                                                child: Container(
                                                    height:
                                                        myHeight(context) / 6.5,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    myHeight(context) /
                                                                        70.0)),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12)),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          myHeight(context) /
                                                              60.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              InkWell(
                                                                onTap: () => _showDetails(
                                                                    _users[
                                                                        index],
                                                                    _userRole[
                                                                        index]),
                                                                child:
                                                                    Container(
                                                                  width: myWidth(
                                                                          context) /
                                                                      1.4,
                                                                  child: Text(
                                                                    '${capitalize(_users[index].name)}',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            screenSize(context).height /
                                                                                35,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              InkWell(
                                                                  onTap: () => _show(
                                                                      index,
                                                                      _users[
                                                                          index]),
                                                                  child: Icon(
                                                                    AmazingIcon
                                                                        .more_2_fill,
                                                                    size: 25.0,
                                                                    color: Colors
                                                                        .black,
                                                                  ))
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Icon(
                                                                AmazingIcon
                                                                    .map_pin_2_line,
                                                                color: Colors
                                                                    .black54,
                                                                size: myHeight(
                                                                        context) /
                                                                    40.0,
                                                              ),
                                                              SizedBox(
                                                                width: screenSize(
                                                                            context)
                                                                        .width /
                                                                    40,
                                                              ),
                                                              Text(
                                                                '${_users[index].address}, Cameroun',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        screenSize(context).height /
                                                                            42.0),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Icon(
                                                                AmazingIcon
                                                                    .phone_line,
                                                                color: Colors
                                                                    .black54,
                                                                size: myHeight(
                                                                        context) /
                                                                    40.0,
                                                              ),
                                                              SizedBox(
                                                                width: screenSize(
                                                                            context)
                                                                        .width /
                                                                    40,
                                                              ),
                                                              Text(
                                                                '${_users[index].tel}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        screenSize(context).height /
                                                                            42.0),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )));
                                          }, childCount: _users.length),
                                        )
                                ],
                              );
                            }
                            return CustomScrollView(
                              slivers: [
                                sliverHeader(context,
                                    'Site ${widget.site["name"]}', 'Employee',
                                    canAdd: true, onClick: () {}),
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    Container(
                                      alignment: Alignment.center,
                                      height: myHeight(context) / 1.5,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation(gradient1),
                                      ),
                                    )
                                  ]),
                                )
                              ],
                            );
                          },
                        );
                      }
                      return CustomScrollView(
                        slivers: [
                          sliverHeader(context, 'Site ${widget.site["name"]}',
                              'Employee',
                              canAdd: true, onClick: _createUser),
                          _users == null || _users.length == 0
                              ? SliverList(
                                  delegate: SliverChildListDelegate.fixed([
                                    Container(
                                      height: myHeight(context) / 1.5,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Aucun employee',
                                        style: TextStyle(
                                            fontSize: myHeight(context) / 50.0),
                                      ),
                                    )
                                  ]),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: index == 0
                                                ? myHeight(context) / 50.0
                                                : myHeight(context) / 100.0,
                                            horizontal:
                                                myHeight(context) / 40.0),
                                        child: Container(
                                            height: myHeight(context) / 6.5,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        myHeight(context) /
                                                            70.0)),
                                                border: Border.all(
                                                    color: Colors.black12)),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  myHeight(context) / 60.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () =>
                                                            _showDetails(
                                                                _users[index],
                                                                _userRole[
                                                                    index]),
                                                        child: Container(
                                                          width:
                                                              myWidth(context) /
                                                                  1.4,
                                                          child: Text(
                                                            '${capitalize(_users[index].name)}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: screenSize(
                                                                            context)
                                                                        .height /
                                                                    35,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      InkWell(
                                                          onTap: () => _show(
                                                              index,
                                                              _users[index]),
                                                          child: Icon(
                                                            AmazingIcon
                                                                .more_2_fill,
                                                            size: 25.0,
                                                            color: Colors.black,
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Icon(
                                                        AmazingIcon
                                                            .map_pin_2_line,
                                                        color: Colors.black54,
                                                        size:
                                                            myHeight(context) /
                                                                40.0,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenSize(context)
                                                                    .width /
                                                                40,
                                                      ),
                                                      Text(
                                                        '${_users[index].address}, Cameroun',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: screenSize(
                                                                        context)
                                                                    .height /
                                                                42.0),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Icon(
                                                        AmazingIcon.user_6_line,
                                                        color: Colors.black54,
                                                        size:
                                                            myHeight(context) /
                                                                40.0,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenSize(context)
                                                                    .width /
                                                                40,
                                                      ),
                                                      Text(
                                                        '${_userRole[index].name}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: screenSize(
                                                                        context)
                                                                    .height /
                                                                42.0),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )));
                                  }, childCount: _users.length),
                                )
                        ],
                      );
                    }
                    return CustomScrollView(
                      slivers: [
                        sliverHeader(
                            context, 'Site ${widget.site["name"]}', 'Employee',
                            canAdd: true, onClick: () {}),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              alignment: Alignment.center,
                              height: myHeight(context) / 1.5,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(gradient1),
                              ),
                            )
                          ]),
                        )
                      ],
                    );
                  },
                ),
                _isLoading
                    ? Container(
                        width: myWidth(context),
                        height: myHeight(context),
                        color: textSameModeColor.withOpacity(.89),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(gradient1),
                          ),
                        ))
                    : Container(),
              ],
            )));
  }
}
