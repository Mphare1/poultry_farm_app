import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final String farmId; // Add farmId parameter

  const DashboardItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.route,
    required this.farmId, // Require farmId in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          route,
          arguments: farmId, // Pass farmId as argument
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.teal),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
