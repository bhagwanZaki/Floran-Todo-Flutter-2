import 'package:floran_todo/model/auth/authModel.dart';
import 'package:floran_todo/model/auth/loginRegisterModel.dart';
import 'package:floran_todo/services/auth/authServices.dart';

class AuthRepository {
  final AuthApiService _apiService = AuthApiService();

  // check authentication
  Future<authModel> isAuth() async {
    final response = await _apiService.isauth();
    return response;
  }

  // login
  Future<loginRegisterModel> login(String username, String password) async {
    final response = await _apiService.login(username, password);
    return response;
  }

  //register
  Future<loginRegisterModel> register(
      String username, String email, String password) async {
    final response = await _apiService.register(username, email, password);
    return response;
  }

  //logout
  Future<void> logout() async {
    final response = await _apiService.logout();
    return response;
  }
}
