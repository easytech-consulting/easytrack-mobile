import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchCustomersOfSnack(int id) async {
  try {
    print(id);
    final response = await http.get('$endPoint/customers/sites/$id',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Fetch Customers of Snack $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Customers of Snack $id with error $ex');
  }
}

Future deleteCustomer(int id) async {
  try {
    bool result = false;
    final response = await http.post('$endPoint/customers/$id/destroy',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      result = true;
    }

    errorStatusCode = response.statusCode;
    return result;
  } catch (ex) {
    throw Exception('Delete customers $id exited with error $ex');
  }
}