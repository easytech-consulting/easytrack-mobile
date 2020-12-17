import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/header.dart';
import 'package:easytrack/data.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/screens/customers/all.dart';
import 'package:easytrack/screens/suppliers/all.dart';
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
  bool _valueHasChange;
  List _sites, _allSitesData;
  var _formKey;
  bool _isLoading;
  GlobalKey<ScaffoldState> _scaffoldKey;

  TextEditingController _sitenameController;
  TextEditingController _siteemailController;
  TextEditingController _sitetownController;
  TextEditingController _sitestreetController;
  TextEditingController _sitephone1Controller;
  TextEditingController _sitephone2Controller;

  FocusNode _sitenameNode;
  FocusNode _siteemailNode;
  FocusNode _sitetownNode;
  FocusNode _sitestreetNode;
  FocusNode _sitephone1Node;
  FocusNode _sitephone2Node;

  OverlayEntry _overlay;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _companySites = fetchSiteOfCompany();
    _scaffoldKey = GlobalKey();
    _valueHasChange = false;
    _isLoading = false;
    _sitenameController = new TextEditingController();
    _siteemailController = new TextEditingController();
    _sitetownController = new TextEditingController();
    _sitestreetController = new TextEditingController();
    _sitephone1Controller = new TextEditingController();
    _sitephone2Controller = new TextEditingController();
    _sitenameNode = new FocusNode();
    _siteemailNode = new FocusNode();
    _sitetownNode = new FocusNode();
    _sitestreetNode = new FocusNode();
    _sitephone1Node = new FocusNode();
    _sitephone2Node = new FocusNode();
    _allSitesData = globalSites;
    _sites = _allSitesData.map((site) => Site.fromJson(site)).toList();
  }

  _attemptUpdate(Site site) async {
    Map<String, dynamic> _params = Map();
    _params['name'] =
        _sitenameController.text.isEmpty ? site.name : _sitenameController.text;
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
        _valueHasChange = true;
        _companySites = fetchSiteOfCompany();
      });
    });
  }

  _deleteSite(int index) {
    _showConfirmationMessage(index);
  }

  _show(index) {
    setState(() {
      this._overlay = this._createOverlayEntry(index);
      Overlay.of(context).insert(this._overlay);
    });
  }

  _createOverlayEntry(index) {
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
                    height: myHeight(context) * .35,
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomerPage(
                                          sitename: _allSitesData[index]
                                              ['name'],
                                          data: _allSitesData[index]
                                              ['customers'])));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.user_star_line,
                                    size: 15.0,
                                    color: gradient1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Mes clients',
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
                          InkWell(
                            onTap: () {
                              this._overlay.remove();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupplierPage(
                                          sitename: _allSitesData[index]
                                              ['name'],
                                          data: _allSitesData[index]
                                              ['suppliers'])));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.user_received_line,
                                    size: 15.0,
                                    color: gradient1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Mes fournisseurs',
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
                          InkWell(
                            onTap: () {
                              this._overlay.remove();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserPage(
                                          site: _allSitesData[index])));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.group_line,
                                    size: 15.0,
                                    color: gradient1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Mon Personnel',
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
                                  AmazingIcon.edit_2_line,
                                  size: 15.0,
                                  color: gradient1,
                                ),
                                InkWell(
                                  onTap: () {
                                    this._overlay.remove();
                                    _updateSite(_sites[index]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Modifier',
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
                              _deleteSite(_sites[index].id);
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

  _showDetails(Site _site) {
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
                        '${_site.street}',
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
                    Text(
                      '${_site.street}, ${_site.town}',
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
                  child: Row(
                    children: <Widget>[
                      Icon(
                        AmazingIcon.phone_line,
                      ),
                      SizedBox(
                        width: myWidth(context) / 50,
                      ),
                      Text(
                        _site.tel2 == null ? '${_site.tel1}' : '${_site.tel2}',
                        style: TextStyle(
                            color: textInverseModeColor.withOpacity(.54),
                            fontSize: myHeight(context) / 38.0),
                      ),
                    ],
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
                  height: myHeight(context) / 40.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Snack',
                      style: TextStyle(
                          color: textInverseModeColor.withOpacity(.54),
                          fontSize: myHeight(context) / 38.0),
                    ),
                    SizedBox(
                      width: myWidth(context) / 50,
                    ),
                    Text(
                      '${company.name}',
                      style: TextStyle(
                          fontSize: myHeight(context) / 33,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Nom',
                      style: TextStyle(
                          color: textInverseModeColor.withOpacity(.54),
                          fontSize: myHeight(context) / 38.0),
                    ),
                    SizedBox(
                      width: myHeight(context) / 10,
                    ),
                    Text(
                      '${_site.name}',
                      style: TextStyle(
                          fontSize: myHeight(context) / 33,
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
                            color: textInverseModeColor.withOpacity(.54),
                            fontSize: myHeight(context) / 38.0),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        _site.tel2 == null ? '${_site.tel1}' : '${_site.tel2}',
                        style: TextStyle(
                            fontSize: myHeight(context) / 33,
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
                            color: textInverseModeColor.withOpacity(.54),
                            fontSize: myHeight(context) / 38.0),
                      ),
                      SizedBox(
                        width: myWidth(context) / 50,
                      ),
                      Text(
                        '${_site.email}',
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
                  onTap: () => launchCall(_site.tel1),
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
                            style: TextStyle(
                                color: textSameModeColor, fontSize: 18),
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
    _params['name'] = _sitenameController.text;
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
        _valueHasChange = true;
        _companySites = fetchSiteOfCompany();
      });
    });
  }

  _createSite() {
    _sitenameController.clear();
    _siteemailController.clear();
    _sitephone1Controller.clear();
    _sitephone2Controller.clear();
    _sitestreetController.clear();
    _sitetownController.clear();
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
                              'Nouveau site',
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
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: myHeight(context) / 20,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: _sitenameController,
                              focusNode: _sitenameNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitenameNode, _siteemailNode),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Champs obligatoire';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.community_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: 'Nom du site',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _siteemailController,
                              focusNode: _siteemailNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _siteemailNode, _sitetownNode),
                              validator: (value) => checkEmailValidity(value),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.at_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: 'Email du site',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitetownController,
                              focusNode: _sitetownNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitetownNode, _sitestreetNode),
                              validator: (String value) {
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
                                  hintText: 'Ville du site',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitestreetController,
                              focusNode: _sitestreetNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitestreetNode, _sitephone1Node),
                              validator: (String value) {
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
                                  hintText: 'Rue du site',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitephone1Controller,
                              focusNode: _sitephone1Node,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitephone1Node, _sitephone2Node),
                              validator: (value) => checkNumberValidity(value),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.phone_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: 'Telephone No 1',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitephone2Controller,
                              focusNode: _sitephone2Node,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (_) {
                                _sitephone2Node.unfocus();
                              },
                              validator: (value) =>
                                  checkNumberValidity(value, canBeEmpty: true),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.phone_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: 'Telephone No 2',
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

  _updateSite(Site site) {
    _sitenameController.clear();
    _siteemailController.clear();
    _sitephone1Controller.clear();
    _sitephone2Controller.clear();
    _sitestreetController.clear();
    _sitetownController.clear();
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
                              '${site.street}',
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
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: myHeight(context) / 20,
                              decoration:
                                  buildTextFormFieldContainer(decorationColor),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: _sitenameController,
                              focusNode: _sitenameNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitenameNode, _siteemailNode),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.community_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: '${site.name}',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _siteemailController,
                              focusNode: _siteemailNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _siteemailNode, _sitetownNode),
                              validator: (value) =>
                                  checkEmailValidity(value, canBeEmpty: true),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.at_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: '${site.email}',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitetownController,
                              focusNode: _sitetownNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitetownNode, _sitestreetNode),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: '${site.town}',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitestreetController,
                              focusNode: _sitestreetNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitestreetNode, _sitephone1Node),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: '${site.street}',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitephone1Controller,
                              focusNode: _sitephone1Node,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (_) => nextNode(
                                  context, _sitephone1Node, _sitephone2Node),
                              validator: (value) =>
                                  checkNumberValidity(value, canBeEmpty: true),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.phone_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: '${site.tel1}',
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
                          Container(
                            height: myHeight(context) / 20,
                            decoration:
                                buildTextFormFieldContainer(decorationColor),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextFormField(
                              controller: _sitephone2Controller,
                              focusNode: _sitephone2Node,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (_) {
                                _sitephone2Node.unfocus();
                              },
                              validator: (value) =>
                                  checkNumberValidity(value, canBeEmpty: true),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 50.0),
                                  prefixIcon: Icon(AmazingIcon.phone_line,
                                      color: textInverseModeColor, size: 15.0),
                                  hintText: '${site.tel2}',
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
                            _attemptUpdate(site);
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
                                  'Sauvegarder',
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
    Navigator.pop(context);
    setState(() {
      _isLoading = true;
    });
    await deleteSite(id).then((site) {
      setState(() {
        _valueHasChange = true;
        _isLoading = false;
        _companySites = fetchSiteOfCompany();
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
                        'Vous allez supprimer le site ${index + 1}.',
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
                !_valueHasChange
                    ? CustomScrollView(
                        slivers: [
                          sliverHeader(context, 'Gestion', 'Mes sites',
                              canAdd: true, onClick: _createSite),
                          _sites == null || _sites.length == 0
                              ? SliverList(
                                  delegate: SliverChildListDelegate.fixed([
                                    Container(
                                      height: myHeight(context) / 1.5,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Aucun site',
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
                                                          _sites[index],
                                                        ),
                                                        child: Container(
                                                          width:
                                                              myWidth(context) /
                                                                  1.4,
                                                          child: Text(
                                                            '${capitalize(_sites[index].street)}',
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
                                                          onTap: () =>
                                                              _show(index),
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
                                                        '${_sites[index].town}, Cameroun',
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
                                                        AmazingIcon.phone_line,
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
                                                        '${_sites[index].tel1}',
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
                                  }, childCount: _sites.length),
                                )
                        ],
                      )
                    : FutureBuilder(
                        future: _companySites,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            _allSitesData = snapshot.data;
                            _sites = _allSitesData
                                .map((site) => Site.fromJson(site))
                                .toList();

                            globalSites = _allSitesData;
                            return CustomScrollView(
                              slivers: [
                                sliverHeader(context, 'Gestion', 'Mes sites',
                                    canAdd: true, onClick: _createSite),
                                _sites == null || _sites.length == 0
                                    ? SliverList(
                                        delegate:
                                            SliverChildListDelegate.fixed([
                                          Container(
                                            height: myHeight(context) / 1.5,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Aucun site',
                                              style: TextStyle(
                                                  fontSize:
                                                      myHeight(context) / 50.0),
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
                                                      : myHeight(context) /
                                                          100.0,
                                                  horizontal:
                                                      myHeight(context) / 40.0),
                                              child: Container(
                                                  height:
                                                      myHeight(context) / 6.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
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
                                                              onTap: () =>
                                                                  _showDetails(
                                                                _sites[index],
                                                              ),
                                                              child: Container(
                                                                width: myWidth(
                                                                        context) /
                                                                    1.4,
                                                                child: Text(
                                                                  '${capitalize(_sites[index].street)}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          screenSize(context).height /
                                                                              35,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                                onTap: () =>
                                                                    _show(
                                                                        index),
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
                                                              '${_sites[index].town}, Cameroun',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      screenSize(context)
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
                                                              '${_sites[index].tel1}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      screenSize(context)
                                                                              .height /
                                                                          42.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )));
                                        }, childCount: _sites.length),
                                      )
                              ],
                            );
                          }
                          return CustomScrollView(
                            slivers: [
                              sliverHeader(context, 'Gestion', 'Mes sites',
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
