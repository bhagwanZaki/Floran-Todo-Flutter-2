import 'package:floran_todo/bloc/auth_bloc.dart';
import 'package:floran_todo/constant/colors.dart';
import 'package:floran_todo/model/auth/authModel.dart';
import 'package:floran_todo/response/auth_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constant/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthBloc? _authBloc;

  @override
  void initState() {
    _authBloc = AuthBloc();
    _authBloc?.fetchIsAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        StreamBuilder<AuthResponse<authModel>>(
          stream: _authBloc?.authStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data?.status) {
                case Status.LOADING:
                  return mainLogo(context);
                case Status.COMPLETED:
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.mainScreen, (route) => false));
                  break;
                case Status.ERROR:
                  if (snapshot.data!.msg ==
                      "Error During Communication: No Internet Connection") {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Icon(
                              CupertinoIcons.wifi_slash,
                              size: 100.0,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          refreshBtn()
                        ],
                      ),
                    );
                  }

                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Navigator.pushReplacementNamed(
                        context, Routes.loginScreen),
                  );
                  break;
                default:
                  break;
              }
            }
            return mainLogo(context);
          },
        ),
        // mainLogo(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              children: [
                Text(
                  "From",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w100,
                      color: Theme.of(context).textTheme.displayLarge?.color),
                ),
                Text(
                  "Floran",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w100,
                      color: Theme.of(context).textTheme.displayLarge?.color),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  MaterialButton refreshBtn() {
    return MaterialButton(
      onPressed: () async {
        _authBloc?.fetchIsAuth();
      },
      color: AppColors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Refresh",
          style: TextStyle(fontSize: 25, color: AppColors.black),
        ),
      ),
    );
  }

  Expanded mainLogo(BuildContext context) {
    return Expanded(
        child: Center(
      child: Text(
        "To Do",
        style: TextStyle(
            fontSize: 74,
            color: Theme.of(context).textTheme.displayLarge?.color),
      ),
    ));
  }
}
