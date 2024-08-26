import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

class StaffPage extends StatefulWidget {
  final String farmId; // Farm ID passed dynamically

  const StaffPage({Key? key, required this.farmId}) : super(key: key);

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  DateTime? _selectedDate;
  List<dynamic> _staffList = [];

  @override
  void initState() {
    super.initState();
    _fetchStaffRecords();
  }

  Future<void> _fetchStaffRecords() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/${widget.farmId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _staffList = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load staff records');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  Future<void> _createStaff() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String role = _roleController.text;

    if (name.isEmpty || email.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/staff'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'role': role,
          'farm_id': widget.farmId,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff added successfully')),
        );
        _fetchStaffRecords(); // Refresh staff list
        Navigator.of(context).pop(); // Close the dialog
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add staff: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${error.toString()}')),
      );
    }
  }

  Future<void> _updateStaff(String id) async {
    final String name = _nameController.text;
    final String role = _roleController.text;

    if (name.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Role are required')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/staff/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff updated successfully')),
        );
        _fetchStaffRecords(); // Refresh staff list
        Navigator.of(context).pop(); // Close the dialog
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update staff: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${error.toString()}')),
      );
    }
  }

  Future<void> _deleteStaff(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/staff/$id'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff deleted successfully')),
        );
        _fetchStaffRecords(); // Refresh staff list
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to delete staff: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${error.toString()}')),
      );
    }
  }

  Future<void> _assignSchedule(String staffId) async {
    if (_selectedDate == null || _scheduleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date and Schedule are required')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/staff/assign-schedule'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'staff_id': staffId,
          'date': _selectedDate!.toIso8601String(),
          'schedule': _scheduleController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule assigned successfully')),
        );
        _selectedDate = null; // Clear selected date
        _scheduleController.clear(); // Clear schedule text
        Navigator.of(context).pop(); // Close the dialog
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to assign schedule: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${error.toString()}')),
      );
    }
  }

  void _showAddStaffDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Staff'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: _scheduleController,
                decoration: InputDecoration(labelText: 'Schedule'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _createStaff();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateStaffDialog(String id) {
    final staff = _staffList.firstWhere((staff) => staff['_id'] == id);
    _nameController.text = staff['name'];
    _roleController.text = staff['role'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Staff'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateStaff(id);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignScheduleDialog(String staffId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Assign Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _scheduleController,
                decoration: InputDecoration(labelText: 'Schedule'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _assignSchedule(staffId);
              },
              child: Text('Assign'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteStaffDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Staff'),
          content: Text('Are you sure you want to delete this staff member?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteStaff(id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddStaffDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar widget for viewing schedules
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return _selectedDate != null &&
                  day.year == _selectedDate!.year &&
                  day.month == _selectedDate!.month &&
                  day.day == _selectedDate!.day;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _staffList.length,
              itemBuilder: (context, index) {
                final staff = _staffList[index];
                return ListTile(
                  title: Text(staff['name']),
                  subtitle: Text(staff['role']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showUpdateStaffDialog(staff['_id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteStaffDialog(staff['_id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.schedule),
                        onPressed: () {
                          _showAssignScheduleDialog(staff['_id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
