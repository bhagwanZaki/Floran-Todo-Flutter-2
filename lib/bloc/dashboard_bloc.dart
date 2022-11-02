import 'dart:async';

import 'package:floran_todo/model/todo/dashboardModel.dart';
import 'package:floran_todo/repository/dashboard_repository.dart';
import 'package:floran_todo/response/dashboard_response.dart';

class DashboardBloc {
  late DashboardRepository _repository;

  //controller
  late StreamController<DashboardResponse<DashboardModel>> _controller;

  //sink
  StreamSink<DashboardResponse<DashboardModel>> get dashboardSink =>
      _controller.sink;

  // stream

  Stream<DashboardResponse<DashboardModel>> get dashboardStream =>
      _controller.stream;

  //  constructor

  DashboardBloc() {
    _controller = StreamController<DashboardResponse<DashboardModel>>();
    _repository = DashboardRepository();
  }

  // get dashboard

  getDashboard() async {
    dashboardSink.add(DashboardResponse.loading("fetching data"));
    try {
      DashboardModel data = await _repository.dashboard();
      dashboardSink.add(DashboardResponse.completed(data));
    } catch (e) {
      dashboardSink.add(DashboardResponse.error(e.toString()));
    }
  }
}
