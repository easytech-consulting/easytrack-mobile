import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchSuppliersOfSnack() async {
  try {
    final response = await http.get('$endPoint/suppliers',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['suppliers'];
    }

    throw Exception(
        'Fetch Suppliers of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Suppliers of Snack with error $ex');
  }
}
