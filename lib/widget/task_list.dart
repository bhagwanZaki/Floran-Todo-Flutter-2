import 'package:floran_todo/bloc/todo_bloc.dart';
import 'package:floran_todo/response/todo_response.dart';
import 'package:floran_todo/widget/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../constant/Colors.dart';
import '../model/todo/todoModel.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.todoList});
  final List<TodoModel>? todoList;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TodoBloc? _bloc;

  @override
  void initState() {
    _bloc = TodoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todoList!.isEmpty) {
      return const Center(
        child: Text("Add new todo"),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.todoList?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          key: Key("$index"),
          onTap: () {
            todoDetail(
                context,
                widget.todoList![index],
                DateTime.parse(widget.todoList![index].date_completed_by)
                            .compareTo(DateTime.parse(
                                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}")) ==
                        -1
                    ? true
                    : false);
          },
          child: Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                StreamBuilder<TodoResponse<dynamic>>(
                  stream: _bloc?.deletetodoStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data?.status) {
                        case Status.LOADING:
                          return SlidableAction(
                            onPressed: (context) {},
                            icon: Icons.hourglass_bottom_rounded,
                            label: "Deleting..",
                          );
                        case Status.COMPLETED:
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              widget.todoList!.removeAt(index);
                            });
                          });
                          break;
                        case Status.ERROR:
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(snapshot.data!.msg)));
                          });
                          return SlidableAction(
                            onPressed: (context) {
                              _bloc?.deleteTodo(widget.todoList![index].id);
                            },
                            icon: Icons.delete,
                            label: "Delete",
                            backgroundColor: Colors.redAccent,
                          );
                        default:
                          return SlidableAction(
                            onPressed: (context) {
                              _bloc?.deleteTodo(widget.todoList![index].id);
                            },
                            icon: Icons.delete,
                            label: "Delete",
                            backgroundColor: Colors.redAccent,
                          );
                      }
                    }
                    return SlidableAction(
                      onPressed: (context) {
                        _bloc?.deleteTodo(widget.todoList![index].id);
                      },
                      icon: Icons.delete,
                      label: "Delete",
                      backgroundColor: Colors.redAccent,
                    );
                  },
                ),
              ],
            ),
            child: TaskItem(
                index: widget.todoList![index].id,
                task: widget.todoList![index].title,
                time: widget.todoList![index].date_completed_by,
                isDealyed: DateTime.parse(
                                widget.todoList![index].date_completed_by)
                            .compareTo(DateTime.parse(
                                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day > 0 ? "0${DateTime.now().day}" : DateTime.now().day}")) ==
                        -1
                    ? true
                    : false,
                isCompleted: widget.todoList![index].completed),
          ),
        );
      },
    );
  }

  Text detailValue(String value) {
    return Text(
      value,
      style: TextStyle(color: AppColors.white, fontSize: 25),
    );
  }

  Text lable(String label) => Text(
        label,
        style: TextStyle(color: AppColors.yellow, fontSize: 18),
      );
  Container delayBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.yellow, borderRadius: BorderRadius.circular(50)),
      child: Text(
        "Delay",
        style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w800),
      ),
    );
  }

  Future<dynamic> todoDetail(
      BuildContext context, TodoModel data, bool isDelayed) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.teaGreen,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isDelayed
                      ? delayBadge()
                      : const SizedBox(
                          height: 0,
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  lable("Title"),
                  detailValue(data.title),
                  const SizedBox(
                    height: 15,
                  ),
                  lable("Description"),
                  detailValue(data.description),
                  const SizedBox(
                    height: 15,
                  ),
                  data.completed == false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            lable("Complete by"),
                            detailValue(data.date_completed_by),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            lable("Completed"),
                            detailValue("${data.completed_at}"),
                          ],
                        )
                ],
              ),
            ),
          );
        });
  }
}
