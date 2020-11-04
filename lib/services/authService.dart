import 'dart:convert';
import 'dart:io';
import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future<bool> login(Map<String, dynamic> params) async {
  try {
    bool response = false;
    var res = await http.post('$endPoint/login', body: params);
    if (res.statusCode == 200) {
      Map data = json.decode(res.body);
      userToken = data['access_token'];
      userId = data['user_id'];
      storeToken(userToken);
      storeTokenExpireDate(data['expires_at']);
      response = true;
    }

    errorStatusCode = res.statusCode;
    return response;
  } catch (e) {
    errorStatusCode = 0;
    throw Exception('Login exception: $e');
  }
}

Future<bool> recover(Map<String, dynamic> params) async {
  try {
    bool response = false;
    var res = await http.post('$endPoint/passwordRequest', body: params);
    if (res.statusCode == 200) {
      response = true;
    }

    errorStatusCode = res.statusCode;
    return response;
  } catch (e) {
    errorStatusCode = 0;
    throw Exception('Recover password exception: $e');
  }
}

Future<bool> register(params) async {
  try {
    bool response = false;
    var res = await http.post('$endPoint/register', body: params);
    if (res.statusCode == 201) {
      response = true;
    }
    print(res.body);
    errorStatusCode = res.statusCode;
    return response;
  } catch (e) {
    errorStatusCode = 0;
    throw Exception('Register exception: $e');
  }
}

Future<bool> logout() async {
  try {
    var res = await http.post('$endPoint/logout',
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});
    if (res.statusCode == 200) {
      disconnectUser();
      return true;
    }

    throw Exception('Logout exited with statusCode ${res.statusCode}');
  } catch (e) {
    errorStatusCode = 0;
    throw Exception('Logout exception: $e');
  }
}
