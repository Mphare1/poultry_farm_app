import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

class StaffPage extends StatefulWidget {
  final String farmId;

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _scheduleController.dispose();
    super.dispose();
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
      _showSnackBar('Error: ${error.toString()}');
    }
  }

  Future<void> _createStaff() async {
    if (_areFieldsEmpty(
        [_nameController.text, _emailController.text, _roleController.text])) {
      _showSnackBar('All fields are required');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/staff'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'role': _roleController.text,
          'farm_id': widget.farmId,
        }),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Staff added successfully');
        _fetchStaffRecords();
        Navigator.of(context).pop();
      } else {
        final responseData = json.decode(response.body);
        _showSnackBar('Failed to add staff: ${responseData['message']}');
      }
    } catch (error) {
      _showSnackBar('Network error: ${error.toString()}');
    }
  }

  Future<void> _updateStaff(String id) async {
    if (_areFieldsEmpty([_nameController.text, _roleController.text])) {
      _showSnackBar('Name and Role are required');
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/staff/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'role': _roleController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Staff updated successfully');
        _fetchStaffRecords();
        Navigator.of(context).pop();
      } else {
        final responseData = json.decode(response.body);
        _showSnackBar('Failed to update staff: ${responseData['message']}');
      }
    } catch (error) {
      _showSnackBar('Network error: ${error.toString()}');
    }
  }

  Future<void> _deleteStaff(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/staff/$id'),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Staff deleted successfully');
        _fetchStaffRecords();
      } else {
        final responseData = json.decode(response.body);
        _showSnackBar('Failed to delete staff: ${responseData['message']}');
      }
    } catch (error) {
      _showSnackBar('Network error: ${error.toString()}');
    }
  }

  Future<void> _assignSchedule(String staffId) async {
    if (_selectedDate == null || _scheduleController.text.isEmpty) {
      _showSnackBar('Date and Schedule are required');
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
        _showSnackBar('Schedule assigned successfully');
        _resetScheduleForm();
        Navigator.of(context).pop();
      } else {
        final responseData = json.decode(response.body);
        _showSnackBar('Failed to assign schedule: ${responseData['message']}');
      }
    } catch (error) {
      _showSnackBar('Network error: ${error.toString()}');
    }
  }

  bool _areFieldsEmpty(List<String> fields) {
    return fields.any((field) => field.isEmpty);
  }

  void _resetScheduleForm() {
    _selectedDate = null;
    _scheduleController.clear();
  }

  void _showAddStaffDialog() {
    _clearFields();
    _showStaffDialog('Add Staff', _createStaff);
  }

  void _showUpdateStaffDialog(String id) {
    final staff = _staffList.firstWhere((staff) => staff['_id'] == id);
    _nameController.text = staff['name'];
    _roleController.text = staff['role'];

    _showStaffDialog('Update Staff', () => _updateStaff(id));
  }

  void _showStaffDialog(String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_roleController, 'Role'),
              if (title == 'Add Staff')
                _buildTextField(_scheduleController, 'Schedule'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: onConfirm,
              child: Text(title.split(' ')[0]), // 'Add' or 'Update'
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignScheduleDialog(String staffId) {
    _scheduleController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Assign Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_scheduleController, 'Schedule'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => _assignSchedule(staffId),
              child: Text('Assign'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  TextField _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _roleController.clear();
    _scheduleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
          const SizedBox(height: 10),
          Expanded(
            child: _staffList.isEmpty
                ? const Center(child: Text('No staff found.'))
                : ListView.builder(
                    itemCount: _staffList.length,
                    itemBuilder: (context, index) {
                      final staff = _staffList[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            staff['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Role: ${staff['role']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateStaffDialog(staff['_id']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteStaffDialog(staff['_id']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.schedule),
                                onPressed: () {
                                  _showAssignScheduleDialog(staff['_id']);
                                },
                              ),
                            ],
                          ),
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
