import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchStats() async {
  try {
    final response = await http.get('$endPoint/stats',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return user.isAdmin == 1 ? data : data['stats'];
    }

    throw Exception(
        'Fetch Stats of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Stats of Snack with error $ex');
  }
}
