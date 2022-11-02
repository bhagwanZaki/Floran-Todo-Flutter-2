// ignore_for_file: constant_identifier_names

class TodoResponse<T> {
  late Status status;
  late T data;
  late String msg;

  TodoResponse.loading(this.msg) : status = Status.LOADING;
  TodoResponse.completed(this.data) : status = Status.COMPLETED;
  TodoResponse.error(this.msg) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

