import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchContacts() async {
  try {
    final response = await http.get('$endPoint/contacts',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Fetch Contacts exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Contacts with error $ex');
  }
}
