import 'dart:convert';
import 'dart:io';

import 'package:floran_todo/constant/constants.dart';
import 'package:floran_todo/model/todo/todoModel.dart';
import 'package:floran_todo/utils/apiException.dart';
import 'package:floran_todo/utils/preferences.dart';
import 'package:http/http.dart' as http;

class TodoService {
  Preference prefs = Preference();

  //getting todo list

  Future<dynamic> getTodoList(String date) async {
    try {
      String? token = await prefs.getToken();
      http.Response res = await http.get(
          Uri.parse("${Constant.baseUrl}ftodos/$date"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          });

      var responseBody = _returnResponse(res);
      List<TodoModel> todoList = List.from(responseBody['todo'])
          .map((e) => TodoModel.fromMap(e))
          .toList();
      return todoList;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  // create
  Future<dynamic> createTodo(
      String title, String desp, DateTime completeBy) async {
    try {
      String? token = await prefs.getToken();
      http.Response res = await http.post(
          Uri.parse(
            "${Constant.baseUrl}todos/",
          ),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          },
          body: jsonEncode(<String, dynamic>{
            'title': title,
            'description': desp,
            'date_completed_by':
                "${completeBy.year}-${completeBy.month}-${completeBy.day}"
          }));
      var responseBody = _returnResponse(res);

      return TodoModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  // update todo
  Future<dynamic> completeTodo(
      int id, bool completed, DateTime completedAt) async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.patch(
          Uri.parse("${Constant.baseUrl}todos/$id/"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'
          },
          body: jsonEncode(<String, dynamic>{
            "completed_at":
                "${completedAt.year}-${completedAt.month}-${completedAt.day}",
            "completed": completed
          }));

      var responseBody = _returnResponse(res);
      return TodoModel.fromMap(responseBody);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  // update todo
  Future<dynamic> deleteTodo(int id) async {
    try {
      String? token = await prefs.getToken();

      http.Response res = await http.delete(
          Uri.parse("${Constant.baseUrl}todos/$id/"),
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
