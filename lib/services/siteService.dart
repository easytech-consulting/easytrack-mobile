import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchSiteOfCompany() async {
  try {
    final response = await http.get('$endPoint/sites',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Fetch Site of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Site of Snack with error $ex');
  }
}

Future fetchEmployeesOfSite(int id) async {
  try {
    print(id);
    final response = await http.get('$endPoint/sites/$id',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Fetch Employees of Site $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Employees of Site $id with error $ex');
  }
}

Future createSite(params) async {
  print(params.toString());
  try {
    final response = await http.post('$endPoint/sites',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Creation of new Site exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Creation of new Site exited with error $ex');
  }
}

Future updateSite(params, int id) async {
  try {
    final response = await http.post('$endPoint/sites/$id',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception('Update Site $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Update Site $id exited with error $ex');
  }
}

Future deleteSite(int id) async {
  try {
    bool result = false;
    final response = await http.post('$endPoint/sites/$id/destroy',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      result = true;
    }

    errorStatusCode = response.statusCode;
    return result;
  } catch (ex) {
    throw Exception('Delete Site $id exited with error $ex');
  }
}