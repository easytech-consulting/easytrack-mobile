import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/user.dart';
import 'package:easytrack/screens/users/all.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/services/siteService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class SitePage extends StatefulWidget {
  @override
  _SitePageState createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  Future _companySites;
  User _owner;
  List _sites, _allSitesData;
  var _formKey;
  bool _isLoading;
  TextEditingController _controller;
  bool _searchMode;
  GlobalKey<ScaffoldState> _scaffoldKey;

  TextEditingController _siteemailController;
  TextEditingController _sitetownController;
  TextEditingController _sitestreetController;
  TextEditingController _sitephone1Controller;
  TextEditingController _sitephone2Controller;

  FocusNode _siteemailNode;
  FocusNode _sitetownNode;
  FocusNode _sitestreetNode;
  FocusNode _sitephone1Node;
  FocusNode _sitephone2Node;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _companySites = fetchSiteOfCompany(company.id);
    _controller = new TextEditingController();
    _searchMode = false;
    _scaffoldKey = GlobalKey();
    _isLoading = false;
    _siteemailController = new TextEditingController();
    _sitetownController = new TextEditingController();
    _sitestreetController = new TextEditingController();
    _sitephone1Controller = new TextEditingController();
    _sitephone2Controller = new TextEditingController();
    _siteemailNode = new FocusNode();
    _sitetownNode = new FocusNode();
    _sitestreetNode = new FocusNode();
    _sitephone1Node = new FocusNode();
    _sitephone2Node = new FocusNode();
  }

  _attemptUpdate(Site site) async {
    Map<String, dynamic> _params = Map();
    _params['name'] = _sitestreetController.text.isEmpty
        ? "${company.name} ${site.street}"
        : "${company.name} ${_siteemailController.text}";
    _params['email'] = _siteemailController.text.isEmpty
        ? site.email
        : _siteemailController.text;
    _params['town'] =
        _sitetownController.text.isEmpty ? site.town : _sitetownController.text;
    _params['street'] = _sitestreetController.text.isEmpty
        ? site.street
        : _sitestreetController.text;
    _params['phone1'] = _sitephone1Controller.text.isEmpty
        ? site.tel1
        : _sitephone1Controller.text;
    if (_sitephone2Controller.text.isNotEmpty) {
      _params['phone2'] = _sitephone2Controller.text;
    }

    Navigator.pop(context);
    setState(() {
      _isLoading = true;
    });
    await updateSite(_params, site.id).then((site) {
      setState(() {
        _isLoading = false;
        _companySites = fetchSiteOfCompany(company.id);
      });
    });
  }

  _deleteSite(int index) {
    _showConfirmationMessage(index);
  }

  _showDetails(Site _site, User director) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: screenSize(context).height * .76,
          width: screenSize(context).width * .82,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenSize(context).height / 60,
                horizontal: screenSize(context).height / 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Site - ${_site.street}',
                      style: TextStyle(
                          fontSize: screenSize(context).height / 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(AmazingIcon.close_line))
                  ],
                ),
                SizedBox(
                  height: screenSize(context).height / 50.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      AmazingIcon.map_pin_2_line,
                    ),
                    SizedBox(
                      width: screenSize(context).width / 50,
                    ),
                    Text(
                      '${_site.town}, Cameroun',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenSize(context).height / 38.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize(context).height / 50.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: screenSize(context).width / 80),
                  child: Text(
                    'Disponible',
                    style: TextStyle(
                        color: gradient1,
                        fontSize: screenSize(context).height / 40.0),
                  ),
                ),
                SizedBox(
                  height: screenSize(context).height / 60.0,
                ),
                Divider(
                  thickness: 1.5,
                  color: greyColor,
                ),
                SizedBox(
                  height: screenSize(context).height / 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Snack',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenSize(context).height / 38.0),
                    ),
                    SizedBox(
                      width: screenSize(context).width / 50,
                    ),
                    Text(
                      '${company.name}',
                      style: TextStyle(
                          fontSize: screenSize(context).height / 33,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Gerer par',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenSize(context).height / 38.0),
                    ),
                    SizedBox(
                      width: screenSize(context).width / 50,
                    ),
                    Text(
                      '${director.name}',
                      style: TextStyle(
                          fontSize: screenSize(context).height / 33,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () =>
                      launchCall(_site.tel2 == null ? _site.tel1 : _site.tel2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Telephone',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: screenSize(context).height / 38.0),
                      ),
                      SizedBox(
                        width: screenSize(context).width / 50,
                      ),
                      Text(
                        _site.tel2 == null ? '${_site.tel1}' : '${_site.tel2}',
                        style: TextStyle(
                            fontSize: screenSize(context).height / 33,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () => launchMail(site.email),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Email',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: screenSize(context).height / 38.0),
                      ),
                      SizedBox(
                        width: screenSize(context).width / 50,
                      ),
                      Text(
                        '${_site.email}',
                        style: TextStyle(
                            fontSize: screenSize(context).height / 33,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize(context).height / 50.0,
                ),
                Spacer(),
                InkWell(
                  onTap: () => launchCall(_site.tel1),
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
                                color: Color(0xffffffff), fontSize: 18),
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
    _params['name'] = "${company.name} ${_sitestreetController.text}";
    _params['email'] = _siteemailController.text;
    _params['town'] = _sitetownController.text;
    _params['street'] = _sitestreetController.text;
    _params['phone1'] = _sitephone1Controller.text;
    _params['phone2'] = _sitephone2Controller.text;
    _params['company_id'] = company.id.toString();

    Navigator.pop(context);
    setState(() {
      _isLoading = true;
    });
    await createSite(_params).then((site) {
      setState(() {
        _isLoading = false;
        _companySites = fetchSiteOfCompany(company.id);
      });
    });
  }

  _createSite() {
    _siteemailController.clear();
    _sitephone1Controller.clear();
    _sitephone2Controller.clear();
    _sitestreetController.clear();
    _sitetownController.clear();
    showDialog(
      context: context,
      builder: (context) => ListView(
        children: <Widget>[
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenSize(context).height / 60,
                  horizontal: screenSize(context).height / 100),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Nouveau Site',
                          style: TextStyle(
                              fontSize: screenSize(context).height / 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(AmazingIcon.close_line))
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
                            controller: _siteemailController,
                            focusNode: _siteemailNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (_) => nextNode(
                                context, _siteemailNode, _sitetownNode),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Champs obligatoire';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
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
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Champs obligatoire';
                              }

                              return null;
                            },
                            onFieldSubmitted: (_) => nextNode(
                                context, _sitetownNode, _sitestreetNode),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
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
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Champs obligatoire';
                              }

                              return null;
                            },
                            onFieldSubmitted: (_) => nextNode(
                                context, _sitestreetNode, _sitephone1Node),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                prefixIcon: Icon(AmazingIcon.map_pin_2_line,
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
                            controller: _sitephone1Controller,
                            focusNode: _sitephone1Node,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Champs obligatoire';
                              }

                              return null;
                            },
                            onFieldSubmitted: (_) => nextNode(
                                context, _sitephone1Node, _sitephone2Node),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                prefixIcon: Icon(AmazingIcon.phone_line,
                                    color: Color(0xff000000), size: 15.0),
                                hintText: 'Telphone No 1',
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
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              _sitephone2Node.unfocus();
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                prefixIcon: Icon(AmazingIcon.phone_line,
                                    color: Color(0xff000000), size: 15.0),
                                hintText: 'Telphone No 2',
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
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          _attemptSave();
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
                                'Sauvegarder',
                                style: TextStyle(
                                    color: Color(0xffffffff), fontSize: 18),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateSite(Site site) {
    _siteemailController.clear();
    _sitephone1Controller.clear();
    _sitephone2Controller.clear();
    _sitestreetController.clear();
    _sitetownController.clear();
    showDialog(
      context: context,
      builder: (context) => ListView(
        children: <Widget>[
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenSize(context).height / 60,
                  horizontal: screenSize(context).height / 100),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Site - ${site.street}',
                        style: TextStyle(
                            fontSize: screenSize(context).height / 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(AmazingIcon.close_line))
                    ],
                  ),
                  SizedBox(
                    height: screenSize(context).height / 31.0,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 48.0,
                        decoration: textFormFieldBoxDecoration,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: TextFormField(
                          controller: _siteemailController,
                          focusNode: _siteemailNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (_) =>
                              nextNode(context, _siteemailNode, _sitetownNode),
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              prefixIcon: Icon(AmazingIcon.at_line,
                                  color: Color(0xff000000), size: 15.0),
                              hintText: '${site.email}',
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
                      Container(
                        height: 48.0,
                        decoration: textFormFieldBoxDecoration,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: TextFormField(
                          controller: _sitetownController,
                          focusNode: _sitetownNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              nextNode(context, _sitetownNode, _sitestreetNode),
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                                  color: Color(0xff000000), size: 15.0),
                              hintText: '${site.town}',
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
                      Container(
                        height: 48.0,
                        decoration: textFormFieldBoxDecoration,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: TextFormField(
                          controller: _sitestreetController,
                          focusNode: _sitestreetNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => nextNode(
                              context, _sitestreetNode, _sitephone1Node),
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                                  color: Color(0xff000000), size: 15.0),
                              hintText: '${site.street}',
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
                      Container(
                        height: 48.0,
                        decoration: textFormFieldBoxDecoration,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: TextFormField(
                          controller: _sitephone1Controller,
                          focusNode: _sitephone1Node,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) => nextNode(
                              context, _sitephone1Node, _sitephone2Node),
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              prefixIcon: Icon(AmazingIcon.phone_line,
                                  color: Color(0xff000000), size: 15.0),
                              hintText: '${site.tel1}',
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
                      Container(
                        height: 48.0,
                        decoration: textFormFieldBoxDecoration,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
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
                              hintText: '${site.tel2}',
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
                  InkWell(
                    onTap: () => _attemptUpdate(site),
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
                              'Sauvegarder',
                              style: TextStyle(
                                  color: Color(0xffffffff), fontSize: 18),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
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
                        'Operation de suppression',
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: screenSize(context).width / 22),
                      ),
                      SizedBox(height: screenSize(context).height / 80),
                      Text(
                        'Vous allez supprimer le site ${index + 1}.',
                        style: TextStyle(
                            color: Color(0xff000000).withOpacity(.5),
                            fontSize: screenSize(context).width / 25),
                      ),
                      Text(
                        'Attention cette operation',
                        style: TextStyle(
                            color: Color(0xff000000).withOpacity(.5),
                            fontSize: screenSize(context).width / 25),
                      ),
                      Text(
                        'est irreversible.',
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
          body: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: screenSize(context).height * .06,
                      width: screenSize(context).width,
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
                                      decoration: textFormFieldBoxDecoration,
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
                                            TextStyle(color: Color(0xffffffff)),
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
                                                icon: Icon(
                                                    AmazingIcon.close_fill,
                                                    size: 20.0)),
                                            hintText: 'Recherche...',
                                            prefixIcon:
                                                Icon(AmazingIcon.search_2_line),
                                            hintStyle: TextStyle(
                                                color: Color(0xff000000)
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
                                      onTap: () =>
                                          Navigator.pushNamed(context, '/home'),
                                      child: Icon(Icons.arrow_back)),
                                  SizedBox(
                                    width: screenSize(context).height / 40.0,
                                  ),
                                  Text(
                                    'Mes Sites',
                                    style: TextStyle(
                                        fontSize:
                                            screenSize(context).height / 35.0,
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
                                      onTap: () => _createSite(),
                                      child:
                                          Icon(AmazingIcon.list_settings_fill))
                                ],
                              ),
                            ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      15.0,
                      screenSize(context).height / 80.0,
                      15.0,
                      screenSize(context).width / 110.0),
                  child: Divider(
                    thickness: 1.5,
                    color: greyColor,
                  ),
                ),
                FutureBuilder(
                    future: _companySites,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        _owner = User.fromJson(snapshot.data['owner']);
                        _allSitesData = snapshot.data['sites'];
                        _sites = _allSitesData
                            .map((site) => Site.fromJson(site))
                            .toList();
                        return Container(
                          width: screenSize(context).width,
                          height: screenSize(context).height * .86,
                          child: ListView.builder(
                              itemCount: _sites.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        height:
                                            screenSize(context).height / 5.2,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            border: Border.all(
                                                color: Colors.black38)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: screenSize(context)
                                                              .width /
                                                          80),
                                                  child: Row(
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () =>
                                                            _showDetails(
                                                                _sites[index],
                                                                _owner),
                                                        child: Text(
                                                          'Site - ${_sites[index].street}',
                                                          style: TextStyle(
                                                              fontSize: screenSize(
                                                                          context)
                                                                      .height /
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
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          30),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              content:
                                                                  Container(
                                                                height: 145.0,
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              greyColor,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(5.0))),
                                                                      height:
                                                                          5.0,
                                                                      width:
                                                                          150.0,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15.0,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        _scaffoldKey
                                                                            .currentState
                                                                            .hideCurrentSnackBar();
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => UserPage(site: _allSitesData[index])));
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 10.0),
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              AmazingIcon.repeat_2_line,
                                                                              size: 15.0,
                                                                              color: gradient1,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 20.0),
                                                                              child: Text(
                                                                                'Mon Personnel',
                                                                                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              10.0),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            AmazingIcon.edit_2_line,
                                                                            size:
                                                                                15.0,
                                                                            color:
                                                                                gradient1,
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _scaffoldKey.currentState.hideCurrentSnackBar();
                                                                              _updateSite(_sites[index]);
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20.0),
                                                                              child: Text(
                                                                                'Modifier',
                                                                                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        _scaffoldKey
                                                                            .currentState
                                                                            .hideCurrentSnackBar();
                                                                        _deleteSite(
                                                                            index);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 10.0),
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              AmazingIcon.delete_bin_6_line,
                                                                              size: 15.0,
                                                                              color: redColor,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 20.0),
                                                                              child: Text(
                                                                                'Supprimer',
                                                                                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),
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
                                                            color:
                                                                Colors.black54,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: screenSize(context)
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
                                                      width: screenSize(context)
                                                              .width /
                                                          70,
                                                    ),
                                                    Text(
                                                      '${_sites[index].town}, Cameroun',
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: screenSize(
                                                                      context)
                                                                  .height /
                                                              38.0),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: screenSize(context)
                                                          .height /
                                                      40.0,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: screenSize(context)
                                                              .width /
                                                          80),
                                                  child: Text(
                                                    'Disponible',
                                                    style: TextStyle(
                                                        color: gradient1,
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
                        height: screenSize(context).height * .86,
                        color: Colors.transparent,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation(gradient1),
                          ),
                        ),
                      );
                    }),
              ],
            ),
            _isLoading
                ? Container(
                    height: screenSize(context).height,
                    color: Colors.white.withOpacity(.9),
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
      )),
    );
  }
}