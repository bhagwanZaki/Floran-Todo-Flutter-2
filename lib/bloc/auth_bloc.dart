import 'dart:async';

import 'package:floran_todo/model/auth/authModel.dart';
import 'package:floran_todo/model/auth/loginRegisterModel.dart';
import 'package:floran_todo/repository/auth_repository.dart';
import 'package:floran_todo/response/auth_response.dart';

class AuthBloc {
  late AuthRepository _authRepository;

  //controller
  late StreamController<AuthResponse<authModel>> _authController;
  late StreamController<AuthResponse<loginRegisterModel>> _loginController;
  late StreamController<AuthResponse<loginRegisterModel>> _registerController;
  late StreamController<AuthResponse<void>> _logoutController;

  // sink
  StreamSink<AuthResponse<authModel>> get authSink => _authController.sink;
  StreamSink<AuthResponse<loginRegisterModel>> get loginSink =>
      _loginController.sink;
  StreamSink<AuthResponse<loginRegisterModel>> get registerSink =>
      _registerController.sink;
  StreamSink<AuthResponse<void>> get logoutSink => _logoutController.sink;

  // stream
  Stream<AuthResponse<authModel>> get authStream => _authController.stream;
  Stream<AuthResponse<loginRegisterModel>> get loginStream =>
      _loginController.stream;
  Stream<AuthResponse<loginRegisterModel>> get registerStream =>
      _registerController.stream;
  Stream<AuthResponse<void>> get logoutStream => _logoutController.stream;

  //constructor
  AuthBloc() {
    _authController = StreamController<AuthResponse<authModel>>();
    _loginController = StreamController<AuthResponse<loginRegisterModel>>();
    _registerController = StreamController<AuthResponse<loginRegisterModel>>();
    _logoutController = StreamController<AuthResponse<void>>();
    _authRepository = AuthRepository();
  }

  // is auth bloc function
  fetchIsAuth() async {
    authSink.add(AuthResponse.loading('Validating..'));
    try {
      authModel authData = await _authRepository.isAuth();
      authSink.add(AuthResponse.completed(authData));
    } catch (e) {
      authSink.add(AuthResponse.error(e.toString()));
    }
  }

  // login
  login(String username, String password) async {
    loginSink.add(AuthResponse.loading("Logging in"));
    try {
      loginRegisterModel loginData =
          await _authRepository.login(username, password);
      loginSink.add(AuthResponse.completed(loginData));
    } catch (e) {
      loginSink.add(AuthResponse.error(e.toString()));
    }
  }

  // register
  register(String username, String email, String password) async {
    registerSink.add(AuthResponse.loading("Registering.."));
    try {
      loginRegisterModel registerData =
          await _authRepository.register(username, email, password);
      registerSink.add(AuthResponse.completed(registerData));
    } catch (e) {
      registerSink.add(AuthResponse.error(e.toString()));
    }
  }

  //logout
  logout() async {
    logoutSink.add(AuthResponse.loading('Logging out'));
    try {
      void logoutData = await _authRepository.logout();
      logoutSink.add(AuthResponse.completed(logoutData));
    } catch (e) {
      logoutSink.add(AuthResponse.error(e.toString()));
    }
  }
}
