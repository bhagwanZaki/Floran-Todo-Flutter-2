import 'dart:async';

import 'package:floran_todo/model/todo/todoModel.dart';
import 'package:floran_todo/repository/todo_repository.dart';
import 'package:floran_todo/response/todo_response.dart';

class TodoBloc {
  late TodoRepository _repository;

  //controller
  late StreamController<TodoResponse<List<TodoModel>>> _controller;
  late StreamController<TodoResponse<TodoModel>> _createcontroller;
  late StreamController<TodoResponse<TodoModel>> _updatecontroller;
  late StreamController<TodoResponse<dynamic>> _deletecontroller;

  // sink
  StreamSink<TodoResponse<List<TodoModel>>> get todoSink => _controller.sink;
  StreamSink<TodoResponse<TodoModel>> get createtodoSink =>
      _createcontroller.sink;
  StreamSink<TodoResponse<TodoModel>> get updatetodoSink =>
      _updatecontroller.sink;
  StreamSink<TodoResponse<dynamic>> get deletetodoSink =>
      _deletecontroller.sink;

  //stream
  Stream<TodoResponse<List<TodoModel>>> get todoStream => _controller.stream;
  Stream<TodoResponse<TodoModel>> get createtodoStream =>
      _createcontroller.stream;
  Stream<TodoResponse<TodoModel>> get updatetodoStream =>
      _updatecontroller.stream;
  Stream<TodoResponse<dynamic>> get deletetodoStream =>
      _deletecontroller.stream;

  //constructor
  TodoBloc() {
    _controller = StreamController<TodoResponse<List<TodoModel>>>();
    _createcontroller = StreamController<TodoResponse<TodoModel>>();
    _updatecontroller = StreamController<TodoResponse<TodoModel>>();
    _deletecontroller = StreamController<TodoResponse<dynamic>>();
    _repository = TodoRepository();

    
  }

  // fetch todo
  getTodo(String date) async {
    todoSink.add(TodoResponse.loading("Fetching data.."));
    try {
      List<TodoModel> todoList = await _repository.getTodo(date);
      todoSink.add(TodoResponse.completed(todoList));
    } catch (e) {
      todoSink.add(TodoResponse.error(e.toString()));
    }
  }

  // create todo
  createTodo(String title, String desp, DateTime completeBy) async {
    createtodoSink.add(TodoResponse.loading("Posting info to server"));
    try {
      TodoModel createData =
          await _repository.createTode(title, desp, completeBy);
      createtodoSink.add(TodoResponse.completed(createData));
    } catch (e) {
      createtodoSink.add(TodoResponse.error(e.toString()));
    }
  }

  // completing or uncompleting todo
  completeTodo(int id, bool completed, DateTime completedAt) async {
    updatetodoSink.add(TodoResponse.loading("updating todo"));
    try {
      TodoModel data =
          await _repository.completeTodo(id, completed, completedAt);
      updatetodoSink.add(TodoResponse.completed(data));
    } catch (e) {
      updatetodoSink.add(TodoResponse.error(e.toString()));
    }
  }

  // delete todo
  deleteTodo(int id) async {
    deletetodoSink.add(TodoResponse.loading("Deleting todo"));
    try {
      dynamic data = await _repository.deleteTodo(id);
      deletetodoSink.add(TodoResponse.completed(data));
    } catch (e) {
      deletetodoSink.add(TodoResponse.error(e.toString()));
    }
  }

  // dispose
  dispose() {
    _controller.close();
    _createcontroller.close();
    _updatecontroller.close();
    _deletecontroller.close();
  }
}
