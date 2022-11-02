import 'package:floran_todo/bloc/auth_bloc.dart';
import 'package:floran_todo/constant/Colors.dart';
import 'package:floran_todo/model/auth/loginRegisterModel.dart';
import 'package:floran_todo/response/auth_response.dart';
import 'package:floran_todo/utils/preferences.dart';
import 'package:flutter/material.dart';

import '../../constant/Routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Preference prefs = Preference();
  AuthBloc? _bloc;

  @override
  void initState() {
    _bloc = AuthBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontSize: 73),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formLabel("Username"),
                          const SizedBox(
                            height: 10,
                          ),
                          formField("Username", username, false),
                          const SizedBox(
                            height: 15,
                          ),
                          formLabel("Password"),
                          const SizedBox(
                            height: 10,
                          ),
                          passwordField(password),
                          const SizedBox(
                            height: 55,
                          ),
                          StreamBuilder<AuthResponse<loginRegisterModel>>(
                            stream: _bloc?.loginStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                switch (snapshot.data?.status) {
                                  case Status.LOADING:
                                    return loadingBtn(context);
                                  case Status.COMPLETED:
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      prefs.setToken(snapshot.data!.data.token);
                                      prefs.setUsername(
                                          snapshot.data!.data.user.username);
                                      prefs.setemail(
                                          snapshot.data!.data.user.email);
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          Routes.mainScreen, (route) => false);
                                    });
                                    break;
                                  case Status.ERROR:
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                        "Username or Password not valid",
                                        style: TextStyle(fontSize: 20),
                                      )));
                                    });
                                    return loginBtn(context);
                                  default:
                                    return loginBtn(context);
                                }
                              }
                              return loginBtn(context);
                            },
                          ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 55.0),
                              child: InkWell(
                                onTap: () => {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.registerScreen)
                                },
                                child: Text("Don't Have An Account",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.color)),
                              ),
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //login function

  loginfun(BuildContext context, String username, String password) {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formKey.currentState!.validate()) {
      _bloc?.login(username, password);
    }
  }

  MaterialButton loginBtn(BuildContext context) {
    return MaterialButton(
      onPressed: () => loginfun(context, username.text, password.text),
      color: AppColors.yellow,
      minWidth: double.infinity,
      height: 60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Text(
        "Login",
        style: TextStyle(fontSize: 27, color: AppColors.darkBg),
      ),
    );
  }

  MaterialButton loadingBtn(BuildContext context) {
    return MaterialButton(
        onPressed: () {},
        color: AppColors.yellow,
        minWidth: double.infinity,
        height: 60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: CircularProgressIndicator(
          color: AppColors.black,
        ));
  }

  TextFormField formField(
      String label, TextEditingController controller, bool ispassword) {
    return TextFormField(
      controller: controller,
      obscureText: ispassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter $label';
        }
        return null;
      },
      style: TextStyle(color: AppColors.black),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintStyle: TextStyle(fontSize: 20, color: AppColors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: label),
    );
  }

  TextFormField passwordField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter password';
        }
        return null;
      },
      onFieldSubmitted: (v) => loginfun(context, username.text, password.text),
      style: TextStyle(color: AppColors.black),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintStyle: TextStyle(fontSize: 20, color: AppColors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: "Password"),
    );
  }

  Text formLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 20),
    );
  }
}
