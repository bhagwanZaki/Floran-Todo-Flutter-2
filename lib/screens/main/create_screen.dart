import 'package:floran_todo/bloc/todo_bloc.dart';
import 'package:floran_todo/constant/colors.dart';
import 'package:floran_todo/constant/routes.dart';
import 'package:floran_todo/model/todo/todoModel.dart';
import 'package:floran_todo/response/todo_response.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  var todayDate = DateTime.now();

  // bloc
  TodoBloc? _bloc;

  // controller
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime taskDate = DateTime.now();

  // init

  @override
  void initState() {
    _bloc = TodoBloc();
    super.initState();
  }

  // custom function
  submit() {
    if (_formKey.currentState!.validate()) {
      _bloc?.createTodo(
          titleController.text, descriptionController.text, taskDate);
    }
  }

  _pickDate() async {
    DateTime? pickeddate = await showDatePicker(
        context: context,
        initialDate: taskDate,
        firstDate: DateTime(todayDate.year - 100),
        lastDate: DateTime(todayDate.year + 1));
    if (pickeddate != null) {
      var years = todayDate.year - pickeddate.year;
      if (todayDate.month < pickeddate.month) {
        years = years - 1;
      }
      setState(() {
        taskDate = pickeddate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tea,
      floatingActionButton: StreamBuilder<TodoResponse<TodoModel>>(
        stream: _bloc?.createtodoStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data?.status) {
              case Status.LOADING:
                return loadingBtn();
              case Status.COMPLETED:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.mainScreen, (route) => false);
                });
                break;
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
                return createBtn();
              default:
                return createBtn();
            }
          }
          return createBtn();
        },
      ),
      body: SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                appbar(context),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(color: AppColors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: titleController,
                        style: TextStyle(color: AppColors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter title';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            errorStyle:
                                TextStyle(fontSize: 14, color: AppColors.white),
                            hintStyle:
                                TextStyle(fontSize: 18, color: AppColors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "Title"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(color: AppColors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        minLines: 10,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(color: AppColors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            errorStyle:
                                TextStyle(fontSize: 14, color: AppColors.white),
                            hintStyle:
                                TextStyle(fontSize: 18, color: AppColors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "Description"),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Date',
                          style:
                              TextStyle(color: AppColors.white, fontSize: 20)),
                      taskDateCard(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  FloatingActionButton createBtn() {
    return FloatingActionButton(
      onPressed: () => submit(),
      shape: const CircleBorder(),
      elevation: 1,
      backgroundColor: AppColors.yellow,
      splashColor: AppColors.grey,
      child: Icon(Icons.add, color: AppColors.black),
    );
  }

  FloatingActionButton loadingBtn() {
    return FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        elevation: 1,
        backgroundColor: AppColors.yellow,
        splashColor: AppColors.grey,
        child: CircularProgressIndicator(
          color: AppColors.black,
        ));
  }

  Row appbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
            )),
        Text(
          "New Task",
          style: TextStyle(fontSize: 29, color: AppColors.white),
        ),
      ],
    );
  }

  Container taskDateCard() {
    FocusScope.of(context).requestFocus(FocusNode());
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: AppColors.barGreen,
        elevation: 0,
        child: ListTile(
            contentPadding:
                const EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0),
            title: Text(
              "${taskDate.year}-${taskDate.month}-${taskDate.day}",
              style: TextStyle(fontSize: 20, color: AppColors.white),
            ),
            trailing: const Icon(Icons.calendar_month),
            onTap: _pickDate),
      ),
    );
  }
}
