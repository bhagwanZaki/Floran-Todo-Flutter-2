import 'dart:convert';
import 'dart:io';

import 'package:floran_todo/constant/constants.dart';
import 'package:floran_todo/model/auth/authModel.dart';
import 'package:floran_todo/model/auth/loginRegisterModel.dart';
import 'package:floran_todo/utils/preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/apiException.dart';

class AuthApiService {
  Preference prefs = Preference();


  // is authenticated
  Future<dynamic> isauth() async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.get(
          Uri.parse('${Constant.baseUrl}auth/user'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });

      var responsebody = _returnResponse(res);
      return authModel.fromMap(responsebody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  //login
  Future<dynamic> login(String username, String password) async {
    try {
      http.Response res =
          await http.post(Uri.parse('${Constant.baseUrl}auth/login'),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                'username': username,
                'password': password,
              }));

      var responseBody = _returnResponse(res);
      return loginRegisterModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  //register
  Future<dynamic> register(
      String username, String email, String password) async {
    try {
      http.Response res =
          await http.post(Uri.parse('${Constant.baseUrl}auth/register'),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                'username': username,
                'email': email,
                'password': password,
              }));

      var responseBody = _returnResponse(res);
      return loginRegisterModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  //logout
  Future<dynamic> logout() async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.post(
          Uri.parse('${Constant.baseUrl}auth/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });
      var responseBody = _returnResponse(res);
      return responseBody;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 201:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 204:
      return "true";
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
      throw BadRequestException(response.body.toString());
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
