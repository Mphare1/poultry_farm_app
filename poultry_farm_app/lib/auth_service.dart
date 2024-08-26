import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String apiUrl = 'http://10.0.2.2:3000/api/auth';

  Future<String?> fetchUserRole(String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['role'];
    } else {
      throw Exception('Failed to load user role');
    }
  }
}
