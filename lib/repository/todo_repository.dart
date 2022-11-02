import 'package:floran_todo/model/todo/todoModel.dart';
import 'package:floran_todo/services/todo/todo_service.dart';

class TodoRepository {
  final TodoService _service = TodoService();

  // todo list
  Future<List<TodoModel>> getTodo(String date) async {
    final response = await _service.getTodoList(date);
    return response;
  }

  // create todo
  Future<TodoModel> createTode(
      String title, String desp, DateTime completeBy) async {
    final response = await _service.createTodo(title, desp, completeBy);
    return response;
  }

  // complete todo
  Future<TodoModel> completeTodo(
      int id, bool completed, DateTime completedAt) async {
    final response = await _service.completeTodo(id, completed, completedAt);
    return response;
  }

  Future<dynamic> deleteTodo(int id) async {
    final response = await _service.deleteTodo(id);
    return response;
  }
}
