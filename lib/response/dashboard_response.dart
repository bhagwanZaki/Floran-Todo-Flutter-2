// ignore_for_file: constant_identifier_names

class DashboardResponse<T> {
  late Status status;
  late T data;
  late String msg;

  DashboardResponse.loading(this.msg) : status = Status.LOADING;
  DashboardResponse.completed(this.data) : status = Status.COMPLETED;
  DashboardResponse.error(this.msg) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

