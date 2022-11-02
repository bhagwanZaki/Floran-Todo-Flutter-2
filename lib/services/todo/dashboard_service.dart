import 'dart:convert';
import 'dart:io';

import 'package:floran_todo/constant/constants.dart';
import 'package:floran_todo/model/todo/dashboardModel.dart';
import 'package:floran_todo/utils/apiException.dart';
import 'package:floran_todo/utils/preferences.dart';
import 'package:http/http.dart' as http;

class DashboardAPIService {
  Preference prefs = Preference();

  Future<dynamic> dashboard() async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.get(
          Uri.parse("${Constant.baseUrl}flutterchart"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });
      var responseBody = _returnResponse(res);

      return DashboardModel.fromMap(responseBody);
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
