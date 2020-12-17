import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/services/externalService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class SubSearchSites extends StatelessWidget {
  final List data;
  SubSearchSites(this.data);
  _showDetails(context, Site _site) {
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
                      height: myHeight(context) / 20.0,
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

  @override
  Widget build(BuildContext context) {
    List _sites = data.map((site) => Site.fromJson(site)).toList();
    return data == null
        ? Center(
            child: Text('Aucune valeur'),
          )
        : data.isEmpty
            ? Center(child: Text('Vide'))
            : ListView.builder(
                itemCount: _sites.length,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: index == 0
                            ? myHeight(context) / 50.0
                            : myHeight(context) / 100.0,
                        horizontal: myHeight(context) / 40.0),
                    child: Container(
                        height: myHeight(context) / 6.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(myHeight(context) / 70.0)),
                            border: Border.all(color: Colors.black12)),
                        child: Padding(
                          padding: EdgeInsets.all(myHeight(context) / 60.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => _showDetails(
                                      context,
                                      _sites[index],
                                    ),
                                    child: Container(
                                      width: myWidth(context) / 1.4,
                                      child: Text(
                                        '${capitalize(_sites[index].street)}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                screenSize(context).height / 35,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                      child: Icon(
                                    AmazingIcon.more_2_fill,
                                    size: 25.0,
                                    color: Colors.black,
                                  ))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.map_pin_2_line,
                                    color: Colors.black54,
                                    size: myHeight(context) / 40.0,
                                  ),
                                  SizedBox(
                                    width: screenSize(context).width / 40,
                                  ),
                                  Text(
                                    '${_sites[index].town}, Cameroun',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize:
                                            screenSize(context).height / 42.0),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    AmazingIcon.phone_line,
                                    color: Colors.black54,
                                    size: myHeight(context) / 40.0,
                                  ),
                                  SizedBox(
                                    width: screenSize(context).width / 40,
                                  ),
                                  Text(
                                    '${_sites[index].tel1}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize:
                                            screenSize(context).height / 42.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))),
              );
  }
}
