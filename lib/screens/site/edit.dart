import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/screens/site/all.dart';
import 'package:easytrack/services/siteService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class EditSite extends StatefulWidget {
  final Site site;
  EditSite({this.site});

  @override
  _EditSiteState createState() => _EditSiteState();
}

class _EditSiteState extends State<EditSite> {
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

  _attemptConnection() async {
    Map<String, dynamic> _params = Map();
    _params['name'] = _sitestreetController.text.isEmpty
        ? "$snack ${widget.site.street}"
        : "$snack ${_siteemailController.text}";
    _params['email'] = _siteemailController.text.isEmpty
        ? widget.site.email
        : _siteemailController.text;
    _params['town'] = _sitetownController.text.isEmpty
        ? widget.site.town
        : _sitetownController.text;
    _params['street'] = _sitestreetController.text.isEmpty
        ? widget.site.street
        : _sitestreetController.text;
    _params['tel1'] = _sitephone1Controller.text.isEmpty
        ? widget.site.tel1
        : _sitephone1Controller.text;
    _params['tel2'] = _sitephone2Controller.text.isEmpty
        ? widget.site.tel2
        : _sitephone2Controller.text;

    await updateSite(_params, widget.site.id).then((site) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SitePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back,
            color: Colors.transparent,
          ),
          centerTitle: true,
          title: Text(
            'Mise a jour',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(top: screenSize(context).height / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 50.0),
                          prefixIcon: Icon(AmazingIcon.at_line,
                              color: Color(0xff000000), size: 15.0),
                          hintText: '${widget.site.email}',
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
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 50.0),
                          prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                              color: Color(0xff000000), size: 15.0),
                          hintText: '${widget.site.town}',
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
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 50.0),
                          prefixIcon: Icon(AmazingIcon.map_pin_2_line,
                              color: Color(0xff000000), size: 15.0),
                          hintText: '${widget.site.street}',
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
                      onFieldSubmitted: (_) =>
                          nextNode(context, _sitephone1Node, _sitephone2Node),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 50.0),
                          prefixIcon: Icon(AmazingIcon.phone_line,
                              color: Color(0xff000000), size: 15.0),
                          hintText: '${widget.site.tel1}',
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
                      onFieldSubmitted: (_) {
                        _sitephone2Node.unfocus();
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 50.0),
                          prefixIcon: Icon(AmazingIcon.phone_line,
                              color: Color(0xff000000), size: 15.0),
                          hintText: '${widget.site.tel2}',
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
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize(context).height / 31.0,
                ),
                child: InkWell(
                  onTap: () => _attemptConnection(),
                  child: Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [gradient1, gradient2])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            'continuer',
                            style: TextStyle(
                                color: Color(0xffffffff), fontSize: 18),
                          ),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenSize(context).height / 31.0,
                ),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      height: 45.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff000000)),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: Center(
                          child: Text(
                            'Retour',
                            style: TextStyle(
                                color: Color(0xff000000), fontSize: 18),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
