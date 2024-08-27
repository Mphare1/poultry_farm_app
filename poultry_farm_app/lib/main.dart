import 'package:flutter/material.dart';
import 'package:poultry_farm_app/staff/staff_page.dart';
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
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final String farmId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(farmId: farmId),
          );
        } else if (settings.name == '/staff') {
          final String farmId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => StaffPage(farmId: farmId),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const loginScreen(),
      },
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color.fromARGB(255, 145, 0, 150)),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
