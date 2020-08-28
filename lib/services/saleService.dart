import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future fetchSales() async {
  try {
    final response = await http.get('$endPoint/sales',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['sales'];
    }

    throw Exception(
        'Fetch Sales of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Fetch Sales of Snack with error $ex');
  }
}

Future storeSale(params) async {
  try {
    final response = await http.post('$endPoint/sales',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data;
    }

    throw Exception(
        'Store Sale of Snack exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Store Sale of Snack with error $ex');
  }
}

Future updateSale(params, id) async {
  try {
    final response = await http.post('$endPoint/sales/$id',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }

    throw Exception(
        'Update Sale $id of Snack exited with code ${response.body}');
  } catch (ex) {
    throw Exception('Update Sale $id of Snack with error $ex');
  }
}

Future changeSaleState(params, id) async {
  try {
    final response = await http.post('$endPoint/sales/$id/status',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }

    throw Exception(
        'Set Sale Status to $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Set Sale Status to $id with error $ex');
  }
}

Future validateSale(id) async {
  try {
    final response = await http.post('$endPoint/sales/$id/validate',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }

    throw Exception('Set Sale Status to $id exited with code ${response.body}');
  } catch (ex) {
    throw Exception('Set Sale Status to $id with error $ex');
  }
}

Future invalidateSale(id) async {
  try {
    final response = await http.post('$endPoint/sales/$id/invalidate',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }

    throw Exception(
        'Set Sale Status to $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Set Sale Status to $id with error $ex');
  }
}
