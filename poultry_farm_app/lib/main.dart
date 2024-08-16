import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'utils/color_utils.dart';

void main() {
  runApp(PoultryFarmApp());
}

class PoultryFarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color.fromARGB(255, 145, 0, 150)),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
