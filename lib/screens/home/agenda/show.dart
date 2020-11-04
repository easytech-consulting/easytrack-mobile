import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/commons/gradientIcon.dart';
import 'package:easytrack/icons/amazingIcon.dart';
import 'package:easytrack/models/role.dart';
import 'package:easytrack/models/user.dart';
import 'package:easytrack/services/agendaService.dart';
import 'package:easytrack/services/siteService.dart';
import 'package:easytrack/styles/style.dart';
import 'package:flutter/material.dart';

class ShowAgendaDayPage extends StatefulWidget {
  final String day;
  final int id;
  final int siteId;

  const ShowAgendaDayPage(
      {Key key, @required this.day, @required this.id, @required this.siteId})
      : super(key: key);
  @override
  _ShowAgendaDayPageState createState() => _ShowAgendaDayPageState();
}

class _ShowAgendaDayPageState extends State<ShowAgendaDayPage> {
  GlobalKey _scaffoldKey, _formKey;
  bool _isLoading;
  List _teams,
      employees,
      employeesInTeam = [],
      rolesInTeam = [],
      _userRoles,
      allEmployees,
      allRoles;
  OverlayEntry _entry;
  int selectedIndex;
  Future _futureTeams;

  _show(team) {
    setState(() {
      this._entry = this._createEntry(team);
      Overlay.of(context).insert(this._entry);
    });
  }

