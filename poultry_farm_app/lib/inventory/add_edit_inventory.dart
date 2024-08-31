import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEditInventoryDialog extends StatefulWidget {
  final String? inventoryId;
  final String farmId;
  final Map<String, dynamic>? existingItem;

  AddEditInventoryDialog(
      {this.inventoryId, required this.farmId, this.existingItem});

  @override
  _AddEditInventoryDialogState createState() => _AddEditInventoryDialogState();
}

class _AddEditInventoryDialogState extends State<AddEditInventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _ageController = TextEditingController();
  final _feedController = TextEditingController();
  final _healthStatusController = TextEditingController();
  final _weightController = TextEditingController();
  final _eggsCollectedController = TextEditingController();
  String _type = 'Layer'; // Default type

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _type = item['type'];
      _typeController.text = item['type'];
      _quantityController.text = item['quantity'].toString();
      _ageController.text = item['age'].toString();
      _feedController.text = item['feed'].toString();
      _healthStatusController.text = item['healthStatus'];
      if (_type == 'Broiler') {
        _weightController.text = item['weight'].toString();
      } else if (_type == 'Layer') {
        _eggsCollectedController.text = item['eggsCollected'].toString();
      }
    }
  }

  Future<void> _saveInventory() async {
    if (_formKey.currentState?.validate() ?? false) {
      final inventoryData = {
        'farm': widget.farmId,
        'type': _type,
        'quantity': int.parse(_quantityController.text),
        'age': int.parse(_ageController.text),
        'feed': double.parse(_feedController.text),
        'healthStatus': _healthStatusController.text,
        if (_type == 'Layer')
          'eggsCollected': int.parse(_eggsCollectedController.text),
        if (_type == 'Broiler') 'weight': double.parse(_weightController.text),
      };

      try {
        final url = widget.inventoryId == null
            ? 'http://10.0.2.2:3000/api/inventory'
            : 'http://10.0.2.2:3000/api/inventory/${widget.inventoryId}';

        final response = widget.inventoryId == null
            ? await http.post(Uri.parse(url),
                body: json.encode(inventoryData),
                headers: {'Content-Type': 'application/json'})
            : await http.put(Uri.parse(url),
                body: json.encode(inventoryData),
                headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          Navigator.of(context).pop();
        } else {
          _showSnackBar('Failed to save inventory');
        }
      } catch (error) {
        _showSnackBar('Error: ${error.toString()}');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.inventoryId == null ? 'Add Inventory' : 'Edit Inventory'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: <String>['Layer', 'Broiler'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue ?? 'Layer';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age (weeks)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Age is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _feedController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Feed (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Feed amount is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _healthStatusController,
                decoration: InputDecoration(
                  labelText: 'Health Status',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Health status is required';
                  }
                  return null;
                },
              ),
              if (_type == 'Broiler') ...[
                SizedBox(height: 12),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Weight is required';
                    }
                    return null;
                  },
                ),
              ] else if (_type == 'Layer') ...[
                SizedBox(height: 12),
                TextFormField(
                  controller: _eggsCollectedController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Eggs Collected',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Eggs collected is required';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveInventory,
          child: Text(widget.inventoryId == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
