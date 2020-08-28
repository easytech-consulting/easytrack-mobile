import 'dart:convert';
import 'dart:io';
import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/models/role.dart';
import 'package:http/http.dart' as http;

Future<List> fetchRoles() async {
  try {
    final response = await http.get('$endPoint/roles',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'].map((e) => Role.fromJson(e)).toList();
    }

    throw Exception(
        'Fetch Role exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Role exited with error $ex');
  }
}