  OverlayEntry _createEntry(team) {
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
                      onTap: () => this._entry.remove(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: myWidth(context) / 7,
                                  height: myHeight(context) / 150.0,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(
                                          myHeight(context) / 100.0))),
                            ),
                            SizedBox(
                              height: myHeight(context) / 60,
                            ),
                            InkWell(
                              onTap: () {
                                this._entry.remove();
                                _showTeam(team);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.visibility,
                                      size: myHeight(context) / 30.0,
                                      color: gradient1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: myHeight(context) / 25.0),
                                      child: Text(
                                        'Afficher l\'equipe',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: myHeight(context) / 40.0,
                                            color: textInverseModeColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              /* onTap: () {
                                this._entry.remove();
                                this._editTeam(team);
                              }, */
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      AmazingIcon.edit_2_line,
                                      size: myHeight(context) / 30.0,
                                      color: gradient1,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: myHeight(context) / 25.0),
                                      child: Text(
                                        'Modifier',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: myHeight(context) / 40.0,
                                            color: textInverseModeColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                this._entry.remove();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      AmazingIcon.delete_bin_6_line,
                                      size: myHeight(context) / 30.0,
                                      color: Colors.red,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: myHeight(context) / 25.0),
                                      child: Text(
                                        'Supprimer',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: myHeight(context) / 40.0,
                                            color: textInverseModeColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }

  _showTeam(team) {
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
              width: myWidth(context) * .8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(myHeight(context) / 70.0))),
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: myWidth(context) / 2,
                          child: Text(
                            'Heure d\'arrivee',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: myHeight(context) / 50,
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(AmazingIcon.close_line))
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        team['start'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: myHeight(context) / 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight(context) / 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Heure de depart',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: myHeight(context) / 50,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        team['end'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: myHeight(context) / 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight(context) / 38.0,
                    ),
                    Expanded(
                        child: Container(
                      child: ListView.builder(
                        itemCount: team['users'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: myHeight(context) / 60.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black12))),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: gradient1.withOpacity(.1),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        myHeight(context) / 60.0),
                                    child: Text(
                                      '${team["users"][index]["name"].substring(0, 2).toUpperCase()}',
                                      style: TextStyle(
                                          color: gradient1,
                                          fontWeight: FontWeight.w600,
                                          fontSize: myHeight(context) / 55.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: myWidth(context) / 50.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: myWidth(context) / 2.5,
                                      child: Text(
                                        team['users'][index]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: textInverseModeColor,
                                            fontSize: myHeight(context) / 40.0),
                                      ),
                                    ),
                                    Container(
                                      width: myWidth(context) / 2.5,
                                      child: Text(
                                        'Employee',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: textInverseModeColor
                                                .withOpacity(.38),
                                            fontSize: myHeight(context) / 50.0),
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                index == 0
                                    ? GradientIcon(
                                        AmazingIcon.check_fill,
                                        myHeight(context) / 30.0,
                                        LinearGradient(
                                            colors: [gradient1, gradient2]))
                                    : Container(
                                        height: 0.0,
                                      )
                              ],
                            ),
                          );
                        },
                      ),
                    )),
                  ],
                );
              })),
        ));
  }

  employeeListDialog() {
    selectedIndex = 0;
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
              width: myWidth(context) * .8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(myHeight(context) / 70.0))),
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: myWidth(context) / 2,
                          child: Text(
                            'Employes',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: myHeight(context) / 30,
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(AmazingIcon.close_line))
                      ],
                    ),
                    SizedBox(
                      height: myHeight(context) / 38.0,
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: myHeight(context) / 50.0),
                      child: employees == null || employees.length == 0
                          ? Center(child: Text('Aucun employee'))
                          : ListView.builder(
                              itemCount: employees.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: myHeight(context) / 60.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black12))),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: gradient1.withOpacity(.1),
                                              shape: BoxShape.circle),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                myHeight(context) / 60.0),
                                            child: Text(
                                              '${employees[index].name.substring(0, 2).toUpperCase()}',
                                              style: TextStyle(
                                                  color: gradient1,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      myHeight(context) / 55.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: myWidth(context) / 50.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: myWidth(context) / 2.5,
                                              child: Text(
                                                employees[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: textInverseModeColor,
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0),
                                              ),
                                            ),
                                            Container(
                                              width: myWidth(context) / 2.5,
                                              child: Text(
                                                _userRoles[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: textInverseModeColor
                                                        .withOpacity(.38),
                                                    fontSize:
                                                        myHeight(context) /
                                                            50.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        index == selectedIndex
                                            ? GradientIcon(
                                                AmazingIcon.check_fill,
                                                myHeight(context) / 30.0,
                                                LinearGradient(colors: [
                                                  gradient1,
                                                  gradient2
                                                ]))
                                            : Container(
                                                height: 0.0,
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    )),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          employeesInTeam.add(employees[selectedIndex]);
                          rolesInTeam.add(_userRoles[selectedIndex]);
                          employees.removeAt(selectedIndex);
                          _userRoles.removeAt(selectedIndex);
                        });
                        _createTeam();
                      },
                      child: Container(
                          height: myHeight(context) / 20.0,
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
                                'Ajouter l\'employe',
                                style: TextStyle(
                                    color: textSameModeColor,
                                    fontSize: myHeight(context) / 40.0),
                              ),
                            ),
                          )),
                    )
                  ],
                );
              })),
        ));
  }

  _editTeam(team) {
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: myHeight(context) / 30,
                  horizontal: myHeight(context) / 25),
              height: myHeight(context) * .9,
              width: myWidth(context) * .9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(myHeight(context) / 70.0))),
              child: StatefulBuilder(builder: (context, setState) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: myWidth(context) / 2,
                            child: Text(
                              'Modifier l\'equipe',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: myHeight(context) / 30,
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(AmazingIcon.close_line))
                        ],
                      ),
                      SizedBox(
                        height: myHeight(context) / 38.0,
                      ),
                      Container(
                        height: myHeight(context) / 17.0,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(
                                myHeight(context) / 10.0)),
                        child: TextFormField(
                          style: TextStyle(fontSize: myHeight(context) / 42.0),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: myHeight(context) / 32.0,
                              ),
                              hintText: team['start'],
                              hintStyle:
                                  TextStyle(fontSize: myHeight(context) / 42.0),
                              contentPadding: EdgeInsets.only(
                                  left: myHeight(context) / 30.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(
                        height: myHeight(context) / 50.0,
                      ),
                      Container(
                        height: myHeight(context) / 17.0,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(
                                myHeight(context) / 10.0)),
                        child: TextFormField(
                          style: TextStyle(fontSize: myHeight(context) / 42.0),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: myHeight(context) / 32.0,
                              ),
                              hintText: team['end'],
                              hintStyle:
                                  TextStyle(fontSize: myHeight(context) / 42.0),
                              contentPadding: EdgeInsets.only(
                                  left: myHeight(context) / 30.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(
                        height: myHeight(context) / 31.0,
                      ),
                      Row(
                        children: [
                          Text(
                            'Employes',
                            style:
                                TextStyle(fontSize: myHeight(context) / 46.0),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => this.employeeListDialog(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: myHeight(context) / 50.0,
                                  color: gradient1,
                                ),
                                SizedBox(
                                  width: myWidth(context) / 80.0,
                                ),
                                Text(
                                  'Ajouter',
                                  style: TextStyle(
                                      color: gradient1,
                                      fontSize: myHeight(context) / 46.0),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: myHeight(context) / 50.0),
                        child: ListView.builder(
                          itemCount: team['users'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: myHeight(context) / 60.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black12))),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: gradient1.withOpacity(.1),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          myHeight(context) / 60.0),
                                      child: Text(
                                        '${team["users"][index]["name"].substring(0, 2).toUpperCase()}',
                                        style: TextStyle(
                                            color: gradient1,
                                            fontWeight: FontWeight.w600,
                                            fontSize: myHeight(context) / 55.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: myWidth(context) / 50.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: myWidth(context) / 2.5,
                                        child: Text(
                                          team['users'][index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: textInverseModeColor,
                                              fontSize:
                                                  myHeight(context) / 40.0),
                                        ),
                                      ),
                                      Container(
                                        width: myWidth(context) / 2.5,
                                        child: Text(
                                          'Employee',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: textInverseModeColor
                                                  .withOpacity(.38),
                                              fontSize:
                                                  myHeight(context) / 50.0),
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    child: Icon(
                                      AmazingIcon.delete_bin_6_line,
                                      size: myHeight(context) / 30.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            height: myHeight(context) / 20.0,
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

  _fetchEmployee(id) async {
    setState(() {
      _isLoading = true;
    });
    await fetchEmployeesOfSite(id).then((value) {
      setState(() {
        _isLoading = false;
      });

      allEmployees =
          value['employees'].map((e) => User.fromJson(e['user'])).toList();
      allRoles = value['employees']
          .map((e) => Role.fromJson(e['user']['role']))
          .toList();
      employees = allEmployees;
      _userRoles = allRoles;
    });
    _createTeam();
  }

  _createTeam() {
    print(allEmployees);
    showDialog(
        context: context,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: myHeight(context) / 30,
                  horizontal: myHeight(context) / 25),
              height: myHeight(context) * .9,
              width: myWidth(context) * .9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(myHeight(context) / 70.0))),
              child: StatefulBuilder(builder: (context, setState) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: myWidth(context) / 2,
                            child: Text(
                              'Nouvelle equipe',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: myHeight(context) / 30,
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  employeesInTeam = [];
                                  rolesInTeam = [];
                                  employees = allEmployees;
                                  _userRoles = allRoles;
                                });
                                Navigator.pop(context);
                              },
                              child: Icon(AmazingIcon.close_line))
                        ],
                      ),
                      SizedBox(
                        height: myHeight(context) / 38.0,
                      ),
                      Container(
                        height: myHeight(context) / 17.0,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(
                                myHeight(context) / 10.0)),
                        child: TextFormField(
                          style: TextStyle(fontSize: myHeight(context) / 42.0),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: myHeight(context) / 32.0,
                              ),
                              hintText: 'Heure d\'arrivee',
                              hintStyle:
                                  TextStyle(fontSize: myHeight(context) / 42.0),
                              contentPadding: EdgeInsets.only(
                                  left: myHeight(context) / 30.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(
                        height: myHeight(context) / 50.0,
                      ),
                      Container(
                        height: myHeight(context) / 17.0,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(
                                myHeight(context) / 10.0)),
                        child: TextFormField(
                          style: TextStyle(fontSize: myHeight(context) / 42.0),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.access_time,
                                color: Colors.black,
                                size: myHeight(context) / 32.0,
                              ),
                              hintText: 'Heure de depart',
                              hintStyle:
                                  TextStyle(fontSize: myHeight(context) / 42.0),
                              contentPadding: EdgeInsets.only(
                                  left: myHeight(context) / 30.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      SizedBox(
                        height: myHeight(context) / 31.0,
                      ),
                      Row(
                        children: [
                          Text(
                            'Employes',
                            style:
                                TextStyle(fontSize: myHeight(context) / 46.0),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              this.employeeListDialog();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: myHeight(context) / 50.0,
                                  color: gradient1,
                                ),
                                SizedBox(
                                  width: myWidth(context) / 80.0,
                                ),
                                Text(
                                  'Ajouter',
                                  style: TextStyle(
                                      color: gradient1,
                                      fontSize: myHeight(context) / 46.0),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: myHeight(context) / 50.0),
                        child: employeesInTeam == null ||
                                employeesInTeam.length == 0
                            ? Center(child: Text('Aucun employe'))
                            : ListView.builder(
                                itemCount: employeesInTeam.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: myHeight(context) / 60.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black12))),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: gradient1.withOpacity(.1),
                                              shape: BoxShape.circle),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                myHeight(context) / 60.0),
                                            child: Text(
                                              '${employeesInTeam[index].name.substring(0, 2).toUpperCase()}',
                                              style: TextStyle(
                                                  color: gradient1,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      myHeight(context) / 55.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: myWidth(context) / 50.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: myWidth(context) / 2.5,
                                              child: Text(
                                                employeesInTeam[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: textInverseModeColor,
                                                    fontSize:
                                                        myHeight(context) /
                                                            40.0),
                                              ),
                                            ),
                                            Container(
                                              width: myWidth(context) / 2.5,
                                              child: Text(
                                                _userRoles[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: textInverseModeColor
                                                        .withOpacity(.38),
                                                    fontSize:
                                                        myHeight(context) /
                                                            50.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Icon(
                                          AmazingIcon.delete_bin_6_line,
                                          size: myHeight(context) / 30.0,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      )),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            height: myHeight(context) / 20.0,
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

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _formKey = GlobalKey<FormState>();
    _isLoading = false;
    _futureTeams = fetchTeamsDay(widget.id, widget.siteId);
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
                  future: _futureTeams,
                  builder: (context, snapshot) {
                    _teams = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            primary: true,
                            backgroundColor: gradient1,
                            flexibleSpace: Container(
                              height: 100.0,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [gradient1, gradient2],
                                      begin: Alignment.center,
                                      end: Alignment.bottomRight)),
                            ),
                            automaticallyImplyLeading: false,
                            title: Row(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: myHeight(context) / 35.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: myHeight(context) / 50.0,
                                ),
                                Text(
                                  widget.day,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: myHeight(context) / 40.0),
                                )
                              ],
                            ),
                            bottom: PreferredSize(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    myHeight(context) / 36.0,
                                    0.0,
                                    myHeight(context) / 36.0,
                                    myHeight(context) / 50.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Agenda',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: myHeight(context) / 28.0),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                        /* onTap: () => employees == null
                                            ? _fetchEmployee(widget.siteId)
                                            : _createTeam(),
                                         */child: Icon(
                                          Icons.add,
                                          size: myHeight(context) / 24.0,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ),
                              preferredSize:
                                  Size.fromHeight(myHeight(context) / 20.0),
                            ),
                          ),
                          _teams == null || _teams.length == 0
                              ? SliverList(
                                  delegate: SliverChildListDelegate.fixed([
                                    Container(
                                      height: myHeight(context) / 1.5,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Aucune equipe',
                                        style: TextStyle(
                                            fontSize: myHeight(context) / 50.0),
                                      ),
                                    )
                                  ]),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(
                                          myHeight(context) / 30.0,
                                          0,
                                          myHeight(context) / 30.0,
                                          0),
                                      padding: EdgeInsets.symmetric(
                                          vertical: myHeight(context) / 50.0),
                                      height: myHeight(context) / 6.2,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black
                                                      .withOpacity(.1)))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: _teams[index]
                                                                  ['users']
                                                              .length >
                                                          5
                                                      ? 5
                                                      : _teams[index]['users']
                                                          .length,
                                                  itemBuilder:
                                                      (context, indexUser) {
                                                    return index < 5
                                                        ? Container(
                                                            margin: EdgeInsets.only(
                                                                right: myWidth(
                                                                        context) /
                                                                    50.0),
                                                            decoration: BoxDecoration(
                                                                color: gradient1
                                                                    .withOpacity(
                                                                        .1),
                                                                shape: BoxShape
                                                                    .circle),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(myHeight(
                                                                          context) /
                                                                      50.0),
                                                              child: Text(
                                                                '${_teams[index]["users"][indexUser]["name"].substring(0, 2).toUpperCase()}',
                                                                style: TextStyle(
                                                                    color:
                                                                        gradient1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            45.0),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            padding: EdgeInsets.only(
                                                                right: myWidth(
                                                                        context) /
                                                                    80.0),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .05),
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(myHeight(
                                                                          context) /
                                                                      50.0),
                                                              child: Text(
                                                                '+${_teams[index]["users"].length - 4}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        myHeight(context) /
                                                                            45.0),
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                  /* children: [
                                                    
                                                    /* Container(
                                                      decoration: BoxDecoration(
                                                          color: gradient1
                                                              .withOpacity(.1),
                                                          shape: BoxShape.circle),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            myHeight(context) / 50.0),
                                                        child: Text(
                                                          '${user.name.substring(0, 2).toUpperCase()}',
                                                          style: TextStyle(
                                                              color: gradient1,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize:
                                                                  myHeight(context) /
                                                                      45.0),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: myWidth(context) / 80.0,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: gradient1
                                                              .withOpacity(.1),
                                                          shape: BoxShape.circle),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            myHeight(context) / 50.0),
                                                        child: Text(
                                                          '${user.name.substring(0, 2).toUpperCase()}',
                                                          style: TextStyle(
                                                              color: gradient1,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize:
                                                                  myHeight(context) /
                                                                      45.0),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: myWidth(context) / 80.0,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: gradient1
                                                              .withOpacity(.1),
                                                          shape: BoxShape.circle),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            myHeight(context) / 50.0),
                                                        child: Text(
                                                          '${user.name.substring(0, 2).toUpperCase()}',
                                                          style: TextStyle(
                                                              color: gradient1,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize:
                                                                  myHeight(context) /
                                                                      45.0),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: myWidth(context) / 80.0,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(.05),
                                                          shape: BoxShape.circle),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            myHeight(context) / 50.0),
                                                        child: Text(
                                                          '+5',
                                                          style: TextStyle(
                                                              color: Colors.black45,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize:
                                                                  myHeight(context) /
                                                                      45.0),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: myWidth(context) / 80.0,
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                        onTap: () => _show(0),
                                                        child: Icon(
                                                            AmazingIcon.more_2_fill))
                                                   */
                                                  ],
                                                 */
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  bottom: 0,
                                                  child: GestureDetector(
                                                      onTap: () =>
                                                          _show(_teams[index]),
                                                      child: Icon(AmazingIcon
                                                          .more_2_fill)),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: myHeight(context) / 50.0,
                                          ),
                                          Text(
                                            '${_teams[index]["start"]} - ${_teams[index]["end"]}',
                                            style: TextStyle(
                                                fontSize:
                                                    myHeight(context) / 41.0),
                                          )
                                        ],
                                      ),
                                    );
                                  }, childCount: _teams.length),
                                )
                        ],
                      );
                    }
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          primary: true,
                          backgroundColor: gradient1,
                          flexibleSpace: Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [gradient1, gradient2],
                                    begin: Alignment.center,
                                    end: Alignment.bottomRight)),
                          ),
                          automaticallyImplyLeading: false,
                          title: Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: myHeight(context) / 35.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: myHeight(context) / 50.0,
                              ),
                              Text(
                                widget.day,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: myHeight(context) / 40.0),
                              )
                            ],
                          ),
                          bottom: PreferredSize(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  myHeight(context) / 36.0,
                                  0.0,
                                  myHeight(context) / 36.0,
                                  myHeight(context) / 50.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Agenda',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: myHeight(context) / 28.0),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      child: Icon(
                                    Icons.add,
                                    size: myHeight(context) / 24.0,
                                    color: Colors.white,
                                  ))
                                ],
                              ),
                            ),
                            preferredSize:
                                Size.fromHeight(myHeight(context) / 20.0),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            Container(
                                height: myHeight(context) / 1.5,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(gradient1),
                                ))
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
