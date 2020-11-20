import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchPurchases() async {
  try {
    final response = await http.get('$endPoint/purchases',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['purchases'];
    }

    throw Exception(
        'Fetch Purchases of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Purchases of Snack with error $ex');
  }
}

Future deletePurchase(int id) async {
  try {
    bool result = false;
    final response = await http.post('$endPoint/purchases/$id/destroy',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      result = true;
    }

    errorStatusCode = response.statusCode;
    return result;
  } catch (ex) {
    throw Exception('Delete purchases $id exited with error $ex');
  }
}