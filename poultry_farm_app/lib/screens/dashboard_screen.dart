import 'package:flutter/material.dart';
import '../widgets/dashboard_item.dart';

class DashboardScreen extends StatefulWidget {
  final String farmId; // Add farmId parameter

  DashboardScreen({required this.farmId}); // Require farmId in constructor

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Pass the farmId to DashboardScreenContent
    final List<Widget> _pages = [
      DashboardScreenContent(farmId: widget.farmId), // Home (Dashboard)
      MessagesScreen(), // Messages
      ProfileScreen(), // Profile
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Poultry Farm Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 6,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffB81736), Color(0xff281537)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal.shade400,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Separate Widget for the Dashboard Content
class DashboardScreenContent extends StatelessWidget {
  final String farmId; // Add farmId parameter

  DashboardScreenContent({required this.farmId}); // Require farmId in constructor

  final List<Map<String, dynamic>> dashboardItems = [
    {'title': 'Inventory', 'icon': Icons.inventory, 'route': '/inventory'},
    {'title': 'Health', 'icon': Icons.health_and_safety, 'route': '/health'},
    {'title': 'Feed', 'icon': Icons.food_bank, 'route': '/feed'},
    {'title': 'Staff', 'icon': Icons.people, 'route': '/staff'}, // Will pass farmId to this route
    {'title': 'Financials', 'icon': Icons.attach_money, 'route': '/financials'},
    {'title': 'Weather', 'icon': Icons.wb_sunny, 'route': '/weather'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffB81736), Color(0xff281537)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            return DashboardItem(
              title: dashboardItems[index]['title'],
              icon: dashboardItems[index]['icon'],
              route: dashboardItems[index]['route'],
              farmId: farmId, // Pass farmId to DashboardItem
            );
          },  
        ),
      ),
    );
  }
}

// Placeholder screens for navigation
class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Messages Screen'));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen'));
  }
}
