import 'package:floran_todo/model/todo/dashboardModel.dart';
import 'package:floran_todo/services/todo/dashboard_service.dart';

class DashboardRepository {
  final DashboardAPIService _apiService = DashboardAPIService();

  Future<DashboardModel> dashboard() async {
    final response = await _apiService.dashboard();
    return response;
  }
}
