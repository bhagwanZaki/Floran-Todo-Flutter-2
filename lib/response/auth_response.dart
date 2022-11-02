// ignore_for_file: constant_identifier_names

class AuthResponse<T> {
  late Status status;
  late T data;
  late String msg;

  AuthResponse.loading(this.msg) : status = Status.LOADING;
  AuthResponse.completed(this.data) : status = Status.COMPLETED;
  AuthResponse.error(this.msg) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $msg \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

