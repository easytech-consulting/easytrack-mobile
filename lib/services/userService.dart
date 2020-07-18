import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/models/role.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/snack.dart';
import 'package:easytrack/models/user.dart';
import 'package:http/http.dart' as http;

Future<User> fetchUserDetails(int id) async {
  bool _linkToSite = false;
  try {
    final response = await http.get('$endPoint/users/$id',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      final data = res['data'];
      user = User.fromJson(data);
      userRoles =
          data['roles'].map((role) => Role.fromJson(role).slug).toList();
      if (data['site'] != null) {
        _linkToSite = true;
        site = Site.fromJson(data['site']);
        snack = Snack.fromJson(data['site']['snack']);
      }
      storeUserDetails(data, _linkToSite);
      return user;
    }

    throw Exception('fetchUserDetails exited with ${response.statusCode}');
  } catch (ex) {
    throw Exception('fetchUserDetails with error $ex');
  }
}

Future fetchUniques() async {
  try {
    final response = await http.get('$endPoint/uniques');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      return res['data'];
    }

    throw Exception('fetchUniques exited with ${response.statusCode}');
  } catch (ex) {
    throw Exception('fetchUniques with error $ex');
  }
}
