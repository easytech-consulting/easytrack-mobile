import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchMessages(int id) async {
  try {
    final response = await http.get('$endPoint/messages/$id',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['messages'];
    }

    throw Exception(
        'Fetch Messages of User $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Messages of User $id with error $ex');
  }
}

Future storeMessages(params) async {
  try {
    final response = await http.post('$endPoint/messages',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['message'];
    }

    throw Exception(
        'Fetch Messages of User exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Messages of User with error $ex');
  }
}
