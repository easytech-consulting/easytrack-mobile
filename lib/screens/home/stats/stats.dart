import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/screens/home/stats/statsAdmin.dart';
import 'package:easytrack/screens/home/stats/statsUser.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user.isAdmin == 2 ? StatsAdminPage() : StatEmployee();
  }
}
