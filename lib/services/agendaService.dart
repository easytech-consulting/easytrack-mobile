import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchSitesOfUser() async {
  try {
    final response = await http.get('$endPoint/userSites',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception('Fetch sites of Snack exited with code ${response.body}');
  } catch (ex) {
    throw Exception('Fetch sites of Snack with error $ex');
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
    throw Exception('Fetch Teams of Site $id with error $ex');
  }
}

Future fetchTeamsDay(int id, int siteId) async {
  try {
    final response = await http.get('$endPoint/details/$id/sites/$siteId',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Fetch Teams of day $id of Site $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Teams  of day $id of Site $id with error $ex');
  }
}

Future deleteTeam(int id) async {
  try {
    final response = await http.post('$endPoint/teams/$id/destroy',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Delete Teams of day $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Delete Teams  of day $id  with error $ex');
  }
}
