import 'package:floran_todo/bloc/todo_bloc.dart';
import 'package:floran_todo/constant/colors.dart';
import 'package:floran_todo/constant/routes.dart';
import 'package:floran_todo/model/todo/todoModel.dart';
import 'package:floran_todo/response/todo_response.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(
      {super.key,
      required this.task,
      required this.time,
      required this.isDealyed,
      required this.isCompleted,
      required this.index});
  final int index;
  final String task;
  final String time;
  final bool isDealyed;
  final bool isCompleted;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _complete;
  TodoBloc? _bloc;
  @override
  void initState() {
    _bloc = TodoBloc();
    super.initState();
    _complete = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.teaGreen,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isDealyed
                      ? delayBadge()
                      : const SizedBox(
                          height: 0,
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.task,
                    style: TextStyle(fontSize: 26, color: AppColors.white),
                  ),
                  Text(
                    "Date: ${widget.time}",
                    style: TextStyle(fontSize: 20, color: AppColors.white),
                  )
                ],
              ),
            ),
            StreamBuilder<TodoResponse<TodoModel>>(
                stream: _bloc?.updatetodoStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return loadingbox();
                      case Status.COMPLETED:
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _complete = snapshot.data!.data.completed;
                          });
                        });
                        return checkbox(snapshot.data!.data.completed);
                      case Status.ERROR:
                        if (snapshot.data!.msg ==
                                'Unauthorised: {"detail":"Invalid token."}' ||
                            snapshot.data!.msg ==
                                'Invalid Request: {"detail":"Invalid token."}') {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => Navigator.pushReplacementNamed(
                                context, Routes.loginScreen),
                          );
                          break;
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(snapshot.data!.msg)));
                        });
                        return checkbox(_complete);
                      default:
                        return checkbox(_complete);
                    }
                  }
                  return checkbox(_complete);
                }))
          ],
        ),
      ),
    );
  }

  Container checkbox(bool check) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: _complete ? AppColors.mediumGreen : AppColors.cardteaGreen,
      ),
      child: Checkbox(
          value: check,
          activeColor: AppColors.mediumGreen,
          // focusColor: AppColors.mediumGreen,
          shape: const CircleBorder(),
          side: BorderSide(color: AppColors.white, width: 2),
          onChanged: (v) {
            print('click');
            _bloc?.completeTodo(widget.index, !_complete, DateTime.now());
          }),
    );
  }

  Container loadingbox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.mediumGreen,
      ),
      child: CircularProgressIndicator(color: AppColors.white),
    );
  }

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
}
