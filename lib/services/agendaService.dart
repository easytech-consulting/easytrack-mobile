import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchSitesOfUser() async {
  try {
    final response = await http.get('$endPoint/sites',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Fetch Notifications of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Notifications of Snack with error $ex');
  }
}

Future fetchTeamsOfSites(int id) async {
  try {
    final response = await http.get('$endPoint/teams/$id',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Fetch Teams of Site $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Notifications of Site $id with error $ex');
  }
}

