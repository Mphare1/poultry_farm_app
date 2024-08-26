import 'package:flutter/material.dart';
import 'auth_service.dart'; // Import your AuthService

class AuthCheck extends StatelessWidget {
  final Widget child;

  const AuthCheck({required this.child});

  Future<String?> _fetchUserRole() async {
    final token = ''; // Retrieve token from secure storage or provider
    final authService = AuthService();
    return await authService.fetchUserRole(token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _fetchUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            (snapshot.data != 'owner' && snapshot.data != 'manager')) {
          return Center(child: Text('Access Denied'));
        }
        return child;
      },
    );
  }
}
