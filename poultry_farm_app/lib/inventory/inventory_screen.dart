import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_edit_inventory.dart';

class InventoryPage extends StatefulWidget {
  final String farmId;
  InventoryPage({required this.farmId});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<dynamic> _inventory = [];
  bool _isLoading = false;
  String _filter = 'All';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/api/inventory/${widget.farmId}?type=$_filter'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _inventory = json.decode(response.body);
        });
      } else {
        _showSnackBar('Failed to load inventory');
      }
    } catch (error) {
      _showSnackBar('Error: ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchInventory,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFilterDropdown(),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _inventory.length,
                      itemBuilder: (context, index) {
                        final item = _inventory[index];
                        return _buildInventoryCard(item);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddEditDialog(null),
                    child: Text('Add Inventory'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      textStyle: const TextStyle(color: Colors.white),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButtonFormField<String>(
      value: _filter,
      items: <String>['All', 'Layer', 'Broiler'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _filter = newValue ?? 'All';
          _fetchInventory();
        });
      },
      decoration: InputDecoration(
        labelText: 'Filter by Type',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text('${item['type']} - ${item['quantity']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: ${item['age']} weeks'),
            Text('Feed: ${item['feed']} kg'),
            if (item['type'] == 'Layer') ...[
              Text('Eggs Collected: ${item['eggsCollected']}'),
            ] else if (item['type'] == 'Broiler') ...[
              Text('Average Weight: ${item['weight']} kg'),
            ],
            Text('Health Status: ${item['healthStatus']}'),
          ],
        ),
        trailing: Wrap(
          spacing: 12,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.teal),
              onPressed: () => _showAddEditDialog(item),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(item['_id']),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteInventory(id);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteInventory(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/inventory/$id'),
      );
      if (response.statusCode == 200) {
        _showSnackBar('Item deleted successfully');
        _fetchInventory();
      } else {
        _showSnackBar('Failed to delete item');
      }
    } catch (error) {
      _showSnackBar('Error: ${error.toString()}');
    }
  }

  void _showAddEditDialog(Map<String, dynamic>? item) {
    showDialog(
      context: context,
      builder: (context) => AddEditInventoryDialog(
        inventoryId: item?['_id'],
        farmId: widget.farmId,
        existingItem: item,
      ),
    );
  }
}
