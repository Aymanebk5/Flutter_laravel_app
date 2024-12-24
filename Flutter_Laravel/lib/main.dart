import 'package:flutter_laravel/main_layout.dart';
import 'package:flutter_laravel/models/auth_model.dart';
import 'package:flutter_laravel/screens/auth_page.dart';
import 'package:flutter_laravel/screens/booking_page.dart';
import 'package:flutter_laravel/screens/home_page.dart';
import 'package:flutter_laravel/screens/success_booked.dart';
import 'package:flutter_laravel/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//DEMARRER L'APP
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//gerer la navigation avec navigatorkey
  static final navigatorKey = GlobalKey<NavigatorState>();

  //
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Doctor App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.primaryColor,
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Config.primaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          'home':(context) => HomePage(),
          'main': (context) => const MainLayout(),
          'booking_page': (context) =>  BookingPage(),
          'success_booking': (context) => const AppointmentBooked(),
        },
      ),
    );
  }
}