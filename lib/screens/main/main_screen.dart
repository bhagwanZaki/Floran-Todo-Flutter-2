import 'package:floran_todo/bloc/todo_bloc.dart';
import 'package:floran_todo/constant/Routes.dart';
import 'package:floran_todo/constant/colors.dart';
import 'package:floran_todo/model/todo/todoModel.dart';
import 'package:floran_todo/response/todo_response.dart';
import 'package:floran_todo/widget/task_item.dart';
import 'package:floran_todo/widget/task_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  String formattedDate =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  TodoBloc? _bloc;
  List<TodoModel>? todoList = [];

  @override
  void initState() {
    _bloc = TodoBloc();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello Claro",
                    style: TextStyle(
                        fontSize: 31,
                        color: Theme.of(context).textTheme.displayLarge?.color),
                  ),
                  MaterialButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.profileScreen),
                      shape: const CircleBorder(),
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? AppColors.yellow
                          : AppColors.mediumGreen,
                      child: const Icon(CupertinoIcons.person_fill))
                ],
              ),
              calendar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tasks",
                    style: TextStyle(
                        fontSize: 31,
                        color: Theme.of(context).textTheme.displayLarge?.color),
                  ),
                  MaterialButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.createScreen),
                      shape: const CircleBorder(),
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? AppColors.yellow
                          : AppColors.mediumGreen,
                      child: const Icon(CupertinoIcons.plus))
                ],
              ),
              StreamBuilder<TodoResponse<List<TodoModel>>>(
                stream: _bloc?.todoStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return loading(context);
                      case Status.COMPLETED:
                        todoList = snapshot.data!.data.toList();
                        if (todoList?.length != 0) {
                          return TaskList(todoList: todoList);
                        }
                        return const Center(
                          child: Text('No Todo found'),
                        );

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

                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                snapshot.data!.msg,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              refreshBtn(context)
                            ],
                          ),
                        );
                      default:
                        return const Center(
                          child: Text('No Todo found'),
                        );
                    }
                  }
                  return const Center(
                    child: Text('No Todo found'),
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  MaterialButton refreshBtn(BuildContext context) {
    return MaterialButton(
      onPressed: () => _bloc?.getTodo(formattedDate),
      color: Theme.of(context).textTheme.displayLarge?.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "Refresh",
          style: TextStyle(fontSize: 20, color: AppColors.black),
        )),
      ),
    );
  }

  Center loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          color: Theme.of(context).textTheme.displayLarge?.color),
    );
  }

  Container calendar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TableCalendar(
        firstDay: DateTime(2000),
        lastDay: DateTime(DateTime.now().year + 50),
        focusedDay: DateTime.now(),
        calendarFormat: _calendarFormat,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          // outsideTextStyle: TextStyle(color: AppColors.white),
          weekendTextStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          holidayTextStyle: TextStyle(color: AppColors.yellow),
          selectedDecoration:
              BoxDecoration(color: AppColors.teaGreen, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(
              color: AppColors.mediumGreen, shape: BoxShape.circle),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          var formattedDated =
              "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              formattedDate = formattedDated;
            });
            _bloc?.getTodo(formattedDated);
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
