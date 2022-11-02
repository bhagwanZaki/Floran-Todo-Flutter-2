import 'package:floran_todo/constant/colors.dart';
import 'package:floran_todo/constant/routes.dart';
import 'package:floran_todo/screens/auth/login_screen.dart';
import 'package:floran_todo/screens/auth/register_screen.dart';
import 'package:floran_todo/screens/auth/splash_screen.dart';
import 'package:floran_todo/screens/main/create_screen.dart';
import 'package:floran_todo/screens/main/main_screen.dart';
import 'package:floran_todo/screens/main/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context)
              .textTheme
              .apply(
                  bodyColor: AppColors.black, displayColor: AppColors.black)),
          primaryTextTheme:
              GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: AppColors.lightBg,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.lightBg)),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context)
              .textTheme
              .apply(
                  bodyColor: AppColors.white, displayColor: AppColors.yellow)),
          primaryTextTheme:
              GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: AppColors.darkBg,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.darkBg)),
      home: const SplashScreen(),
      routes: {
        Routes.splashScreen: (context) => const SplashScreen(),
        Routes.loginScreen: (context) => const LoginScreen(),
        Routes.registerScreen: (context) => const RegisterScreen(),
        Routes.mainScreen: (context) => const MainScreen(),
        Routes.profileScreen: (context) => const ProfilePage(),
        Routes.createScreen:(context) => const CreateScreen()
      },
    );
  }
}
