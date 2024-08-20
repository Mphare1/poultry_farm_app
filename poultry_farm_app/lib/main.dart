import 'package:flutter/material.dart';
import 'package:poultry_farm_app/welcome_screen.dart';
import 'utils/color_utils.dart';
import 'screens/dashboard_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(PoultryFarmApp());
}

class PoultryFarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const loginScreen(),
        '/dashboard': (context) =>
            DashboardScreen(), // Define your DashboardScreen here
      },
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color.fromARGB(255, 145, 0, 150)),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
