import 'dart:convert';

import 'package:easytrack/commons/globals.dart';
import 'package:easytrack/models/plan.dart';
import 'package:http/http.dart' as http;

Future<List<Plan>> fetchAllPlans() async {
  try {
    final response = await http.get('$endPoint/types');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      Iterable data = res['data'];
      return data.map((plan) => Plan.fromJson(plan)).toList();
    }

    throw Exception("FetchPlan exited with code ${response.statusCode}");
  } catch (ex) {
    throw Exception('FetchPlan with error $ex');
  }
}
