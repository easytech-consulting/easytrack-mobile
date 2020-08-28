import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/models/site.dart';
import 'package:easytrack/models/company.dart';
import 'package:easytrack/models/user.dart';
import 'package:http/http.dart' as http;

Future<User> fetchUserDetails(int id) async {
  company = new Company();
  user = new User();
  userRole = new Map();
  site = new Site();
  bool _linkToSite = false;
  bool _linkToCompany = false;
  try {
    final response = await http.get('$endPoint/users/$id',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      final data = res['data'];
      user = User.fromJson(data);
      userRole = data['role'];
      if (data['employee'] != null) {
        _linkToSite = true;
        site = Site.fromJson(data['employee']['site']);/* 
        company = Company.fromJson(data['employee']['site']['companies'][0]); */
      }
      if (data['companies'] != null) {
        _linkToCompany = true;
        company = Company.fromJson(data['companies'][0]);
      }
      print('$data\n $site, $_linkToSite, $company, $_linkToCompany}');
      storeUserDetails(data, site, _linkToSite, company, _linkToCompany);
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
