import 'package:floran_todo/model/auth/authModel.dart';
import 'package:floran_todo/model/auth/loginRegisterModel.dart';
import 'package:floran_todo/response/auth_response.dart';
import 'package:flutter/material.dart';

import '../../bloc/auth_bloc.dart';
import '../../constant/Colors.dart';
import '../../constant/Routes.dart';
import '../../utils/preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();

  Preference prefs = Preference();
  AuthBloc? _bloc;

  @override
  void initState() {
    _bloc = AuthBloc();
    super.initState();
  }

  registerSubmit() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formKey.currentState!.validate() && password.text == password2.text) {
      _bloc?.register(username.text, email.text, password.text);
    } else if (password.text == password2.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Password not same",
        style: TextStyle(fontSize: 20),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: 73),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formLabel("Username"),
                      const SizedBox(
                        height: 5,
                      ),
                      formField("Username", username, false),
                      const SizedBox(
                        height: 8,
                      ),
                      formLabel("Email"),
                      const SizedBox(
                        height: 5,
                      ),
                      emailField(email),
                      const SizedBox(
                        height: 8,
                      ),
                      formLabel("Password"),
                      const SizedBox(
                        height: 5,
                      ),
                      passwordField(password),
                      const SizedBox(
                        height: 8,
                      ),
                      formLabel("Confirm Password"),
                      const SizedBox(
                        height: 5,
                      ),
                      confirmpasswordField(password2),
                      const SizedBox(
                        height: 25,
                      ),
                      StreamBuilder<AuthResponse<loginRegisterModel>>(
                        stream: _bloc?.registerStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data?.status) {
                              case Status.LOADING:
                                return loadingbtn(context);
                              case Status.COMPLETED:
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  prefs.setToken(snapshot.data!.data.token);
                                  prefs.setUsername(
                                      snapshot.data!.data.user.username);
                                  prefs
                                      .setemail(snapshot.data!.data.user.email);
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      Routes.mainScreen, (route) => false);
                                });
                                break;
                              case Status.ERROR:
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    snapshot.data!.msg.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  )));
                                });
                                return registerbtn(context);
                              default:
                                return registerbtn(context);
                            }
                          }
                          return registerbtn(context);
                        },
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: InkWell(
                            onTap: () => {
                              Navigator.pushReplacementNamed(
                                  context, Routes.loginScreen)
                            },
                            child: Text("Already Have An Account",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color)),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        )),
      ),
    );
  }

  MaterialButton registerbtn(BuildContext context) {
    return MaterialButton(
      onPressed: () => registerSubmit(),
      color: AppColors.yellow,
      minWidth: double.infinity,
      height: 60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Text(
        "Register",
        style: TextStyle(fontSize: 27, color: AppColors.darkBg),
      ),
    );
  }

  MaterialButton loadingbtn(BuildContext context) {
    return MaterialButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, Routes.mainScreen);
        },
        color: AppColors.yellow,
        minWidth: double.infinity,
        height: 60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: CircularProgressIndicator(
          color: AppColors.darkBg,
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

  TextFormField emailField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter Email';
        }
        return null;
      },
      style: TextStyle(color: AppColors.black),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintStyle: TextStyle(fontSize: 20, color: AppColors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: "Email"),
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
      style: TextStyle(color: AppColors.black),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintStyle: TextStyle(fontSize: 20, color: AppColors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: "Password"),
    );
  }

  TextFormField confirmpasswordField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if ((value == null || value.isEmpty) &&
            password.text == password2.text) {
          return 'Password Did Not Match';
        }
        return null;
      },
      onFieldSubmitted: (v) => registerSubmit(),
      style: TextStyle(color: AppColors.black),
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          hintStyle: TextStyle(fontSize: 20, color: AppColors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: "Confirm Password"),
    );
  }

  Text formLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 20),
    );
  }
}
