import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchProductsOfSnack() async {
  try {
    final response = await http.get('$endPoint/products',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['products'];
    }

    throw Exception(
        'Fetch Products of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Products of Snack with error $ex');
  }
}

Future fetchProductsOfCategory(int id) async {
  try {
    final response = await http.get('$endPoint/products/site/$id',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['products'];
    }

    throw Exception(
        'Fetch Products of Category $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Products of Category $id with error $ex');
  }
}
