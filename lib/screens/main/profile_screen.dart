import 'package:fl_chart/fl_chart.dart';
import 'package:floran_todo/bloc/auth_bloc.dart';
import 'package:floran_todo/bloc/dashboard_bloc.dart';
import 'package:floran_todo/constant/colors.dart';
import 'package:floran_todo/model/todo/dashboardModel.dart';
import 'package:floran_todo/response/auth_response.dart' as authRes;
import 'package:floran_todo/response/dashboard_response.dart';
import 'package:floran_todo/utils/preferences.dart';
import 'package:flutter/material.dart';

import '../../constant/Routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Preference prefs = Preference();
  String? username;
  String? email;

  // bloc
  DashboardBloc? _bloc;
  AuthBloc? _authbloc;

  @override
  void initState() {
    super.initState();
    _bloc = DashboardBloc();
    _authbloc = AuthBloc();
    _bloc?.getDashboard();
    getCredits();
  }

  Future<void> getCredits() async {
    var user = await prefs.getUsername();
    var emailD = await prefs.getemail();
    setState(() {
      username = user;
      email = emailD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appbar(context),
              const SizedBox(
                height: 15,
              ),
              profileCard(),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Task Tracker",
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).textTheme.displayLarge?.color),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<DashboardResponse<DashboardModel>>(
                  stream: _bloc?.dashboardStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data?.status) {
                        case Status.LOADING:
                          return Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color),
                          );
                        case Status.COMPLETED:
                          if (snapshot.data?.data.cdata.length == 0) {
                            return Center(
                              child: Text(
                                "No data to record currently",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontSize: 22),
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              chart(context, snapshot.data!.data.cdate,
                                  snapshot.data!.data.cdata),
                              const SizedBox(
                                height: 15,
                              ),
                              taskcompletedcount(
                                  snapshot.data!.data.numberOfTaskDone),
                            ],
                          );

                        case Status.ERROR:
                          return Center(
                            child: Text(snapshot.data!.msg),
                          );
                        default:
                          return Center(
                            child: Text("Something broke dont know 2"),
                          );
                      }
                    }
                    return Center(
                      child: Text("Something broke"),
                    );
                  })
            ],
          ),
        ),
      )),
    );
  }

  Container taskcompletedcount(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColors.teaGreen, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(
            "Task completed this month ",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.white, fontSize: 20),
          ),
          Text(
            "$count",
            style: TextStyle(fontSize: 25, color: AppColors.yellow),
          )
        ],
      ),
    );
  }

  Container profileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColors.teaGreen, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: TextStyle(color: AppColors.yellow, fontSize: 18),
          ),
          Text(
            "$username",
            style: TextStyle(color: AppColors.white, fontSize: 24),
          ),
          Text(
            'Email',
            style: TextStyle(color: AppColors.yellow, fontSize: 18),
          ),
          Text(
            '$email',
            style: TextStyle(color: AppColors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }

  Row appbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 30,
                  color: Theme.of(context).textTheme.displayLarge?.color,
                )),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Account',
              style: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge?.color,
                  fontSize: 32),
            )
          ],
        ),
        StreamBuilder<authRes.AuthResponse<dynamic>>(
          stream: _authbloc?.logoutStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data?.status) {
                case authRes.Status.LOADING:
                  return loadingbtn();
                case authRes.Status.COMPLETED:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.loginScreen, (route) => false);
                  });
                  break;
                case authRes.Status.ERROR:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(snapshot.data!.msg)));
                  });

                  return logoutbtn();
                default:
                  return logoutbtn();
              }
            }
            return logoutbtn();
          },
        )
      ],
    );
  }

  MaterialButton logoutbtn() {
    return MaterialButton(
      onPressed: () => _authbloc?.logout(),
      color: AppColors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Text(
        'Logout',
        style: TextStyle(color: AppColors.black),
      ),
    );
  }

  MaterialButton loadingbtn() {
    return MaterialButton(
        onPressed: () {},
        color: AppColors.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: CircularProgressIndicator(
          color: AppColors.black,
        ));
  }

  SingleChildScrollView chart(
      BuildContext context, List<int> cdate, List<int> cdata) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Container(
          height: 300,
          width: (cdate.length + 100),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(top: 20),
          child: BarChart(BarChartData(
              maxY: 5,
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                            "${(value + 1).toInt()}/${DateTime.now().month}")),
                    reservedSize: 38,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              gridData: FlGridData(show: false),
              barGroups: List.generate(cdate.length, (i) {
                return BarChartGroupData(x: i, barsSpace: 5, barRods: [
                  BarChartRodData(
                      toY: cdata[i].toDouble(),
                      borderRadius: BorderRadius.circular(4),
                      color: i == 29.0
                          ? AppColors.barOrange
                          : Theme.of(context).brightness == Brightness.dark
                              ? AppColors.yellow
                              : AppColors.barGreen,
                      width: 20)
                ]);
              })))),
    );
  }
}
