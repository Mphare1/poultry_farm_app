import 'package:flutter/material.dart';
import '../widgets/dashboard_item.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardItems = [
    {'title': 'Inventory', 'icon': Icons.inventory, 'route': '/inventory'},
    {'title': 'Health', 'icon': Icons.health_and_safety, 'route': '/health'},
    {'title': 'Feed', 'icon': Icons.food_bank, 'route': '/feed'},
    {'title': 'Staff', 'icon': Icons.people, 'route': '/staff'},
    {'title': 'Financials', 'icon': Icons.attach_money, 'route': '/financials'},
    {'title': 'Weather', 'icon': Icons.wb_sunny, 'route': '/weather'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poultry Farm Management'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade400, Colors.teal.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return DashboardItem(
              title: dashboardItems[index]['title'],
              icon: dashboardItems[index]['icon'],
              route: dashboardItems[index]['route'],
            );
          },
        ),
      ),
    );
  }
}
