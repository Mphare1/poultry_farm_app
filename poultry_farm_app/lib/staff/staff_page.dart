import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StaffPage extends StatefulWidget {
  final String farmId;

  StaffPage({required this.farmId});

  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _staffList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStaffRecords();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  Future<void> _fetchStaffRecords() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/staff/${widget.farmId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _staffList =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        _showSnackBar('Failed to load staff records');
      }
    } catch (error) {
      _showSnackBar('Error: ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createStaff() async {
    if (_areFieldsEmpty(
        [_nameController.text, _roleController.text, widget.farmId])) {
      _showSnackBar('All fields are required');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/staff'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStaff(String id) async {
    if (_areFieldsEmpty([_nameController.text, _roleController.text])) {
      _showSnackBar('Name and Role are required');
      return;
    }

    setState(() {
      _isLoading = true;
    });
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _areFieldsEmpty(List<String> fields) {
    return fields.any((field) => field.trim().isEmpty);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createStaff();
              },
              child: Text('Add'),
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
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteStaff(id);
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

  Future<void> _deleteStaff(String id) async {
    setState(() {
      _isLoading = true;
    });
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _staffList.length,
                    itemBuilder: (context, index) {
                      final staff = _staffList[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(staff['name']),
                          subtitle: Text(staff['role']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                _showDeleteStaffDialog(staff['_id']),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Calendar for scheduling work days
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Work Days',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 10),
                      TableCalendar(
                        focusedDay: _selectedDate ?? DateTime.now(),
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDate = selectedDay;
                            _scheduleController.text =
                                DateFormat.yMMMMd().format(selectedDay);
                          });
                        },
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _selectedDate),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _scheduleController,
                        decoration: InputDecoration(
                          labelText: 'Selected Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedDate == null) {
                            _showSnackBar('Please select a date');
                          } else {
                            // Handle schedule update logic
                            _showSnackBar(
                                'Scheduled work day on ${_scheduleController.text}');
                          }
                        },
                        child: Text('Save Schedule'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
