import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _farmNameController =
      TextEditingController(); // Add this for farm name

  String _selectedRole = 'worker'; // Default role

  Future<void> _signup() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    final String farmName = _farmNameController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    const String url = 'http://10.0.2.2:3000/api/auth/signup';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': name,
          'email': email,
          'password': password,
          'role': _selectedRole,
          'farm_name': _selectedRole == 'owner' || _selectedRole == 'manager'
              ? farmName
              : null,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully')),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to create user: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffB81736),
                Color(0xff281537),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Full Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffB81736),
                            ),
                          )),
                    ),
                    // Add a dropdown to select role
                    DropdownButton<String>(
                      value: _selectedRole,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                        });
                      },
                      items: <String>['owner', 'manager', 'worker']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // Add a text field for farm name if role is owner or manager
                    if (_selectedRole == 'owner' ||
                        _selectedRole == 'manager') ...[
                      TextField(
                        controller: _farmNameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.business,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'Farm Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffB81736),
                              ),
                            )),
                      ),
                    ],
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: _signup,
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(colors: [
                            Color(0xffB81736),
                            Color(0xff281537),
                          ]),
                        ),
                        child: const Center(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Don't have account?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
